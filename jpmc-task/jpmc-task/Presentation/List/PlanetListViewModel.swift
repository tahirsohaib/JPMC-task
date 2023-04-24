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

    @Published var planets: [PlanetModel] = []

    @Injected private var getAllPlanetsUseCase: GetAllPlanetsUseCaseProtocol
    
    init() {
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
        getAllPlanetsUseCase.syncLocalRepoWithRemoteRepo()
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
