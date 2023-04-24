//
//  DataSourceProtocol.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation
import Combine

protocol RemoteDataSourceProtocol {
    func getAll() -> AnyPublisher<[PlanetModel], Error>
}

protocol LocalDataSourceProtocol {
    func getAll() -> AnyPublisher<[PlanetModel], Error>
    func create(_ planetRequestModel: PlanetModel) -> AnyPublisher<Bool, Error>
}
