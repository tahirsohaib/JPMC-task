//
//  jpmc_taskUITests.swift
//  jpmc-taskUITests
//
//  Created by Sohaib Tahir on 24/05/2023.
//

import XCTest

class PlanetListUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
    
    func testPlanetListNavigation() throws {
        // Wait for the planet list to load
        let planetList = app.navigationBars["Star Wars Planets"]
        XCTAssertTrue(planetList.waitForExistence(timeout: 5))
        
        // Tap on the first planet in the list
        let firstPlanet = app.tables.cells.firstMatch
        XCTAssertTrue(firstPlanet.waitForExistence(timeout: 5))
        firstPlanet.tap()
        
        // Verify that the planet details view is displayed
        let planetDetails = app.navigationBars["Planet Details"]
        XCTAssertTrue(planetDetails.waitForExistence(timeout: 5))
        
        // Go back to the planet list
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Verify that we are back on the planet list
        XCTAssertTrue(planetList.waitForExistence(timeout: 5))
    }

}
