//
//  Film.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import Foundation

struct FilmModel: Hashable, Equatable {
    var title: String
}

extension FilmModel {
    static let mockFilmModel: FilmModel = FilmModel(title: "A New Hope")
}
