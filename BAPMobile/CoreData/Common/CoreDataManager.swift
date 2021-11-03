//
//  CoreDataManager.swift
//  BAPMobile
//
//  Created by Emcee on 7/5/21.
//

import Foundation
import CoreData

class CoreDataManager  {
    
    static let share = CoreDataManager()
    
    static let viewContext = CoreDataService.shared.persistentContainer.viewContext
    
    static func getSaveContext() -> NSManagedObjectContext {
        return CoreDataService.shared.persistentContainer.newBackgroundContext()
    }
    
    func executeFetchRequest<T>(
        _ requet: NSFetchRequest<NSFetchRequestResult>,
        _ returnType: T.Type
    ) -> [T] {
        do {
            guard let result = try CoreDataManager.viewContext.fetch(requet) as? [T] else {
                print("Could not parse readers from the database")
                return []
            }
            return result
        } catch {
            print("Could not read from database: \(error.localizedDescription)")
            return []
        }
    }
    
}
