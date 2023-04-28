//
//  CoreDataService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import CoreData
import Foundation

protocol CoreDataServiceProtocol {
    func getContext() -> NSManagedObjectContext
    func getEntities(entityName: String, predicate: NSPredicate?, limit: Int?) throws -> [NSManagedObject]
    func deleteObject(entity: NSManagedObject)
    func saveContext()
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

    func saveContext() {
        guard container.viewContext.hasChanges else { return }
        
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data: \(error)")
        }
    }

    func getContext() -> NSManagedObjectContext {
        return container.viewContext
    }

    func getEntities(entityName: String, predicate: NSPredicate? = nil, limit: Int? = nil) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = limit ?? 0
        let entities = try container.viewContext.fetch(fetchRequest)
        return entities
    }

    func deleteObject(entity: NSManagedObject) {
        container.viewContext.delete(entity)
        saveContext()
    }
}
