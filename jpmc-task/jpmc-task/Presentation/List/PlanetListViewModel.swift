//
//  PlanetListViewModel.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

class PlanetListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let getAllPlanetsUseCase: GetAllPlanetsUC

    @Published var planets: [PlanetModel] = []

    init(getAllPlanetsUseCase: GetAllPlanetsUC) {
        self.getAllPlanetsUseCase = getAllPlanetsUseCase
        fetchPlanets()
    }

    func fetchPlanets() {
        getAllPlanetsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .catch { error -> Empty<[PlanetModel], Never> in
                print("Failed to fetch planets: \(error.localizedDescription)")
                return Empty<[PlanetModel], Never>()
            }
            .sink(receiveValue: { planets in
                self.planets = planets
            })
            .store(in: &cancellables)
    }

    func syncRemoteAndLocal() {
        getAllPlanetsUseCase.sync()
            .receive(on: DispatchQueue.main)
            .catch { error -> Empty<[PlanetModel], Never> in
                print("Failed to synchronize planets: \(error.localizedDescription)")
                return Empty<[PlanetModel], Never>()
            }
            .sink(receiveValue: { planets in
                self.planets = planets
            })
            .store(in: &cancellables)
    }
}
