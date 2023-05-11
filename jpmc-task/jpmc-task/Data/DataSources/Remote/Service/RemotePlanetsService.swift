//
//  RemotePlanetsService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

protocol RemotePlanetsServiceProtocol {
    func fetchPlanets() -> AnyPublisher<[PlanetRemoteEntity], DataSourceError>
}

class RemotePlanetsService: RemotePlanetsServiceProtocol {
    @Injected private var networkService: NetworkServiceProtocol

    func fetchPlanets() -> AnyPublisher<[PlanetRemoteEntity], DataSourceError> {
        networkService.get(PlanetsResponseRemoteEntity.self, endpoint: PlanetsEndpoint.allPlanets)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}
