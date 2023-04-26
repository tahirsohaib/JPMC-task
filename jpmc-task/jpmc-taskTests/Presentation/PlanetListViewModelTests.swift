//
//  PlanetListViewModelTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 26/04/2023.
//

import XCTest
import Combine
@testable import jpmc_task

class PlanetListViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var useCase: GetAllPlanetsUseCaseMock!
    var viewModel: PlanetListViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        useCase = GetAllPlanetsUseCaseMock()
        Resolver.main.register(type: GetAllPlanetsUseCaseProtocol.self, service: useCase!)
        viewModel = PlanetListViewModel()
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        useCase = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchPlanetsUsingSuccess() {
        // Given
        let expectedPlanets = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"), PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
        
        useCase.stubbedResult = Just(expectedPlanets)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.fetchPlanets()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = self.expectation(description: "Fetched Planets")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.planets, expectedPlanets)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.4)
    }
    
    func testFetchPlanetsFailure() {
        // Given
        let expectedError = NSError(domain: "Fetch Failure", code: 404, userInfo: nil)
        useCase.stubbedResult = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.fetchPlanets()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = self.expectation(description: "Fetching Planets Failed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.planets, [])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.4)
    }
    
    func testSyncRemoteAndLocalSuccess() {
        // Given
        let expectedPlanets = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"), PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
        
        useCase.stubbedResult = Just(expectedPlanets)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.syncRemoteAndLocal()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = self.expectation(description: "Planets synchronized")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.planets, expectedPlanets)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.4)
    }
    
    func testSyncRemoteAndLocalFailure() {
        // Given
        let expectedError = NSError(domain: "Sync Failure", code: 404, userInfo: nil)
        useCase.stubbedResult = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.syncRemoteAndLocal()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = self.expectation(description: "Syncing Planets Failed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.planets, [])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.4)
    }
}

class GetAllPlanetsUseCaseMock: GetAllPlanetsUseCaseProtocol {
    var stubbedResult: AnyPublisher<[PlanetModel], Error>?
    
    func execute() -> AnyPublisher<[PlanetModel], Error> {
        if let stubbedResult = stubbedResult {
            return stubbedResult
        }
        
        // Otherwise, return an empty publisher.
        return Empty().eraseToAnyPublisher()
    }
    
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], Error> {
        if let stubbedResult = stubbedResult {
            return stubbedResult
        }
        
        // Otherwise, return an empty publisher.
        return Empty().eraseToAnyPublisher()
    }
}

