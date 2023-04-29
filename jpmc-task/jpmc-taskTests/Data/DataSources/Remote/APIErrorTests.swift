//
//  APIErrorTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 29/04/2023.
//

import XCTest
@testable import jpmc_task

class APIErrorTests: XCTestCase {
    
    func testDecodingErrorDescription() {
        let error = APIError.decodingError
        XCTAssertEqual(error.errorDescription, "Failed to decode the object")
    }
    
    func testErrorCodeDescription() {
        let error = APIError.errorCode(404)
        XCTAssertEqual(error.errorDescription, "404 - Something went wrong.")
    }
    
    func testBadURLResponseDescription() {
        let error = APIError.badURLResponse(url: "http://example.com")
        XCTAssertEqual(error.errorDescription, "Bad response from URL: http://example.com")
    }
    
    func testBadURLRequestDescription() {
        let error = APIError.badURLRequest(url: "http://example.com")
        XCTAssertEqual(error.errorDescription, "bad URL Request: http://example.com")
    }
    
    func testUnknownErrorDescription() {
        let error = APIError.unknown
        XCTAssertEqual(error.errorDescription, "Unknown error occured")
    }
    
    func testTimeoutErrorDescription() {
        let error = APIError.timeout
        XCTAssertEqual(error.errorDescription, "Server not responding")
    }
}
