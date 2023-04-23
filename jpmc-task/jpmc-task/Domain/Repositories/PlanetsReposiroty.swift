//
//  PlanetsReposiroty.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 22/04/2023.
//

import Foundation
import Combine

protocol PlanetsRepositoryProtocol {
    func getAllPlanets() -> AnyPublisher<[PlanetResponseModel], Error>
}
