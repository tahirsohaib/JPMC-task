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
    var remoteServiceMock: RemotePlanetsServiceMock!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        super.setUp()
        remoteServiceMock = RemotePlanetsServiceMock()
        Resolver.main.register(type: RemotePlanetsServiceProtocol.self, service: remoteServiceMock!)
        sut = RemoteDataSource()
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        sut = nil
        remoteServiceMock = nil
        super.tearDown()
    }
    
    func testGetAllPlanetsRemoteSuccess() throws {
        // Given
        let expectedPlanetModels = [PlanetModel(name: "Earth", population: "7.9 billion", terrain: "Dessert")]
        let planetRemoteEntities = [PlanetRemoteEntity(name: "Earth", terrain: "Dessert", population: "7.9 billion")]
        
        remoteServiceMock.fetchPlanetsResult = .success(planetRemoteEntities)
        
        let expectation = XCTestExpectation(description: "Get All planets succeeds")
        var receivedPlanets: [PlanetModel]?
        
        // When
        sut.getAllPlanetsRemote()
        // Then
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { planets in
                receivedPlanets = planets
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
                
        // Then
        XCTAssertEqual(receivedPlanets, expectedPlanetModels)
    }
    
    func testGetAllPlanetsRemoteFailure() throws {
        // Given
        let expectedError = NSError(domain: "fetchPlanetsResult Error", code: 404, userInfo: nil)
        let expectation = XCTestExpectation(description: "Get All planets from remote fails")
        
        // When
        sut.getAllPlanetsRemote()
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

class RemotePlanetsServiceMock: RemotePlanetsServiceProtocol {
    
    var fetchPlanetsResult: Result<[PlanetRemoteEntity], Error> = .failure(NSError(domain: "fetchPlanetsResult Error", code: 404, userInfo: nil))
    
    func fetchPlanets() -> AnyPublisher<[PlanetRemoteEntity], Error> {
        return Result.Publisher(fetchPlanetsResult)
            .eraseToAnyPublisher()
    }
}
