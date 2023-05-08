//
//  RemoteDataSourceTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 27/04/2023.
//

import XCTest
import Combine
@testable import jpmc_task

class RemoteDataSourceTests: XCTestCase {
    var sut: RemoteDataSource!
    var remoteServiceMock: RemotePlanetsServiceMock!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        super.setUp()
        Resolver.main.removeDependencies()
        remoteServiceMock = RemotePlanetsServiceMock()
        Resolver.main.register(type: RemotePlanetsServiceProtocol.self, service: remoteServiceMock!)
        sut = RemoteDataSource()
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        sut = nil
        remoteServiceMock = nil
        super.tearDown()
    }
    
    func testGetAllPlanetsRemoteSuccess() throws {
        // Given
        remoteServiceMock.planetRemoteEntities = PlanetRemoteEntity.mockPlanetRemoteEntities
        
        // When
        let publisher = sut.getAllPlanetsRemote()
        
        // Then
        let planets = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertEqual(planets, PlanetModel.mockPlanetModels)
    }
    
    func testGetAllPlanetsRemoteFailure() throws {
        // Given
        let expectedError = SWAPIError.someError(description: #function)
        
        remoteServiceMock.error = expectedError
        
        // When
        let publisher = sut.getAllPlanetsRemote()
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }    
}

class RemotePlanetsServiceMock: RemotePlanetsServiceProtocol {
    var planetRemoteEntities: [PlanetRemoteEntity]?
    var error: Error?

    func fetchPlanets() -> AnyPublisher<[PlanetRemoteEntity], Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let planetRemoteEntities = planetRemoteEntities {
            return Just(planetRemoteEntities).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            fatalError("You must set either planetRemoteEntities or error")
        }
    }
}
