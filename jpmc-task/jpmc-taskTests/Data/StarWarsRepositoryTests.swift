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
    
    func testGetAllPlanetsSuccess() throws {
        // Given
        localDataSourceMock.getAllPlanetsLocalResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = repository.getAllPlanets()
        
        // Then
        let receivedPlanets = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertNotNil(receivedPlanets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, receivedPlanets)
    }
    
    func testGetAllPlanetsFailure() {
        // Given
        let expectedError = DataSourceError.localFetchError
        
        // When
        let publisher = repository.getAllPlanets()
        var receivedError: Error?
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        } catch {
            receivedError = error
        }
        XCTAssertEqual(receivedError!.localizedDescription, expectedError.localizedDescription)
    }
    
    func testSyncLocalRepoWithRemoteRepoSuccess() throws {
        // Given
        localDataSourceMock.syncAllPlanetsWithRemoteResult = .success(PlanetModel.mockPlanetModels)
        remoteDataSourceMock.getAllPlanetsRemoteResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = repository.syncLocalRepoWithRemoteRepo()
        
        // Then
        let receivedPlanets = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertNotNil(receivedPlanets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, receivedPlanets)
    }
    
    func testSyncLocalRepoWithRemoteRepoFailure() throws {
        // Given
        let expectedError = DataSourceError.remoteUnknown
        
        // When
        let publisher = repository.syncLocalRepoWithRemoteRepo()
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


class RemoteDataSourceMock: RemoteDataSourceProtocol {
    var getAllPlanetsRemoteResult: Result<[PlanetModel], DataSourceError> = .failure(DataSourceError.remoteUnknown)

    func getAllPlanetsRemote() -> AnyPublisher<[PlanetModel], DataSourceError> {
        return getAllPlanetsRemoteResult.publisher.eraseToAnyPublisher()
    }
}

class LocalDataSourceMock: LocalDataSourceProtocol {
    var getAllPlanetsLocalResult: Result<[PlanetModel], DataSourceError> = .failure(DataSourceError.localFetchError)
    var syncAllPlanetsWithRemoteResult: Result<[PlanetModel], DataSourceError> = .failure(DataSourceError.localFetchError)

    func getAllPlanetsLocal() -> AnyPublisher<[PlanetModel], DataSourceError> {
        return getAllPlanetsLocalResult.publisher.eraseToAnyPublisher()
    }

    func syncAllPlanetsWithRemote(_ planets: [PlanetModel]) -> AnyPublisher<[PlanetModel], DataSourceError> {
        return syncAllPlanetsWithRemoteResult.publisher.eraseToAnyPublisher()
    }
}
