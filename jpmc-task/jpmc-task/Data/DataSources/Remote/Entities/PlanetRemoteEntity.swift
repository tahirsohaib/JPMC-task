//
//  Planet.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation
//typealias RemotePlanets = [PlanetRemoteEntity]
struct PlanetRemoteEntity: Hashable, Codable {
    let name: String
    let terrain: String
    let population: String
//    let films: [String]
//    let residents: [String]

//    enum CodingKeys: String, CodingKey {
//        case name
//        case terrain
//        case population
//        case filmURLs = "films"
//        case residentURLs = "residents"
//    }
}
