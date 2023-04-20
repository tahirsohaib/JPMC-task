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
    let filmURLs: [URL]
    let residentURLs: [URL]
    let filmObjects: [Film]?
    let residentObjects: [Resident]?

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
