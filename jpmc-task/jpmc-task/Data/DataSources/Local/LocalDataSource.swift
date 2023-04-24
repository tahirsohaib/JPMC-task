//
//  LocalDataSource.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

class LocalDataSource: LocalDataSourceProtocol {
    @Injected private var dbService: CoreDataServiceProtocol

    private func mapPlanetResponse(planetCDEntity: PlanetCDEntity) -> PlanetModel {
        guard let name = planetCDEntity.name,
              let population = planetCDEntity.population,
              let terrain = planetCDEntity.terrain
        else {
            fatalError("Invalid planet entity")
        }
        return PlanetModel(name: name, population: population, terrain: terrain)
    }

    private func _getAll() -> [PlanetCDEntity] {
        if let result = try? dbService.getData(entityName: "PlanetCDEntity") as? [PlanetCDEntity] {
            return result
        } else {
            return []
        }
    }

    private func _getOne(name: String) throws -> PlanetCDEntity? {
        guard let result = try dbService.getData(entityName: "PlanetCDEntity", predicate: NSPredicate(format: "name = %@", name)) as? [PlanetCDEntity], !result.isEmpty else {
            return nil
        }
        return result[0]
    }
    
    func syncAllPlanetsWithRemote(_ remoteData: [PlanetModel]) -> AnyPublisher<[PlanetModel], Error> {
        return Future { promise in
            let context = self.dbService.getContext()
            // Fetch all existing planets
            let allEntities = self._getAll()

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
            promise(.success(sortedPlanets))
        }.eraseToAnyPublisher()
    }

    func getAllPlanetsLocal() -> AnyPublisher<[PlanetModel], Error> {
        let data = _getAll()
        let newData = data.map { planetCDEntity in
            mapPlanetResponse(planetCDEntity: planetCDEntity)
        }

        let sortedPlanets = newData.sorted { $0.name < $1.name }
        
        return Just(sortedPlanets)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
