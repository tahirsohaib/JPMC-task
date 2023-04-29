//
//  LocalDataSourceTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 29/04/2023.
//

import XCTest
@testable import jpmc_task
import CoreData
import Combine

class LocalDataSourceTests: XCTestCase {
    var dataSource: LocalDataSource!
    var coreDataService: CoreDataServiceProtocol!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        super.setUp()
        coreDataService = CoreDataStorage(.inMemory)
        Resolver.main.register(type: CoreDataServiceProtocol.self, service: coreDataService!)
        dataSource = LocalDataSource()
    }
    
    override func tearDownWithError() throws {
        coreDataService = nil
        dataSource = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testGetAllPlanetsLocal() {
        // Given
        let planet = PlanetCDEntity(context: coreDataService.getContext())
        planet.name = "Tatooine"
        planet.terrain = "Desert"
        planet.population = "200000"
        coreDataService.saveContext()
        
        // When
        let expectation = self.expectation(description: "getAllPlanetsLocal")
        var planets: [PlanetModel]?
        dataSource.getAllPlanetsLocal()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { result in
                planets = result
                expectation.fulfill()
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 0.2, handler: nil)
        
        // Then
        XCTAssertEqual(planets?.count, 1)
        XCTAssertEqual(planets?[0].name, "Tatooine")
        XCTAssertEqual(planets?[0].population, "200000")
        XCTAssertEqual(planets?[0].terrain, "Desert")
    }
    
    func testSyncAllPlanetsWithRemote() {
        // Given
        let remoteData = [PlanetModel(name: "Mars", population: "1000000", terrain: "Rocky"),
                          PlanetModel(name: "Jupiter", population: "5000000", terrain: "Gas Giant")]
        // When
        let expectation = XCTestExpectation(description: "Sync planets with remote data")
        
        dataSource.syncAllPlanetsWithRemote(remoteData)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { updatedPlanets in
                XCTAssertEqual(updatedPlanets.count, remoteData.count)
                
                let jupiter = updatedPlanets[0]
                XCTAssertEqual(jupiter.name, "Jupiter")
                XCTAssertEqual(jupiter.population, "5000000")
                XCTAssertEqual(jupiter.terrain, "Gas Giant")
                
                let mars = updatedPlanets[1]
                XCTAssertEqual(mars.name, "Mars")
                XCTAssertEqual(mars.population, "1000000")
                XCTAssertEqual(mars.terrain, "Rocky")
                
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
    }
    
}
