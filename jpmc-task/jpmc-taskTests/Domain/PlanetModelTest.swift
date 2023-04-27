//
//  PlanetModelTest.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 27/04/2023.
//

import XCTest
@testable import jpmc_task

class PlanetModelTest: XCTestCase {
    
    func testPlanetModelEquality() {
        // Given
        let planet1 = PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert")
        let planet2 = PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert")
        let planet3 = PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")
        
        // Then
        XCTAssertEqual(planet1, planet2, "Planet models with the same properties should be equal")
        XCTAssertNotEqual(planet1, planet3, "Planet models with different properties should not be equal")
    }
}
