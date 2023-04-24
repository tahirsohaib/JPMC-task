//
//  GetAllPlanetsUC.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 22/04/2023.
//

import Combine
import Foundation

protocol GetAllPlanetsUseCaseProtocol {
    func execute() -> AnyPublisher<[PlanetModel], Error>
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], Error>
}

class GetAllPlanetsUC: GetAllPlanetsUseCaseProtocol {
    @Injected private var planetRepo: PlanetsRepositoryProtocol

    func execute() -> AnyPublisher<[PlanetModel], Error> {
        return planetRepo.getAllPlanets()
            .eraseToAnyPublisher()
    }

    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], Error> {
        return planetRepo.syncLocalRepoWithRemoteRepo()
            .eraseToAnyPublisher()
    }
}
