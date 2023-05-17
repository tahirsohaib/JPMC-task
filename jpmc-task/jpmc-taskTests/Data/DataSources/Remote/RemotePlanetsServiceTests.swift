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

    func testFetchPlanetsSuccess() throws {
        // Given
        let encodedResponse = try JSONEncoder().encode(PlanetsResponseRemoteEntity(results: PlanetRemoteEntity.mockPlanetRemoteEntities))
        
        networkServiceMock.encodedResponse = encodedResponse
        
        // When
        let publisher = sut.fetchPlanets()
        
        // Then
        let planets = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertEqual(planets, PlanetRemoteEntity.mockPlanetRemoteEntities)
        XCTAssertTrue(networkServiceMock.getCalled)
    }
    
    func testFetchPlanetsFailure() throws {
        // Given
        let expectedError = DataSourceError.remoteUnknown
        
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
        XCTAssertTrue(networkServiceMock.getCalled)
    }
}

class NetworkServiceMock: NetworkServiceProtocol {
    var encodedResponse: Data?
    var error: DataSourceError?
    var getCalled = false
    
    func get<T, S>(_ t: T.Type, endpoint: S) -> AnyPublisher<T, DataSourceError> where T : Decodable, S : Endpoint {
        getCalled = true
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return encodedResponse.publisher
                .tryMap { data -> T in
                    try JSONDecoder().decode(T.self, from: data)
                }
                .mapError { error -> DataSourceError in
                    if let dataSourceError = error as? DataSourceError {
                        return dataSourceError
                    } else {
                        return DataSourceError.remoteDecodingError
                    }
                }
                .eraseToAnyPublisher()
        }
    }            
}
