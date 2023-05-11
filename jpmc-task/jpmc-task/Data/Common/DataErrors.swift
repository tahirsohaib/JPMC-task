//
//  DataErrors.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 10/05/2023.
//

enum DataSourceError: Error {
    case localInvalidPlanetEntity
    case localFetchError
    case localSaveError
    case localSyncError
        
    case remoteDecodingError
    case remoteErrorCode(Int)
    case remoteBadURLResponse(url: String)
    case remoteBadURLRequest(url: String)
    case remoteUnknown
    case remoteTimeout
    
}
