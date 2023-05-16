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
        self.viewModel.fetchPlanets()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = XCTestExpectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.planets, PlanetModel.mockPlanetModels)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.planets, [])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testSyncRemoteAndLocalSuccess() {
        // Given
        useCase.stubbedResult = Just(PlanetModel.mockPlanetModels)
            .setFailureType(to: UseCaseError.self)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.syncRemoteAndLocal()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = self.expectation(description: "Planets synchronization succeeds")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.planets, PlanetModel.mockPlanetModels)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testSyncRemoteAndLocalFailure() {
        // Given
        let expectedError = UseCaseError.fetchError
        useCase.stubbedResult = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        // When
        self.viewModel.syncRemoteAndLocal()
        
        // Then
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.planets, [])
        
        let expectation = XCTestExpectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.planets, [])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}

class GetAllPlanetsUseCaseMock: GetAllPlanetsUseCaseProtocol {
    var stubbedResult: AnyPublisher<[PlanetModel], UseCaseError>?
    
    func execute() -> AnyPublisher<[PlanetModel], UseCaseError> {
        if let stubbedResult = stubbedResult {
            return stubbedResult
        }
        
        // Otherwise, return an empty publisher.
        return Empty().eraseToAnyPublisher()
    }
    
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], UseCaseError> {
        if let stubbedResult = stubbedResult {
            return stubbedResult
        }
        
        // Otherwise, return an empty publisher.
        return Empty().eraseToAnyPublisher()
    }
}

