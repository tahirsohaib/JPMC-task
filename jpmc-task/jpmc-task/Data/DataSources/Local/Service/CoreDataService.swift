//
//  CoreDataService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func getContext() -> NSManagedObjectContext
    func getData(entityName: String) throws -> [NSManagedObject]
    func getData(entityName: String, predicate: NSPredicate) throws -> [NSManagedObject]
    func getData(entityName: String, predicate: NSPredicate, limit: Int) throws -> [NSManagedObject]
    func saveEntity(entity: NSManagedObject)
    func deleteEntity(entity: NSManagedObject)
}

class CoreDataService: CoreDataServiceProtocol {
    var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Swapi")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved Error \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    internal func save() {
        if(container.viewContext.hasChanges) {
            do {
                try container.viewContext.save()
            } catch let error {
                print("Error saving to Core Data")
            }
        }               
    }
        
    func getContext() -> NSManagedObjectContext {
        return container.viewContext
    }
    
    func getData(entityName: String) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let entities = try container.viewContext.fetch(fetchRequest)
        return entities
    }
    
    func getData(entityName: String, predicate: NSPredicate) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        let entities = try container.viewContext.fetch(fetchRequest)
        return entities
    }
    
    func getData(entityName: String, predicate: NSPredicate, limit: Int) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = limit
        let entities = try container.viewContext.fetch(fetchRequest)
        return entities
    }
    
    func saveEntity(entity: NSManagedObject) {
        save()
    }
    
    func deleteEntity(entity: NSManagedObject) {
        container.viewContext.delete(entity)
        save()
    }
    
    
}
