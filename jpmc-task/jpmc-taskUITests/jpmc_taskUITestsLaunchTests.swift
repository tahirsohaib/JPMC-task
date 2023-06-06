//
//  jpmc_taskUITestsLaunchTests.swift
//  jpmc-taskUITests
//
//  Created by Sohaib Tahir on 24/05/2023.
//

import XCTest

class jpmc_taskUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Home Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
