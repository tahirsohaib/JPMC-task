//
//  PlanetsReposiroty.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 22/04/2023.
//

import Combine
import Foundation

protocol PlanetsRepositoryProtocol {
    func getAllPlanets() -> AnyPublisher<[PlanetModel], Error>
    func syncRemoteAndLocal() -> AnyPublisher<[PlanetModel], Error>
}
