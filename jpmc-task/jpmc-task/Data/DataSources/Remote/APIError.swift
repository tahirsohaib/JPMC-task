//
//  APIError.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case badURLResponse(url: String)
    case badURLRequest(url: String)
    case unknown
    case timeout
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode the object"
        case let .errorCode(code):
            return "\(code) - Something went wrong."
        case let .badURLResponse(url: url):
            return "Bad response from URL: \(url)"
        case let .badURLRequest(url: url):
            return "bad URL Request: \(url)"
        case .unknown:
            return "Unknown error occured"
        case .timeout:
            return "Server not responding"
        }
    }
}
