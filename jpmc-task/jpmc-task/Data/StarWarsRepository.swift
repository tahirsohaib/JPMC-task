//
//  StawWarsRepository.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Combine
import Foundation

class StarWarsRepository: PlanetsRepositoryProtocol {
    @Injected private var remoteDataSource: RemoteDataSourceProtocol
    @Injected private var localDataSource: LocalDataSourceProtocol

    private func mapPlanetRemoteToRequest(remoteEntity: PlanetRemoteEntity) -> PlanetModel {
        return PlanetModel(name: remoteEntity.name, population: remoteEntity.population, terrain: remoteEntity.terrain)
    }

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
