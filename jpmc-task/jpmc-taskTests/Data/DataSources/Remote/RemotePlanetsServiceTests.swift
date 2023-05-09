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
        
        // When
        let publisher = sut.fetchPlanets()
        
        // Then
        let planets = try? TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertEqual(planets, PlanetRemoteEntity.mockPlanetRemoteEntities)
    }
    
    func testFetchPlanetsFailure() {
        // Given
        let expectedError = SWAPIError.someError(description: #function)
        
        networkServiceMock.error = expectedError
        
        // When
        let publisher = sut.fetchPlanets()
        var receivedError: Error?
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        } catch {
            receivedError = error
        }
        XCTAssertEqual(receivedError?.localizedDescription, expectedError.localizedDescription)
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
