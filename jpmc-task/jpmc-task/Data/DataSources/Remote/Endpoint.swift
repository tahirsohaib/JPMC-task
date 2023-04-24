//
//  APIError.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Foundation

protocol Endpoint: Equatable {
    var baseUrl: String { get }
    var path: String { get }
}

enum PlanetsEndpoint: Endpoint {
    case allPlanets
    case onePlanet(planetId: String)
    var baseUrl: String {
        return Constants.BaseURL
    }

    var path: String {
        switch self {
        case .allPlanets:
            return "/planets"
        case let .onePlanet(planetId):
            return "/planets/\(planetId)"
        }
    }
}

enum Constants {
    static let BaseURL = "https://swapi.dev/api"
}

extension Endpoint {
    func makeURL() -> URL? {
        return URL(string: "\(baseUrl)\(path)")
    }
}
