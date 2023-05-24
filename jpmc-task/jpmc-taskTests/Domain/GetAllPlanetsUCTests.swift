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
        Resolver.main.register(type: StarWarsRepositoryProtocol.self, service: mockRepository!)
        sut = GetAllPlanetsUC()
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() throws {
        // Given
        mockRepository.getAllPlanetsResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = sut.execute()
        
        // Then
        let planets = try TestHelpers.waitForPublisher(publisher, expectation:  #function)
        
        XCTAssertNotNil(planets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, planets)
        XCTAssertTrue(mockRepository.getAllPlanetsCalled)
    }
    
    func testExecuteFailure() throws {
        // Given
        let expectedError =  UseCaseError.fetchError
        
        // When
        let publisher = sut.execute()
        var receivedError: Error?
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation:  #function)
        } catch {
            receivedError = error
        }
        XCTAssertEqual(receivedError?.localizedDescription, expectedError.localizedDescription)
        XCTAssertTrue(mockRepository.getAllPlanetsCalled)
    }
    
    func testSyncLocalWithRemoteSuccess() throws {
        // Given
        mockRepository.syncLocalRepoResult = .success(PlanetModel.mockPlanetModels)
        
        // When
        let publisher = sut.syncLocalPlanetsRepoWithRemoteRepo()
        
        // Then
        let planets = try TestHelpers.waitForPublisher(publisher, expectation:  #function)
        
        XCTAssertNotNil(planets)
        XCTAssertEqual(PlanetModel.mockPlanetModels, planets)
        XCTAssertTrue(mockRepository.syncLocalRepoWithRemoteRepoCalled)
    }
    
    func testSyncLocalWithRemoteFailure() throws {
        // Given
        let expectedError = UseCaseError.unknownError
        
        // When
        let publisher = sut.syncLocalPlanetsRepoWithRemoteRepo()
        var receivedError: Error?
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
        } catch {
            receivedError = error
        }
        XCTAssertEqual(receivedError?.localizedDescription, expectedError.localizedDescription)
        XCTAssertTrue(mockRepository.syncLocalRepoWithRemoteRepoCalled)
    }
}

class MockRepository: StarWarsRepositoryProtocol {
    
    var getAllPlanetsResult: Result<[PlanetModel], DataSourceError> = .failure(DataSourceError.localFetchError)
    var syncLocalRepoResult: Result<[PlanetModel], DataSourceError> = .failure(DataSourceError.remoteDecodingError)
    var getFilmResult: Result<FilmModel, DataSourceError> = .failure(DataSourceError.localFetchError)
    var getResidentResult: Result<ResidentModel, DataSourceError> = .failure(DataSourceError.localFetchError)
    
    var getAllPlanetsCalled = false
    var syncLocalRepoWithRemoteRepoCalled = false
    var getFilmCalled = false
    var getResidentCalled = false
    
    func getAllPlanets() -> AnyPublisher<[PlanetModel], DataSourceError> {
        getAllPlanetsCalled = true
        return Result.Publisher(getAllPlanetsResult)
            .eraseToAnyPublisher()
    }
    
    func syncLocalPlanetsRepoWithRemote() -> AnyPublisher<[PlanetModel], DataSourceError> {
        syncLocalRepoWithRemoteRepoCalled = true
        return Result.Publisher(syncLocalRepoResult)
            .eraseToAnyPublisher()
    }
    
    func getFilm(filmID: String) -> AnyPublisher<FilmModel, DataSourceError> {
        getFilmCalled = true
        return Result.Publisher(getFilmResult)
            .eraseToAnyPublisher()
    }
    
    func getResident(residentID: String) -> AnyPublisher<ResidentModel, DataSourceError> {
        getResidentCalled = true
        return Result.Publisher(getResidentResult)
            .eraseToAnyPublisher()
    }
}
