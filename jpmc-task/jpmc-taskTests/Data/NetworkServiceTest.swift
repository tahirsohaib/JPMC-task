//
//  NetworkServiceTest.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 29/04/2023.
//

import XCTest
@testable import jpmc_task
import Combine

class NetworkServiceTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    // given
    let expectedEntity = PlanetRemoteEntity(name: "Tatooine", terrain: "desert", population: "200000")
    
    func testDecodeResponse() {
        let json = """
            {
                "name": "Tatooine",
                "terrain": "desert",
                "population": "200000"
            }
        """
        let data = Data(json.utf8)
        
        // then
        let expectation = self.expectation(description: "Decode response")
        NetworkService().decodeResponse(data, ofType: PlanetRemoteEntity.self)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Unexpected error: \(error)")
                }
            } receiveValue: { entity in
                XCTAssertEqual(entity, self.expectedEntity)
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
    }
}
