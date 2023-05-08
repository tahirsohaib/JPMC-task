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
        localDataSourceMock.getAllPlanetsLocalResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = repository.getAllPlanets()
        
        // Then
        let receivedPlanets = try? TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertNotNil(receivedPlanets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, receivedPlanets)
    }
    
    func testGetAllPlanetsFailure() {
        // Given
        let expectedError = SWAPIError.someError(description: "getAllPlanetsLocalResult Error")
        
        // When
        let publisher = repository.getAllPlanets()
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func testSyncLocalRepoWithRemoteRepoSuccess() {
        // Given
        localDataSourceMock.syncAllPlanetsWithRemoteResult = .success(PlanetModel.mockPlanetModels)
        remoteDataSourceMock.getAllPlanetsRemoteResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = repository.syncLocalRepoWithRemoteRepo()
        
        // Then
        let receivedPlanets = try? TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertNotNil(receivedPlanets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, receivedPlanets)
    }
    
    func testSyncLocalRepoWithRemoteRepoFailure() {
        // Given
        let expectedError = SWAPIError.someError(description: "getAllPlanetsRemoteResult Error")
        
        // When
        let publisher = repository.syncLocalRepoWithRemoteRepo()
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
}


class RemoteDataSourceMock: RemoteDataSourceProtocol {
    var getAllPlanetsRemoteResult: Result<[PlanetModel], Error> = .failure(SWAPIError.someError(description: "getAllPlanetsRemoteResult Error"))

    func getAllPlanetsRemote() -> AnyPublisher<[PlanetModel], Error> {
        return getAllPlanetsRemoteResult.publisher.eraseToAnyPublisher()
    }
}

class LocalDataSourceMock: LocalDataSourceProtocol {
    var getAllPlanetsLocalResult: Result<[PlanetModel], Error> = .failure(SWAPIError.someError(description: "getAllPlanetsLocalResult Error"))
    var syncAllPlanetsWithRemoteResult: Result<[PlanetModel], Error> = .failure(SWAPIError.someError(description: "syncAllPlanetsWithRemoteResult Error"))

    func getAllPlanetsLocal() -> AnyPublisher<[PlanetModel], Error> {
        return getAllPlanetsLocalResult.publisher.eraseToAnyPublisher()
    }

    func syncAllPlanetsWithRemote(_ planets: [PlanetModel]) -> AnyPublisher<[PlanetModel], Error> {
        return syncAllPlanetsWithRemoteResult.publisher.eraseToAnyPublisher()
    }
}
