//
//  Response.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation
struct PlanetsResponseRemoteEntity: Codable, Hashable {
    let results: [PlanetRemoteEntity]
}
