//
//  StawWarsRepository.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

class StarWarsRepository: PlanetsRepositoryProtocol {
    @Injected private var remoteDataSource: RemoteDataSourceProtocol
    @Injected private var localDataSource: LocalDataSourceProtocol

    func getAllPlanets() -> AnyPublisher<[PlanetModel], Error> {
        return localDataSource.getAllPlanetsLocal()
            .eraseToAnyPublisher()
    }

    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], Error> {
        remoteDataSource.getAllPlanetsRemote()
            .flatMap { planetModels in
                self.localDataSource.syncAllPlanetsWithRemote(planetModels)
            }
            .eraseToAnyPublisher()
    }
}
