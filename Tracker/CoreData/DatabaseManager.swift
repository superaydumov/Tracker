//
//  DatabaseManager.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 25.10.2023.
//

import Foundation
import CoreData

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {
        _ = persistentContainer
    }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
