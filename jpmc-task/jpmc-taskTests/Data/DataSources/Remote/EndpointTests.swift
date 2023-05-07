//
//  EndpointTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 27/04/2023.
//

import XCTest
@testable import jpmc_task

class EndpointTests: XCTestCase {
    
    func testMakeURL() {
        let endpoint = PlanetsEndpoint.allPlanets
        let expectedURL = URL(string: "https://swapi.dev/api/planets")
        
        XCTAssertEqual(endpoint.makeURL(), expectedURL)
    }
    
    func testEquatable() {
        let endpoint1 = PlanetsEndpoint.allPlanets
        let endpoint2 = PlanetsEndpoint.allPlanets
        let endpoint3 = PlanetsEndpoint.onePlanet(planetId: "1")
        
        XCTAssertEqual(endpoint1, endpoint2)
        XCTAssertNotEqual(endpoint1, endpoint3)
    }
}
