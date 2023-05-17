//
//  RemoteFilmsService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import Combine
import Foundation

protocol RemoteFilmsServiceProtocol {
    func fetchFilms(filmId: String) -> AnyPublisher<FilmRemoteEntity, DataSourceError>
}

class RemoteFilmsService: RemoteFilmsServiceProtocol {
    @Injected private var networkService: NetworkServiceProtocol
    
    func fetchFilms(filmId: String) -> AnyPublisher<FilmRemoteEntity, DataSourceError> {
        networkService.get(FilmRemoteEntity.self, endpoint: StarWarsEndpoint.film(filmId: filmId))
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

