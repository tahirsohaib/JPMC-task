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
    var filmIDs: [String]
    var residentIDs: [String]
    let films: [FilmModel]?
    let residents: [ResidentModel]?
}

extension PlanetModel {
    
    static let mockPlanetModel1: PlanetModel = PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert", filmIDs: ["1"], residentIDs: ["1"], films: nil, residents: nil)
    
    static let mockPlanetModel2: PlanetModel = PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains", filmIDs: ["2"], residentIDs: ["2"], films: nil, residents: nil)
    
    static let mockPlanetModel3: PlanetModel = PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert", filmIDs: ["1"], residentIDs: ["1"], films: nil, residents: nil)
    
    static let mockPlanetModels: [PlanetModel] = [
        PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert", filmIDs: ["1"], residentIDs: ["1"], films: nil, residents: nil),
        PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains", filmIDs: ["2"], residentIDs: ["2"], films: nil, residents: nil)
    ]
}
