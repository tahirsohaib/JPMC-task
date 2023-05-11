//
//  DomainErrors.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 11/05/2023.
//

import Foundation

enum UseCaseError: Error {
    case fetchError
    case saveError
    case unknownError
}


//enum DataSourceError: Error {
//    case localInvalidPlanetEntity
//    case localFetchError
//    case localSaveError
//    case localSyncError
//
//    case remoteDecodingError
//    case remoteErrorCode(Int)
//    case remoteBadURLResponse(url: String)
//    case remoteBadURLRequest(url: String)
//    case remoteUnknown
//    case remoteTimeout
//
//}
