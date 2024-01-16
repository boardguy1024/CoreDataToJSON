//
//  Persistance.swift
//  CoreDataToJSON
//
//  Created by paku on 2024/01/14.
//

import CoreData

struct PersistanceController {
    static var shared = PersistanceController()
    
    static var preview: PersistanceController = {
        let result = PersistanceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            fatalError()
        }
        return result
    }()

    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataToJSON")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "dev/null")
        }

        container.loadPersistentStores { NSPersistentStoreDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
