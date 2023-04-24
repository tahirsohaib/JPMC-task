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

    func createPlanet(_ planetRequestModel: PlanetModel) -> AnyPublisher<PlanetModel, Error> {
        localDataSource.create(planetRequestModel)
            .eraseToAnyPublisher()
    }

    func getAllPlanets() -> AnyPublisher<[PlanetModel], Error> {
        return localDataSource.getAll()
            .eraseToAnyPublisher()
    }

    func syncRemoteAndLocal() -> AnyPublisher<[PlanetModel], Error> {
        remoteDataSource.getAll()
            .flatMap { planetModels in
                self.localDataSource.syncAllPlanets(planetModels)
            }
            .eraseToAnyPublisher()
    }
}
