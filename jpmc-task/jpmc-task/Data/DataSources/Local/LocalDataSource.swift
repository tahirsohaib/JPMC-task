//
//  LocalDataSource.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Foundation
import Combine

class LocalDataSource: LocalDataSourceProtocol {
    
    private var dbService: CoreDataServiceProtocol
    init(dbService: CoreDataServiceProtocol) {
        self.dbService = dbService
    }
    
    private func mapPlanetResponse(planetCDEntity: PlanetCDEntity) -> PlanetModel {
        return PlanetModel(name: planetCDEntity.name!, population: planetCDEntity.population!, terrain: planetCDEntity.terrain!)
    }
    
//    private func _getAll() -> [PlanetCDEntity]? {
//        return try? dbService.getData(entityName: "PlanetCDEntity") as? [PlanetCDEntity]
//
////        let result: [PlanetCDEntity] = try? dbService.getData(entityName: "PlanetCDEntity") as! [PlanetCDEntity]
////        return result
//    }
    private func _getAll() -> [PlanetCDEntity] {
        if let result = try? dbService.getData(entityName: "PlanetCDEntity") as? [PlanetCDEntity] {
            return result
        } else {
            // handle error case
            return []
        }
    }
    
    func getAll() -> AnyPublisher<[PlanetModel], Error> {
            let data = _getAll()
            let newData = data.map({ planetCDEntity in
                            mapPlanetResponse(planetCDEntity: planetCDEntity)
                        })
            
            return Just(newData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
    }
    
    func create(_ planetRequestModel: PlanetModel) -> AnyPublisher<Bool, Error> {
        let newPlanet = PlanetCDEntity(context: dbService.getContext())
        newPlanet.name = planetRequestModel.name
        newPlanet.terrain = planetRequestModel.terrain
        newPlanet.population = planetRequestModel.population
        
        dbService.saveEntity(entity: newPlanet)
        
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    /*
     func create(_ todoRequestModel: TodoRequestModel) async -> Result<Bool, TodoError> {
         do{
             let newToDo = TodoCoreDataEntity(context: dbService.getContext())
             newToDo.id = UUID().uuidString.replacingOccurrences(of: "-", with: "")
             newToDo.name = todoRequestModel.name;
             try dbService.saveEntity(entity: newToDo)
             return .success(true)
         }catch{
             return .failure(.Create)
         }
     }
     */
}
