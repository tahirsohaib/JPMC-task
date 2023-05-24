//
//  Resident.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import Foundation

struct ResidentModel: Hashable, Equatable {
    var name: String
}

extension ResidentModel {
    static let mockResidentModel: ResidentModel = ResidentModel(name: "Lobot")
}
