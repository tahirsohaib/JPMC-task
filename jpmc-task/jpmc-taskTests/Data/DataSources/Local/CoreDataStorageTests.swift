//
//  CoreDataStorageTests.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 28/04/2023.
//

import XCTest
import CoreData
@testable import jpmc_task

class CoreDataStorageTests: XCTestCase {
    var coreDataService: CoreDataServiceProtocol!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        super.setUp()
        coreDataService = CoreDataStorage(.inMemory)
        context = coreDataService.getContext()
    }
    
    override func tearDownWithError() throws {
        coreDataService = nil
        context = nil
        super.tearDown()
    }
    
    func testInsertPlanet() throws {
        let planet = PlanetCDEntity(context: context)
        planet.name = "Tatooine"
        planet.terrain = "Desert"
        planet.population = "200000"
        coreDataService.saveContext()
        
        let result = try coreDataService.getEntities(entityName: "PlanetCDEntity", predicate: NSPredicate(format: "name = %@", "Tatooine"), limit: 0) as! [PlanetCDEntity]
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "Tatooine")
        XCTAssertEqual(result[0].terrain, "Desert")
        XCTAssertEqual(result[0].population, "200000")
    }
        
    func testDeletePlanet() throws {
        let planet = PlanetCDEntity(context: context)
        planet.name = "Tatooine"
        planet.terrain = "Desert"
        planet.population = "200000"
        coreDataService.saveContext()
        
        let result = try coreDataService.getEntities(entityName: "PlanetCDEntity", predicate: NSPredicate(format: "name = %@", "Tatooine"), limit: 0) as! [PlanetCDEntity]
        XCTAssertEqual(result.count, 1)
        
        coreDataService.deleteObject(entity: result[0])
        
        let newResult = try coreDataService.getEntities(entityName: "PlanetCDEntity", predicate: NSPredicate(format: "name = %@", "Tatooine"), limit: 0) as! [PlanetCDEntity]
        XCTAssertEqual(newResult.count, 0)
    }
}
