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
}

extension PlanetRemoteEntity {
    
    static let mockPlanetRemoteEntity: PlanetRemoteEntity = PlanetRemoteEntity(name: "Earth", population: "7.9 billion", terrain: "desert")
    
    static let mockPlanetRemoteEntities: [PlanetRemoteEntity] = [PlanetRemoteEntity(name: "Earth", population: "7.9 billion", terrain: "desert"),
                                                                 PlanetRemoteEntity(name: "Mars", population: "Unknown", terrain: "mountains")]
}
