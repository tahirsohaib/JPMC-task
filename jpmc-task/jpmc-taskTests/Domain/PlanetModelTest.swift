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
        
        // Then
        XCTAssertEqual(PlanetModel.mockPlanetModel1, PlanetModel.mockPlanetModel1, "Planet models with the same properties should be equal")
        XCTAssertNotEqual(PlanetModel.mockPlanetModel1, PlanetModel.mockPlanetModel2, "Planet models with different properties should not be equal")
    }
}
