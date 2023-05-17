//
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Foundation

protocol Endpoint: Equatable {
    var baseUrl: String { get }
    var path: String { get }
}

enum StarWarsEndpoint: Endpoint {
    case allPlanets
    case onePlanet(planetId: String)
    case film(filmId: String)
    case resident(residentId: String)
    var baseUrl: String {
        return Constants.BaseURL
    }

    var path: String {
        switch self {
        case .allPlanets:
            return "/planets"
        case let .onePlanet(planetId):
            return "/planets/\(planetId)"
        case .film(filmId: let filmId):
            return "/films/\(filmId)"
        case .resident(residentId: let residentId):
            return "/people/\(residentId)"
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
