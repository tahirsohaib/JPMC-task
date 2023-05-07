//
//  RemotePlanetsServiceTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 28/04/2023.
//

import XCTest
import Combine
@testable import jpmc_task

class RemotePlanetsServiceTests: XCTestCase {
    var sut: RemotePlanetsService!
    var networkServiceMock: NetworkServiceMock!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        super.setUp()
        Resolver.main.removeDependencies()
        networkServiceMock = NetworkServiceMock()
        Resolver.main.register(type: NetworkServiceProtocol.self, service: networkServiceMock!)
        sut = RemotePlanetsService()
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        sut = nil
        networkServiceMock = nil
        super.tearDown()
    }

    func testFetchPlanetsSuccess() {
        // Given
        
        let encodedResponse = try! JSONEncoder().encode(PlanetsResponseRemoteEntity(results: PlanetRemoteEntity.mockPlanetRemoteEntities))
        
        networkServiceMock.encodedResponse = encodedResponse
        
        let expectation = XCTestExpectation(description: #function)
        var planets: [PlanetRemoteEntity]?
        
        // When
        sut.fetchPlanets()
        // Then
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected to fetch planets, but got error: \(error)")
                }
                expectation.fulfill()
            } receiveValue: { planetsResponse in
                planets = planetsResponse
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
        XCTAssertEqual(planets, PlanetRemoteEntity.mockPlanetRemoteEntities)
    }
    
    func testFetchPlanetsFailure() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let expectedError = NSError(domain: "fetchPlanets Error", code: 404, userInfo: nil)
        
        networkServiceMock.error = expectedError
        
        // When
        sut.fetchPlanets()
        // Then
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Publisher should have finished with an error")
                }
            } receiveValue: { _ in
                XCTFail("Publisher should have finished with an error")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
    }
}

class NetworkServiceMock: NetworkServiceProtocol {
    var encodedResponse: Data?
    var error: Error?
    
    func get<T: Decodable, S: Endpoint>(_ t: T.Type, endpoint: S) -> AnyPublisher<T, Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return encodedResponse.publisher
                .tryMap { data -> T in
                    try JSONDecoder().decode(T.self, from: data)
                }
                .eraseToAnyPublisher()
        }
    }
}
