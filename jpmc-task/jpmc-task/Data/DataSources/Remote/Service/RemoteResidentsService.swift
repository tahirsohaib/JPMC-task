//
//  RemoteResidentsService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import Combine
import Foundation

protocol RemoteResidentsServiceProtocol {
    func fetchResidents(residentId: String) -> AnyPublisher<ResidentRemoteEntity, DataSourceError>
}

class RemoteResidentsService: RemoteResidentsServiceProtocol {
    @Injected private var networkService: NetworkServiceProtocol
    
    func fetchResidents(residentId: String) -> AnyPublisher<ResidentRemoteEntity, DataSourceError> {
        networkService.get(ResidentRemoteEntity.self, endpoint: StarWarsEndpoint.resident(residentId: residentId))
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
