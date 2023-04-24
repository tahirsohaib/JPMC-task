//
//  APIError.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation

protocol Endpoint: Equatable {
    var baseUrl:String { get }
    var path:String { get }
    var apiKey:String { get }
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
        case .onePlanet(let planetId):
            return "/planets/\(planetId)"
        }        
    }
    
    var apiKey: String {
        return ""
    }
}


enum Constants {
    static let BaseURL = "https://swapi.dev/api/"
    static let apiKey =  ""
}

extension Endpoint {
    func makeURL() -> URL? {
        guard let urlComponents = NSURLComponents(string: self.baseUrl) else { return nil }
        urlComponents.path = self.path
//        urlComponents.queryItems = [
//            URLQueryItem(name: "api_key", value: self.apiKey)
//        ]
        return urlComponents.url
    }
}
