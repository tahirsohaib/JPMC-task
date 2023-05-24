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
        Resolver.main.removeDependencies()
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
        useCase.stubbedResult = Just(PlanetModel.mockPlanetModels)
            .setFailureType(to: UseCaseError.self)
            .eraseToAnyPublisher()
        
        // When
        viewModel.fetchPlanets()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.planets, [])
        
        let expectation = XCTestExpectation(description: #function)
        
        // Simulate a short delay
        let delayInterval: TimeInterval = 0.2
        let waiter = XCTWaiter()
        waiter.wait(for: [expectation], timeout: delayInterval)
        
        // Check the results after the delay
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.planets, PlanetModel.mockPlanetModels)
        XCTAssertTrue(useCase.executeCalled)
    }
    
    func testFetchPlanetsFailure() {
        // Given
        let expectedError = UseCaseError.fetchError
        useCase.stubbedResult = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.fetchPlanets()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = XCTestExpectation(description: #function)
        
        // Simulate a short delay
        let delayInterval: TimeInterval = 0.2
        let waiter = XCTWaiter()
        waiter.wait(for: [expectation], timeout: delayInterval)
        
        XCTAssertFalse(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        XCTAssertTrue(self.useCase.executeCalled)
    }
    
    func testSyncRemoteAndLocalSuccess() {
        // Given
        viewModel = PlanetListViewModel()
        useCase.stubbedResult = Just(PlanetModel.mockPlanetModels)
            .setFailureType(to: UseCaseError.self)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.syncRemoteAndLocal()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = self.expectation(description: "Planets synchronization succeeds")
        
        let delayInterval: TimeInterval = 0.2
        let waiter = XCTWaiter()
        waiter.wait(for: [expectation], timeout: delayInterval)
        
        XCTAssertEqual(self.viewModel.planets, PlanetModel.mockPlanetModels)
        XCTAssertTrue(self.useCase.syncLocalRepoWithRemoteRepoCalled)
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    func testSyncRemoteAndLocalFailure() {
        // Given
        viewModel = PlanetListViewModel()
        let expectedError = UseCaseError.fetchError
        useCase.stubbedResult = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.syncRemoteAndLocal()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = XCTestExpectation(description: #function)
        
        let delayInterval: TimeInterval = 0.2
        let waiter = XCTWaiter()
        waiter.wait(for: [expectation], timeout: delayInterval)
        
        XCTAssertEqual(self.viewModel.planets, [])
        XCTAssertTrue(self.useCase.syncLocalRepoWithRemoteRepoCalled)
        XCTAssertFalse(self.viewModel.isLoading)
    }
    
    class GetAllPlanetsUseCaseMock: GetAllPlanetsUseCaseProtocol {
        var stubbedResult: AnyPublisher<[PlanetModel], UseCaseError>?
        var executeCalled = false
        var syncLocalRepoWithRemoteRepoCalled = false
        
        func execute() -> AnyPublisher<[PlanetModel], UseCaseError> {
            executeCalled = true
            
            if let stubbedResult = stubbedResult {
                return stubbedResult
            }
            
            // Otherwise, return an empty publisher.
            return Empty().eraseToAnyPublisher()
        }
        
        func syncLocalPlanetsRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], UseCaseError> {
            syncLocalRepoWithRemoteRepoCalled = true
            
            if let stubbedResult = stubbedResult {
                return stubbedResult
            }
            
            // Otherwise, return an empty publisher.
            return Empty().eraseToAnyPublisher()
        }
    }
    
}
