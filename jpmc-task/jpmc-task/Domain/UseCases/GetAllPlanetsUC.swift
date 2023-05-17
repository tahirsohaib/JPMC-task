//
//  GetAllPlanetsUC.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

protocol GetAllPlanetsUseCaseProtocol {
    func execute() -> AnyPublisher<[PlanetModel], UseCaseError>
    func syncLocalPlanetsRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], UseCaseError>
}

class GetAllPlanetsUC: GetAllPlanetsUseCaseProtocol {
    @Injected private var planetRepo: StarWarsRepositoryProtocol
    
    func execute() -> AnyPublisher<[PlanetModel], UseCaseError> {
        return planetRepo.getAllPlanets()
            .mapError { error -> UseCaseError in
                self.mapDataSourceErrorToUseCaseError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func syncLocalPlanetsRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], UseCaseError> {
        return planetRepo.syncLocalPlanetsRepoWithRemote()
            .mapError { error -> UseCaseError in
                self.mapDataSourceErrorToUseCaseError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func mapDataSourceErrorToUseCaseError(_ error: DataSourceError) -> UseCaseError {
        switch error {
        case .localFetchError, .remoteTimeout:
            return .fetchError
        case .localSaveError, .localSyncError:
            return .saveError
        default:
            return .unknownError
        }
    }
}
