//
//  StawWarsRepository.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation
import Combine

class StawWarsRepository: PlanetsRepositoryProtocol {
    private var remoteDataSource: RemoteDataSourceProtocol
    private var localDataSource: LocalDataSourceProtocol
    
    init(remoteDataSource: RemoteDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    private func mapPlanetRemoteToRequest(remoteEntity: PlanetRemoteEntity) -> PlanetModel {
        return PlanetModel(name: remoteEntity.name, population: remoteEntity.population, terrain: remoteEntity.terrain)
    }
        
    func getAllPlanets() -> AnyPublisher<[PlanetModel], Error> {
        return remoteDataSource.getAll()
            .eraseToAnyPublisher()
    }
    
//    func syncAllPlanets() -> AnyPublisher<[PlanetModel], Error> {
        // fetch from remote
//        remoteDataSource.getAll()
//            .map { planetRemoteEntities in
//                planetRemoteEntities.map { self.mapPlanetRemoteToRequest(remoteEntity: $0) }
//            }
//            .map { <#[PlanetResponseModel]#> in
//                <#code#>
//            }
        // save to db
        // return the updated values to refresh
        
//    }
    
    func createPlanet(_ planetRequestModel: PlanetModel) -> AnyPublisher<Bool, Error> {
        return localDataSource.create(planetRequestModel)
            .eraseToAnyPublisher()
    }
}
