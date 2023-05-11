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
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], UseCaseError>
}

class GetAllPlanetsUC: GetAllPlanetsUseCaseProtocol {
    @Injected private var planetRepo: PlanetsRepositoryProtocol
    
    func execute() -> AnyPublisher<[PlanetModel], UseCaseError> {
        return planetRepo.getAllPlanets()
            .mapError { error -> UseCaseError in
                self.mapDataSourceErrorToUseCaseError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], UseCaseError> {
        return planetRepo.syncLocalRepoWithRemoteRepo()
            .mapError { error -> UseCaseError in
                self.mapDataSourceErrorToUseCaseError(error)
            }
            .eraseToAnyPublisher()
    }
    
    private func mapDataSourceErrorToUseCaseError(_ error: DataSourceError) -> UseCaseError {
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

//case localInvalidPlanetEntity
//case localFetchError
//case localSaveError
//case localSyncError
//
//case remoteDecodingError
//case remoteErrorCode(Int)
//case remoteBadURLResponse(url: String)
//case remoteBadURLRequest(url: String)
//case remoteUnknown
//case remoteTimeout
