//
//  StawWarsRepository.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation
import Combine

class StawWarsRepository: PlanetsRepositoryProtocol {
    private var dataSource: PlanetDataSourceProtocol
    
    init(dataSource: PlanetDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func getAllPlanets() -> AnyPublisher<[PlanetResponseModel], Error> {
        return dataSource.getAll()
            .eraseToAnyPublisher()
    }
    
}
