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

        let expectation = XCTestExpectation(description: #function)
        
        // When
        let publisher = sut.execute()
        var planets: [PlanetModel]?
        // Then
        do {
            planets = try TestHelpers.waitForPublisher(publisher, expectation: expectation)
        } catch {
            XCTFail("Publisher should have finished successfully")
        }
        
        XCTAssertNotNil(planets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, planets)
    }
    
    func testExecuteFailure() {
        // Given
        let expectedError = NSError(domain: "getAllPlanetsResult Error", code: 404, userInfo: nil)
        let expectation = XCTestExpectation(description: #function)
        
        // When
        let publisher = sut.execute()
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: expectation)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func testSyncLocalWithRemoteSuccess() {
        // Given
        mockRepository.syncLocalRepoResult = .success(PlanetModel.mockPlanetModels)

        let expectation = XCTestExpectation(description: #function)
        
        // When
        let publisher = sut.syncLocalRepoWithRemoteRepo()
        var planets: [PlanetModel]?
        
        // Then
        do {
            planets = try TestHelpers.waitForPublisher(publisher, expectation: expectation)
        } catch {
            XCTFail("Publisher should have finished successfully")
        }
        
        XCTAssertNotNil(planets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, planets)
    }
    
    func testSyncLocalWithRemoteFailure() {
        // Given
        let expectedError = NSError(domain: "syncLocalRepoResult Error", code: 404, userInfo: nil)
        let expectation = XCTestExpectation(description: #function)
        
        // When
        let publisher = sut.syncLocalRepoWithRemoteRepo()
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: expectation)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
}

class MockRepository: PlanetsRepositoryProtocol {
    var getAllPlanetsResult: Result<[PlanetModel], Error> = .failure(NSError(domain: "getAllPlanetsResult Error", code: 404, userInfo: nil))
    var syncLocalRepoResult: Result<[PlanetModel], Error> = .failure(NSError(domain: "syncLocalRepoResult Error", code: 404, userInfo: nil))
    
    func getAllPlanets() -> AnyPublisher<[PlanetModel], Error> {
        return Result.Publisher(getAllPlanetsResult)
            .eraseToAnyPublisher()
    }
    
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], Error> {
        return Result.Publisher(syncLocalRepoResult)
            .eraseToAnyPublisher()
    }
}
