//
//  DataSourceProtocol.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation
import Combine

protocol PlanetDataSourceProtocol {
    func getAll() -> AnyPublisher<[PlanetResponseModel], Error>
//    func getOne(_ id: String) -> AnyPublisher<PlanetResponseModel, StarWarsError>
}
