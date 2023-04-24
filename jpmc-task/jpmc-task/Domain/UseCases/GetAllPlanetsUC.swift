//
//  GetAllPlanetsUC.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 22/04/2023.
//

import Foundation
import Combine

protocol GetAllPlanetsUseCaseProtocol {
    func execute() -> AnyPublisher<[PlanetModel], Error>
}


class GetAllPlanetsUC: GetAllPlanetsUseCaseProtocol {
    private var planetRepo: PlanetsRepositoryProtocol
    
    init(planetRepo: PlanetsRepositoryProtocol) {
        self.planetRepo = planetRepo
    }
         
    func execute() -> AnyPublisher<[PlanetModel], Error> {
        return planetRepo.getAllPlanets()
            .eraseToAnyPublisher()
    }
    
    
    func sync() -> AnyPublisher<[PlanetModel], Error> {
        return planetRepo.syncRemoteAndLocal()
            .eraseToAnyPublisher()
    }
}
