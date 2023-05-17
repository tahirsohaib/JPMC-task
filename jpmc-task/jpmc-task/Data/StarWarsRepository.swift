//
//  StawWarsRepository.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

class StarWarsRepository: StarWarsRepositoryProtocol {
    
    @Injected private var remoteDataSource: RemoteDataSourceProtocol
    @Injected private var localDataSource: LocalDataSourceProtocol

    func getAllPlanets() -> AnyPublisher<[PlanetModel], DataSourceError> {
        return localDataSource.getAllPlanetsLocal()
            .eraseToAnyPublisher()
    }

    func syncLocalPlanetsRepoWithRemote() -> AnyPublisher<[PlanetModel], DataSourceError> {
        remoteDataSource.getAllPlanetsRemote()
            .flatMap { planetModels in
                self.localDataSource.syncAllPlanetsWithRemote(planetModels)
            }
            .eraseToAnyPublisher()
    }
    
    func getFilm(filmID: String) -> AnyPublisher<FilmModel, DataSourceError> {
        remoteDataSource.getFilmRemote(filmID: filmID)
            .eraseToAnyPublisher()
    }
    
    func getResident(residentID: String) -> AnyPublisher<ResidentModel, DataSourceError> {
        remoteDataSource.getResidentRemote(residentID: residentID)
            .eraseToAnyPublisher()
    }
}
