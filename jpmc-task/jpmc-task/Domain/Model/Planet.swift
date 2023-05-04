//
//  Planet.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Foundation

struct PlanetModel: Equatable, Hashable {
    var name: String
    var population: String
    var terrain: String
}

extension PlanetModel {
    
    static let mockPlanetModel1: [PlanetModel] = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert")]
    static let mockPlanetModel2: [PlanetModel] = [PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
    
    static let mockPlanetModels: [PlanetModel] = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"),
                                                  PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]    
}
