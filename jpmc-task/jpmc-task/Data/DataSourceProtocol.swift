//
//  DataSourceProtocol.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

protocol RemoteDataSourceProtocol {
    func getAllPlanetsRemote() -> AnyPublisher<[PlanetModel], DataSourceError>
    func getFilmRemote(filmID: String) -> AnyPublisher<FilmModel, DataSourceError>
    func getResidentRemote(residentID: String) -> AnyPublisher<ResidentModel, DataSourceError>
}

protocol LocalDataSourceProtocol {
    func getAllPlanetsLocal() -> AnyPublisher<[PlanetModel], DataSourceError>
    func syncAllPlanetsWithRemote(_ remoteData: [PlanetModel]) -> AnyPublisher<[PlanetModel], DataSourceError>
}
