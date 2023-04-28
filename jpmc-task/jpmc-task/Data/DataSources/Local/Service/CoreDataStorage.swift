//
//  CoreDataService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import CoreData
import Foundation

enum StorageType {
  case persistent, inMemory
}

protocol CoreDataServiceProtocol {
    func getContext() -> NSManagedObjectContext
    func getEntities(entityName: String, predicate: NSPredicate?, limit: Int?) throws -> [NSManagedObject]
    func deleteObject(entity: NSManagedObject)
    func saveContext()
}

class CoreDataStorage: CoreDataServiceProtocol {
    var persistentContainer: NSPersistentContainer
    
    init(_ storageType: StorageType = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: "Swapi")
        
        if storageType == .inMemory {
          let description = NSPersistentStoreDescription()
          description.url = URL(fileURLWithPath: "/dev/null")
          self.persistentContainer.persistentStoreDescriptions = [description]
        }

        self.persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("Error saving to Core Data: \(error)")
        }
    }

    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func getEntities(entityName: String, predicate: NSPredicate? = nil, limit: Int? = nil) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = limit ?? 0
        let entities = try persistentContainer.viewContext.fetch(fetchRequest)
        return entities
    }

    func deleteObject(entity: NSManagedObject) {
        persistentContainer.viewContext.delete(entity)
        saveContext()
    }
}
