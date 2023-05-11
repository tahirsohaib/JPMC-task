//
//  PlanetsReposiroty.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

protocol PlanetsRepositoryProtocol {
    func getAllPlanets() -> AnyPublisher<[PlanetModel], DataSourceError>
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], DataSourceError>
}
