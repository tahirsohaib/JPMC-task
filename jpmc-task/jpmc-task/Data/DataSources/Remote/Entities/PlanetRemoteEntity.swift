//
//  Planet.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Foundation

struct PlanetRemoteEntity: Hashable, Codable {
    let name: String
    let population: String
    let terrain: String
    let filmURLs: [String]
    let residentURLs: [String]
    let filmObjects: [FilmRemoteEntity]?
    let residentObjects: [ResidentRemoteEntity]?
    
    var filmIDs: [String] {
        return filmURLs.compactMap {
            String(URL(string: $0)?.lastPathComponent ?? "")
        }
    }
    
    var residentIDs: [String] {
        return residentURLs.compactMap {
            String(URL(string: $0)?.lastPathComponent ?? "")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case terrain
        case population
        case filmURLs = "films"
        case residentURLs = "residents"
        case filmObjects
        case residentObjects
    }
}

extension PlanetRemoteEntity {
    
    static let mockPlanetRemoteEntity: PlanetRemoteEntity = PlanetRemoteEntity(name: "Earth", population: "7.9 billion", terrain: "desert", filmURLs: ["https://swapi.dev/api/films/1/"], residentURLs: ["https://swapi.dev/api/people/1/"], filmObjects: nil, residentObjects: nil)
    
    static let mockPlanetRemoteEntities: [PlanetRemoteEntity] =
    [PlanetRemoteEntity(name: "Earth", population: "7.9 billion", terrain: "desert", filmURLs: ["https://swapi.dev/api/films/1/"], residentURLs: ["https://swapi.dev/api/people/1/"], filmObjects: nil, residentObjects: nil),
     PlanetRemoteEntity(name: "Mars", population: "Unknown", terrain: "mountains", filmURLs: ["https://swapi.dev/api/films/2/"], residentURLs: ["https://swapi.dev/api/people/2/"], filmObjects: nil, residentObjects: nil)]
}
