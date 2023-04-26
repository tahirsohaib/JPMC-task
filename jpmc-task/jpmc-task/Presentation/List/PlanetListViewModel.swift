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
    @Published var isLoading: Bool = false

    @Injected private var getAllPlanetsUseCase: GetAllPlanetsUseCaseProtocol
    
    init() {
        fetchPlanets()
    }

    func fetchPlanets() {
        isLoading = true // Set loading state to true
        getAllPlanetsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // ideally show an alert to the user
                    print("Failed to fetch planets: \(error.localizedDescription)")
                    break
                }
            }, receiveValue: { [weak self] planets in
                self?.planets = planets
            })
            .store(in: &cancellables)
    }
    
    func syncRemoteAndLocal() {
        isLoading = true // Set loading state to true

        getAllPlanetsUseCase.syncLocalRepoWithRemoteRepo()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // ideally show an alert to the user
                    print("Failed to fetch planets: \(error.localizedDescription)")
                    break
                }
            }, receiveValue: { [weak self] planets in
                self?.planets = planets
            })
            .store(in: &cancellables)
    }
}
