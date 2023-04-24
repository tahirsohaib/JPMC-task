//
//  DataSourceProtocol.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Combine
import Foundation

protocol RemoteDataSourceProtocol {
    func getAll() -> AnyPublisher<[PlanetModel], Error>
}

protocol LocalDataSourceProtocol {
    func getAll() -> AnyPublisher<[PlanetModel], Error>
    func syncAllPlanets(_ serverData: [PlanetModel]) -> AnyPublisher<[PlanetModel], Error>
}
