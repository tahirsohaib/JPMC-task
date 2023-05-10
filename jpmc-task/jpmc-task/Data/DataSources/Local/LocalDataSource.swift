//
//  LocalDataSource.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

enum CoreDataError: Error {
    case invalidPlanetEntity
    case fetchError
    case saveError
}

class LocalDataSource: LocalDataSourceProtocol {
    @Injected private var dbService: CoreDataServiceProtocol
    
    private func mapPlanetResponse(planetCDEntity: PlanetCDEntity) throws -> PlanetModel {
        guard let name = planetCDEntity.name,
              let population = planetCDEntity.population,
              let terrain = planetCDEntity.terrain
        else {
            throw CoreDataError.invalidPlanetEntity
        }
        return PlanetModel(name: name, population: population, terrain: terrain)
    }
    
    private func _getAll() throws -> [PlanetCDEntity] {
        guard let entities = try? dbService.getEntities(entityName: "PlanetCDEntity", predicate: nil, limit: 0) else {
            throw CoreDataError.fetchError
        }
        return entities.compactMap { $0 as? PlanetCDEntity }
    }
    
    private func _getOne(name: String) throws -> PlanetCDEntity? {
        guard let result = try dbService.getEntities(entityName: "PlanetCDEntity", predicate: NSPredicate(format: "name = %@", name), limit: 0) as? [PlanetCDEntity], !result.isEmpty else {
            return nil
        }
        return result[0]
    }
    
    func syncAllPlanetsWithRemote(_ remoteData: [PlanetModel]) -> AnyPublisher<[PlanetModel], Error> {
        let context = self.dbService.getContext()
        // Fetch all existing planets
        do {
            let allEntities = try self._getAll()
            
            // Create a dictionary to map planet names to their corresponding entities
            var entityDict: [String: PlanetCDEntity] = [:]
            allEntities.forEach { entityDict[$0.name!] = $0 }
            
            // Update or insert new planets
            var updatedPlanets: [PlanetModel] = []
            for planet in remoteData {
                if let existingEntity = entityDict[planet.name] {
                    // Update existing entity
                    existingEntity.terrain = planet.terrain
                    existingEntity.population = planet.population
                    entityDict[planet.name] = existingEntity
                } else {
                    // Insert new entity
                    let newPlanet = PlanetCDEntity(context: context)
                    newPlanet.name = planet.name
                    newPlanet.terrain = planet.terrain
                    newPlanet.population = planet.population
                    entityDict[planet.name] = newPlanet
                }
                
                // Add updated planet to result
                updatedPlanets.append(planet)
            }
            
            let sortedPlanets = updatedPlanets.sorted { $0.name < $1.name }
            
            // Delete all planets that were not updated
            let deletedPlanets = entityDict.values.filter { _ in !updatedPlanets.contains { $0.name == $0.name } }
            deletedPlanets.forEach { context.delete($0) }
            
            // Save changes to the context
            self.dbService.saveContext()
            
            // Return updated planets
            return Just(sortedPlanets)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func getAllPlanetsLocal() -> AnyPublisher<[PlanetModel], Error> {
        do {
            let allEntities = try _getAll()
            let planets = try allEntities.map { planetCDEntity in
                try mapPlanetResponse(planetCDEntity: planetCDEntity)
            }
            
            let sortedPlanets = planets.sorted { $0.name < $1.name }
            
            return Just(sortedPlanets)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
