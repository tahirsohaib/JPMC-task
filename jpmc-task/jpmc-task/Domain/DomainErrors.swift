//
//  DomainErrors.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 11/05/2023.
//

import Foundation

enum UseCaseError: Error {
    case fetchError
    case saveError
    case unknownError
}
