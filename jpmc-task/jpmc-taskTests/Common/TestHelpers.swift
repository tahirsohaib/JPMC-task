//
//  TestHelpers.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 07/05/2023.
//

import XCTest
import Combine

class TestHelpers {
    
    static func waitForPublisher<T, E: Error>(
        _ publisher: AnyPublisher<T, E>,
        timeout: TimeInterval = 0.2,
        expectation: String
    ) throws -> T {
        let expectation = XCTestExpectation(description: expectation)
        var result: Result<T, E>?
        let cancellable = publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { value in
                result = .success(value)
            }
        defer { cancellable.cancel() }
        
        XCTWaiter().wait(for: [expectation], timeout: timeout)
        
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output"
        )
        
        return try unwrappedResult.get()
    }
}
