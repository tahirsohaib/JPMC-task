//
//  GetAllPlanetsUCTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 26/04/2023.
//

import XCTest
import Combine
@testable import jpmc_task

class GetAllPlanetsUCTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    var mockRepository: MockRepository!
    var sut: GetAllPlanetsUC!
    
    override func setUpWithError() throws {
        super.setUp()
        Resolver.main.removeDependencies()
        cancellables = []
        mockRepository = MockRepository()
        Resolver.main.register(type: PlanetsRepositoryProtocol.self, service: mockRepository!)
        sut = GetAllPlanetsUC()
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() throws {
        // Given
        mockRepository.getAllPlanetsResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = sut.execute()
        
        // Then
        let planets = try TestHelpers.waitForPublisher(publisher, expectation:  #function)
        
        XCTAssertNotNil(planets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, planets)
    }
    
    func testExecuteFailure() throws {
        // Given
        let expectedError =  UseCaseError.fetchError
        
        // When
        let publisher = sut.execute()
        var receivedError: Error?
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation:  #function)
        } catch {
            receivedError = error
        }
        XCTAssertEqual(receivedError?.localizedDescription, expectedError.localizedDescription)
    }
    
    func testSyncLocalWithRemoteSuccess() throws {
        // Given
        mockRepository.syncLocalRepoResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = sut.syncLocalRepoWithRemoteRepo()
        
        // Then
        let planets = try TestHelpers.waitForPublisher(publisher, expectation:  #function)
        
        XCTAssertNotNil(planets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, planets)
    }
    
    func testSyncLocalWithRemoteFailure() throws {
        // Given
        let expectedError = UseCaseError.unknownError
        
        // When
        let publisher = sut.syncLocalRepoWithRemoteRepo()
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

class MockRepository: PlanetsRepositoryProtocol {
    var getAllPlanetsResult: Result<[PlanetModel], DataSourceError> = .failure(DataSourceError.localFetchError)
    var syncLocalRepoResult: Result<[PlanetModel], DataSourceError> = .failure(DataSourceError.remoteDecodingError)
    
    func getAllPlanets() -> AnyPublisher<[PlanetModel], DataSourceError> {
        return Result.Publisher(getAllPlanetsResult)
            .eraseToAnyPublisher()
    }
    
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], DataSourceError> {
        return Result.Publisher(syncLocalRepoResult)
            .eraseToAnyPublisher()
    }
}
