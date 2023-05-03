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
        let expectedPlanets = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"),
                               PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
        
        mockRepository.getAllPlanetsResult = .success(expectedPlanets)

        let expectation = XCTestExpectation(description: "Get All planets succeeds")
        var receivedPlanets: [PlanetModel]?
        
        // When
        sut.execute()
        // Then
           .sink(receiveCompletion: { _ in
               expectation.fulfill()
           }, receiveValue: { planets in
               receivedPlanets = planets
           })
           .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
        
        XCTAssertNotNil(receivedPlanets)
        XCTAssertEqual(expectedPlanets, receivedPlanets)
    }
    
    func testExecuteFailure() {
        // Given
        let expectedError = NSError(domain: "getAllPlanetsResult Error", code: 404, userInfo: nil)
        let expectation = XCTestExpectation(description: "Get All planets fails")
        
        // When
        sut.execute()
        // Then
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Publisher should have finished with an error")
                }
            } receiveValue: { _ in
                XCTFail("Publisher should have finished with an error")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func testSyncLocalWithRemoteSuccess() {
        // Given
        let expectedPlanets = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"),
                               PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
        
        mockRepository.syncLocalRepoResult = .success(expectedPlanets)

        let expectation = XCTestExpectation(description: "Sync Local With Remote succeeds")
        var receivedPlanets: [PlanetModel]?
        
        // When
        sut.syncLocalRepoWithRemoteRepo()
        // Then
           .sink(receiveCompletion: { _ in
               expectation.fulfill()
           }, receiveValue: { planets in
               receivedPlanets = planets
           })
           .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
        
        XCTAssertNotNil(receivedPlanets)
        XCTAssertEqual(expectedPlanets, receivedPlanets)
    }
    
    func testSyncLocalWithRemoteFailure() {
        // Given
        let expectedError = NSError(domain: "syncLocalRepoResult Error", code: 404, userInfo: nil)
        let expectation = XCTestExpectation(description: "Sync Local With Remote fails")
        
        // When
        sut.syncLocalRepoWithRemoteRepo()
        // Then
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Publisher should have finished with an error")
                }
            } receiveValue: { _ in
                XCTFail("Publisher should have finished with an error")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
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
