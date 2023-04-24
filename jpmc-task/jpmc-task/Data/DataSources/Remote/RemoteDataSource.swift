//
//  RemoteDataSource.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Combine
import Foundation

class RemoteDataSource: RemoteDataSourceProtocol {
    private var remoteService: RemotePlanetsServiceProtocol
    init(remoteService: RemotePlanetsServiceProtocol) {
        self.remoteService = remoteService
    }

    private func mapPlanetRemoteToResponse(remoteEntity: PlanetRemoteEntity) -> PlanetModel {
        return PlanetModel(name: remoteEntity.name, population: remoteEntity.population, terrain: remoteEntity.terrain)
    }

    func getAll() -> AnyPublisher<[PlanetModel], Error> {
        remoteService.fetchPlanets()
            .map { planetRemoteEntities in
                planetRemoteEntities.map { self.mapPlanetRemoteToResponse(remoteEntity: $0) }
            }
            .eraseToAnyPublisher()
    }

    func getOne(_ id: String) -> AnyPublisher<PlanetModel, StarWarsError> {
        return Fail(error: StarWarsError.Get).eraseToAnyPublisher()
    }
    

}
