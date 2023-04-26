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
//    var viewModel: PlanetListViewModel!
    var useCase: GetAllPlanetsUseCaseMock!
    
    override func setUpWithError() throws {
        super.setUp()
        useCase = GetAllPlanetsUseCaseMock()
        Resolver.main.register(type: GetAllPlanetsUseCaseProtocol.self, service: useCase!)
//        viewModel = PlanetListViewModel()
    }
    
    override func tearDownWithError() throws {
//        viewModel = nil
        useCase = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchPlanetsSuccess() {
        let viewModel = PlanetListViewModel()
        // Given
        let expectedPlanets = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"), PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
        
        useCase.stubbedExecuteResult = Just(expectedPlanets)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // When
        viewModel.fetchPlanets()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.planets, [])
        
        let expectation = self.expectation(description: "Fetched Planets")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.planets, expectedPlanets)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPlanetsFailure() {
        let viewModel = PlanetListViewModel()
        // Given
        let expectedError = NSError(domain: "Test Error", code: 404, userInfo: nil)
        useCase.stubbedExecuteResult = Fail(error: expectedError)
               .eraseToAnyPublisher()
        
        // When
        viewModel.fetchPlanets()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.planets, [])
        
        let expectation = self.expectation(description: "Fetching Planets Failed")
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertFalse(viewModel.isLoading)
               XCTAssertEqual(viewModel.planets, [])
               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 1)
    }
    
    func testSyncRemoteAndLocalSuccess() {
        let viewModel = PlanetListViewModel()
        // Given
        let expectedPlanets = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"), PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
        
        useCase.stubbedExecuteResult = Just(expectedPlanets)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // When
        viewModel.syncRemoteAndLocal()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.planets, [])
        
        let expectation = self.expectation(description: "Planets synchronized")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.planets, expectedPlanets)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSyncRemoteAndLocalFailure() {
        let viewModel = PlanetListViewModel()
        // Given
        let expectedError = NSError(domain: "Test Error", code: 404, userInfo: nil)
        useCase.stubbedExecuteResult = Fail(error: expectedError)
               .eraseToAnyPublisher()
        
        // When
        viewModel.syncRemoteAndLocal()
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.planets, [])
        
        let expectation = self.expectation(description: "Syncing Planets Failed")
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               XCTAssertFalse(viewModel.isLoading)
               XCTAssertEqual(viewModel.planets, [])
               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 1)
    }
    

}

class GetAllPlanetsUseCaseMock: GetAllPlanetsUseCaseProtocol {
    var stubbedExecuteResult: AnyPublisher<[PlanetModel], Error>?
    
    func execute() -> AnyPublisher<[PlanetModel], Error> {
        if let stubbedResult = stubbedExecuteResult {
            return stubbedResult
        }
        
        // Otherwise, return an empty publisher.
        return Empty().eraseToAnyPublisher()
    }
    
    func syncLocalRepoWithRemoteRepo() -> AnyPublisher<[PlanetModel], Error> {
        if let stubbedResult = stubbedExecuteResult {
            return stubbedResult
        }
        
        // Otherwise, return an empty publisher.
        return Empty().eraseToAnyPublisher()
    }
}

