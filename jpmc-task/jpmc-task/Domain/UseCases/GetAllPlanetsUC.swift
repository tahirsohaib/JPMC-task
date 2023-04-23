//
//  GetAllPlanetsUC.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 22/04/2023.
//

import Foundation
import Combine

protocol GetAllPlanetsUseCaseProtocol {
    func execute() -> AnyPublisher<[PlanetResponseModel], Error>
}


class GetAllPlanetsUC: GetAllPlanetsUseCaseProtocol {
    private var planetRepo: PlanetsRepositoryProtocol
    
    init(planetRepo: PlanetsRepositoryProtocol) {
        self.planetRepo = planetRepo
    }
         
    func execute() -> AnyPublisher<[PlanetResponseModel], Error> {
        return planetRepo.getAllPlanets()
            .eraseToAnyPublisher()
    }
    
}
