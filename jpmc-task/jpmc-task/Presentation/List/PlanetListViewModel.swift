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
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
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
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] planets in
                self?.planets = planets
            })
            .store(in: &cancellables)
    }
    
    func syncRemoteAndLocal() {
        isLoading = true // Set loading state to true
        
        getAllPlanetsUseCase.syncLocalPlanetsRepoWithRemoteRepo()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            }, receiveValue: { [weak self] planets in
                self?.planets = planets
            })
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: UseCaseError) {
        errorMessage = mapErrorToString(error)
        showAlert = true
    }
    
    func dismissAlert() {
        errorMessage = ""
        showAlert = false
    }
    
    private func mapErrorToString(_ error: UseCaseError) -> String {
        switch error {
        case .fetchError:
            return "failed to fetch planets."
        case .saveError:
            return "failed to save planets."
        case .unknownError:
            return "unknown error occurred."
        }
    }
}
