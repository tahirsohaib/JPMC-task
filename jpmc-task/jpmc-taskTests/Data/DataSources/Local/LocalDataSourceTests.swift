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
        Resolver.main.removeDependencies()
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
    
    func testGetAllPlanetsLocal() throws {
        // Given
        let planet = PlanetCDEntity(context: coreDataService.getContext())
        planet.name = "Tatooine"
        planet.terrain = "Desert"
        planet.population = "200000"
        coreDataService.saveContext()

        // When
        let expectation = XCTestExpectation(description: #function)
        let publisher = dataSource.getAllPlanetsLocal()

        // Then
        var planets: [PlanetModel]?
        do {
            planets = try TestHelpers.waitForPublisher(publisher, expectation: expectation)
        } catch {
            XCTFail("Publisher should have finished successfully")
        }

        XCTAssertEqual(planets?.count, 1)
        XCTAssertEqual(planets?[0].name, "Tatooine")
        XCTAssertEqual(planets?[0].population, "200000")
        XCTAssertEqual(planets?[0].terrain, "Desert")
    }
    
    
    func testSyncAllPlanetsWithRemote() throws {
        // When
        let expectation = XCTestExpectation(description: #function)
        let publisher = dataSource.syncAllPlanetsWithRemote(PlanetModel.mockPlanetModels)

        // Then
        var planets: [PlanetModel]?
        do {
            planets = try TestHelpers.waitForPublisher(publisher, expectation: expectation)
        } catch {
            XCTFail("Publisher should have finished successfully")
        }

        XCTAssertEqual(planets?.count, PlanetModel.mockPlanetModels.count)

        let jupiter = planets?[0]
        XCTAssertEqual(jupiter?.name, "Earth")
        XCTAssertEqual(jupiter?.population, "7.9 billion")
        XCTAssertEqual(jupiter?.terrain, "desert")

        let mars = planets?[1]
        XCTAssertEqual(mars?.name, "Mars")
        XCTAssertEqual(mars?.population, "Unknown")
        XCTAssertEqual(mars?.terrain, "mountains")
    }    
}
