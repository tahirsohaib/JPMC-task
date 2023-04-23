//
//  PlanetListViewModel.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Foundation
import Combine

class PlanetListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let getAllPlanetsUseCase: GetAllPlanetsUC
    static private let meUni:String  = ""
    @Published var planets: [PlanetResponseModel] = []
    
    init(getAllPlanetsUseCase: GetAllPlanetsUC) {
        self.getAllPlanetsUseCase = getAllPlanetsUseCase
    }
    
    func fetchPlanets() {
        getAllPlanetsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink{ res in
                switch res {
                case .finished:
                    print("Success")
                case .failure(let error):
                    print("Failure: \(error.localizedDescription)")
                }
            } receiveValue: { planets in
                self.planets = planets
            }
            .store(in: &cancellables)
    }    
}

