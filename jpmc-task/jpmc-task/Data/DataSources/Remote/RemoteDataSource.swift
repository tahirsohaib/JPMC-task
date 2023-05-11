//
//  RemoteDataSource.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

class RemoteDataSource: RemoteDataSourceProtocol {
    @Injected private var remoteService: RemotePlanetsServiceProtocol

    private func mapPlanetRemoteToResponse(remoteEntity: PlanetRemoteEntity) -> PlanetModel {
        return PlanetModel(name: remoteEntity.name, population: remoteEntity.population, terrain: remoteEntity.terrain)
    }

    func getAllPlanetsRemote() -> AnyPublisher<[PlanetModel], DataSourceError> {
        remoteService.fetchPlanets()
            .map { planetRemoteEntities in
                planetRemoteEntities.map { self.mapPlanetRemoteToResponse(remoteEntity: $0) }
            }
            .eraseToAnyPublisher()
    }
}
