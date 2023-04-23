//
//  RemoteDataSource.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation
import Combine

class RemoteDataSource: PlanetDataSourceProtocol {
    private var remoteService: RemotePlanetsServiceProtocol
    init(remoteService: RemotePlanetsServiceProtocol) {
        self.remoteService = remoteService
    }
    
    private func mapPlanetRemoteToResponse(remoteEntity: PlanetRemoteEntity) -> PlanetResponseModel {
        return PlanetResponseModel(name: remoteEntity.name, terrain: remoteEntity.terrain, population: remoteEntity.population)
    }
    
    func getAll() -> AnyPublisher<[PlanetResponseModel], Error> {
        remoteService.fetchPlanets()
                .map { planetRemoteEntities in
                    planetRemoteEntities.map { self.mapPlanetRemoteToResponse(remoteEntity: $0) }
                }
            .eraseToAnyPublisher()
    }
    
    func getOne(_ id: String) -> AnyPublisher<PlanetResponseModel, StarWarsError> {
        return Fail(error: StarWarsError.Get).eraseToAnyPublisher()
    }
    

}
