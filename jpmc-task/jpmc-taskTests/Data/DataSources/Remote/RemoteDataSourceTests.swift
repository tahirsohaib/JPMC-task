//
//  RemoteDataSourceTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 27/04/2023.
//

import XCTest
import Combine
@testable import jpmc_task

class RemoteDataSourceTests: XCTestCase {
    var sut: RemoteDataSource!
    var remotePlanetServiceMock: RemotePlanetsServiceMock!
    var remoteFilmServiceMock: RemoteFilmServiceMock!
    var remoteResidentServiceMock: RemoteResidentServiceMock!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        super.setUp()
        Resolver.main.removeDependencies()
        remotePlanetServiceMock = RemotePlanetsServiceMock()
        remoteFilmServiceMock = RemoteFilmServiceMock()
        remoteResidentServiceMock = RemoteResidentServiceMock()
        Resolver.main.register(type: RemotePlanetsServiceProtocol.self, service: remotePlanetServiceMock!)
        Resolver.main.register(type: RemoteFilmsServiceProtocol.self, service: remoteFilmServiceMock!)
        Resolver.main.register(type: RemoteResidentsServiceProtocol.self, service: remoteResidentServiceMock!)
        sut = RemoteDataSource()
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        sut = nil
        remotePlanetServiceMock = nil
        super.tearDown()
    }
    
    func testGetAllPlanetsRemoteSuccess() throws {
        // Given
        remotePlanetServiceMock.planetRemoteEntities = PlanetRemoteEntity.mockPlanetRemoteEntities
        
        // When
        let publisher = sut.getAllPlanetsRemote()
        
        // Then
        let planets = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertEqual(planets, PlanetModel.mockPlanetModels)
        XCTAssertTrue(remotePlanetServiceMock.fetchPlanetsCalled)
    }
    
    func testGetAllPlanetsRemoteFailure() throws {
        // Given
        let expectedError = DataSourceError.remoteUnknown
        
        remotePlanetServiceMock.error = expectedError
        
        // When
        let publisher = sut.getAllPlanetsRemote()
        var receivedError: Error?
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        } catch {
            receivedError = error
        }
        XCTAssertEqual(receivedError?.localizedDescription, expectedError.localizedDescription)
        XCTAssertTrue(remotePlanetServiceMock.fetchPlanetsCalled)
    }
}

class RemotePlanetsServiceMock: RemotePlanetsServiceProtocol {
    
    var planetRemoteEntities: [PlanetRemoteEntity]?
    var error: DataSourceError?
    var fetchPlanetsCalled = false

    func fetchPlanets() -> AnyPublisher<[PlanetRemoteEntity], DataSourceError> {
        fetchPlanetsCalled = true
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let planetRemoteEntities = planetRemoteEntities {
            return Just(planetRemoteEntities)
                .setFailureType(to: DataSourceError.self)
                .eraseToAnyPublisher()
        } else {
            fatalError("You must set either planetRemoteEntities or error")
        }
    }
}

class RemoteFilmServiceMock: RemoteFilmsServiceProtocol {
    var filmRemoteEntity: FilmRemoteEntity?
    var error: DataSourceError?
    var fetchFilmsCalled = false
    
    func fetchFilms(filmId: String) -> AnyPublisher<FilmRemoteEntity, DataSourceError> {
        fetchFilmsCalled = true
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else if let filmRemoteEntity = filmRemoteEntity {
            return Just(filmRemoteEntity)
                .setFailureType(to: DataSourceError.self)
                .eraseToAnyPublisher()
        } else {
            fatalError("You must set either filmRemoteEntity or error")
        }
    }
}

class RemoteResidentServiceMock: RemoteResidentsServiceProtocol {
    var residentRemoteEntity: ResidentRemoteEntity?
    var error: DataSourceError?
    var fetchResidentsCalled = false
    
    func fetchResidents(residentId: String) -> AnyPublisher<ResidentRemoteEntity, DataSourceError> {
        fetchResidentsCalled = true
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else if let residentRemoteEntity = residentRemoteEntity {
            return Just(residentRemoteEntity)
                .setFailureType(to: DataSourceError.self)
                .eraseToAnyPublisher()
        } else {
            fatalError("You must set either residentRemoteEntity or error")
        }
    }
}
