//
//  RemotePlanetsService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Combine
import Foundation

protocol RemotePlanetsServiceProtocol {
    func fetchPlanets() -> AnyPublisher<[PlanetRemoteEntity], Error>
}

class RemotePlanetsService: RemotePlanetsServiceProtocol {
    let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchPlanets() -> AnyPublisher<[PlanetRemoteEntity], Error> {
        networkService.get(PlanetsEndpoint.allPlanets)
            .eraseToAnyPublisher()
    }
}
