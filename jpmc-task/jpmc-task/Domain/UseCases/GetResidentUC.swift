//
//  GetResidentUC.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import Foundation
import Combine

protocol GetResidentUseCaseProtocol {
    func execute(residentID: String) -> AnyPublisher<ResidentModel, UseCaseError>
}

class GetResidentUC: GetResidentUseCaseProtocol {
    @Injected private var starWarsRepo: StarWarsRepositoryProtocol
    
    func execute(residentID: String) -> AnyPublisher<ResidentModel, UseCaseError> {
        return starWarsRepo.getResident(residentID: residentID)
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
