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
    
    func testExecuteSuccess() {
        // Given
        mockRepository.getAllPlanetsResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = sut.execute()
        
        // Then
        let planets = try? TestHelpers.waitForPublisher(publisher, expectation:  #function)
        
        XCTAssertNotNil(planets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, planets)
    }
    
    func testExecuteFailure() {
        // Given
        let expectedError = SWAPIError.someError(description: "getAllPlanetsResult Error")
        
        // When
        let publisher = sut.execute()
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation:  #function)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func testSyncLocalWithRemoteSuccess() {
        // Given
        mockRepository.syncLocalRepoResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = sut.syncLocalRepoWithRemoteRepo()
        
        // Then
        let planets = try? TestHelpers.waitForPublisher(publisher, expectation:  #function)
        
        XCTAssertNotNil(planets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, planets)
    }
    
    func testSyncLocalWithRemoteFailure() {
        // Given
        let expectedError = SWAPIError.someError(description: "syncLocalRepoResult Error")
        
        // When
        let publisher = sut.syncLocalRepoWithRemoteRepo()
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
}

class MockRepository: PlanetsRepositoryProtocol {
    var getAllPlanetsResult: Result<[PlanetModel], Error> = .failure(SWAPIError.someError(description: "getAllPlanetsResult Error"))
    var syncLocalRepoResult: Result<[PlanetModel], Error> = .failure(SWAPIError.someError(description: "syncLocalRepoResult Error"))
    
    func getAllPlanets() -> AnyPublisher<[PlanetModel], Error> {
        return Result.Publisher(getAllPlanetsResult)
            .eraseToAnyPublisher()
    }
    
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], Error> {
        return Result.Publisher(syncLocalRepoResult)
            .eraseToAnyPublisher()
    }
}
