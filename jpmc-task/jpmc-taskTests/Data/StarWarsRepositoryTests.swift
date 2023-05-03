//
//  StarWarsRepositoryTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 27/04/2023.
//

import XCTest
import Combine
@testable import jpmc_task

class StarWarsRepositoryTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var repository: StarWarsRepository!
    var remoteDataSourceMock: RemoteDataSourceMock!
    var localDataSourceMock: LocalDataSourceMock!
    
    override func setUpWithError() throws {
        super.setUp()
        Resolver.main.removeDependencies()
        remoteDataSourceMock = RemoteDataSourceMock()
        localDataSourceMock = LocalDataSourceMock()
        Resolver.main.register(type: LocalDataSourceProtocol.self, service: localDataSourceMock!)
        Resolver.main.register(type: RemoteDataSourceProtocol.self, service: remoteDataSourceMock!)
        repository = StarWarsRepository()
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        repository = nil
        remoteDataSourceMock = nil
        localDataSourceMock = nil
        super.tearDown()
    }
    
    func testGetAllPlanetsSuccess() {
        // Given
        let expectedPlanets = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"),
                               PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
        
        localDataSourceMock.getAllPlanetsLocalResult = .success(expectedPlanets)
        
        let expectation = XCTestExpectation(description: "Get All planets succeeds")
        var receivedPlanets: [PlanetModel]?
                
        // When
        repository.getAllPlanets()
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
    
    func testGetAllPlanetsFailure() {
        // Given
        let expectedError = NSError(domain: "getAllPlanetsLocalResult Error", code: 404, userInfo: nil)
        let expectation = XCTestExpectation(description: "Get All planets fails")
        
        // When
        repository.getAllPlanets()
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
    
    func testSyncLocalRepoWithRemoteRepoSuccess() {
        // Given
        let expectedPlanets = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "desert"),
                               PlanetModel(name: "Mars", population: "Unknown", terrain: "mountains")]
        
        localDataSourceMock.syncAllPlanetsWithRemoteResult = .success(expectedPlanets)
        remoteDataSourceMock.getAllPlanetsRemoteResult = .success(expectedPlanets)
        
        let expectation = XCTestExpectation(description: "Sync local with remote succeeds")
        var receivedPlanets: [PlanetModel]?
        
        // When
        repository.syncLocalRepoWithRemoteRepo()
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
    
    func testSyncLocalRepoWithRemoteRepoFailure() {
        // Given
        let expectedError = NSError(domain: "getAllPlanetsRemoteResult Error", code: 404, userInfo: nil)
        let expectation = XCTestExpectation(description: "Sync local with remote fails")
        
        // When
        repository.syncLocalRepoWithRemoteRepo()
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


class RemoteDataSourceMock: RemoteDataSourceProtocol {
    var getAllPlanetsRemoteResult: Result<[PlanetModel], Error> = .failure(NSError(domain: "getAllPlanetsRemoteResult Error", code: 404, userInfo: nil))

    func getAllPlanetsRemote() -> AnyPublisher<[PlanetModel], Error> {
        return getAllPlanetsRemoteResult.publisher.eraseToAnyPublisher()
    }
}

class LocalDataSourceMock: LocalDataSourceProtocol {
    var getAllPlanetsLocalResult: Result<[PlanetModel], Error> = .failure(NSError(domain: "getAllPlanetsLocalResult Error", code: 404, userInfo: nil))
    var syncAllPlanetsWithRemoteResult: Result<[PlanetModel], Error> = .failure(NSError(domain: "syncAllPlanetsWithRemoteResult Error", code: 404, userInfo: nil))

    func getAllPlanetsLocal() -> AnyPublisher<[PlanetModel], Error> {
        return getAllPlanetsLocalResult.publisher.eraseToAnyPublisher()
    }

    func syncAllPlanetsWithRemote(_ planets: [PlanetModel]) -> AnyPublisher<[PlanetModel], Error> {
        return syncAllPlanetsWithRemoteResult.publisher.eraseToAnyPublisher()
    }
}
