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
     
    func createPlanet(_ planetRequestModel: PlanetModel) -> AnyPublisher<PlanetModel, Error>  {
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
