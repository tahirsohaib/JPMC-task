//
//  GetFilmUC.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import Foundation
import Combine

protocol GetFilmUseCaseProtocol {
    func execute(filmID: String) -> AnyPublisher<FilmModel, UseCaseError>
}

class GetFilmUC: GetFilmUseCaseProtocol {
    
    @Injected private var starWarsRepo: StarWarsRepositoryProtocol
    
    func execute(filmID: String) -> AnyPublisher<FilmModel, UseCaseError> {
        return starWarsRepo.getFilm(filmID: filmID)
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
