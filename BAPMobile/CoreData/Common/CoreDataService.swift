//
//  CoreDataService.swift
//  BAPMobile
//
//  Created by Emcee on 7/5/21.
//

import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()

    enum StaticStrings {
        static let BASmart = "BASmart"
        static let exten  =  "momd"
    }
    
    // MARK: core data initialization
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        // TODO: add a bit of error checking for the bundle + momd file
        let momURL = Bundle(for: CoreDataService.self).url(forResource: StaticStrings.BASmart, withExtension: StaticStrings.exten)
        let model = NSManagedObjectModel(contentsOf: momURL!)
        
        let container = NSPersistentContainer(name: StaticStrings.BASmart, managedObjectModel: model!)
        
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions.append(description)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}
