//
//  TestHelpers.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 07/05/2023.
//

import XCTest
import Combine

class TestHelpers {
    
    static func waitForPublisher<T>(
        _ publisher: AnyPublisher<T, Error>,
        timeout: TimeInterval = 0.2,
        expectation: XCTestExpectation
    ) throws -> T {
        var result: Result<T, Error>?
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
