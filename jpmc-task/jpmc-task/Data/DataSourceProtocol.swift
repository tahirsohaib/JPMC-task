//
//  DataSourceProtocol.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

protocol RemoteDataSourceProtocol {
    func getAllPlanetsRemote() -> AnyPublisher<[PlanetModel], Error>
}

protocol LocalDataSourceProtocol {
    func getAllPlanetsLocal() -> AnyPublisher<[PlanetModel], Error>
    func syncAllPlanetsWithRemote(_ serverData: [PlanetModel]) -> AnyPublisher<[PlanetModel], Error>
}
