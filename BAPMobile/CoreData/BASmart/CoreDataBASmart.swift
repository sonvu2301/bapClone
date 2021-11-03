//
//  CoreDataBASmart.swift
//  BAPMobile
//
//  Created by Emcee on 7/5/21.
//

import Foundation
import CoreData

@objc(BASmartAttachs)
public class BASmartAttachs: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var userName: String?
}

@objc(BASmartVehicleImages)
public class BASmartVehicleImages: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var image: Data?
    @NSManaged public var isBefore: Bool
    @NSManaged public var code: String?
    @NSManaged public var userName: String?
    @NSManaged public var creator: String?
    @NSManaged public var plate: String?
    @NSManaged public var xn: Int64
    @NSManaged public var partner: String?
}

class CoreDataBASmart : CoreDataManager {
    static let shared = CoreDataBASmart()
    
    enum Entity {
        static let attach = "BASmartAttachs"
        static let vehicle = "BASmartVehicleImages"
    }
    
    func getAttach() -> [BASmartAttachs] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: Entity.attach
        )
        return executeFetchRequest(fetchRequest, BASmartAttachs.self)
    }
    
    func getVehicle() -> [BASmartVehicleImages] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: Entity.vehicle
        )
        return executeFetchRequest(fetchRequest, BASmartVehicleImages.self)
    }
    
    func insertAttach(name: String, image: Data, id: Int64) {
        let context = CoreDataManager.getSaveContext()
        let attach = BASmartAttachs(context: context)
        attach.image = image
        attach.name = name
        attach.id = id
        attach.userName = UserInfo.shared.userName
        
        do {
            try context.save()
        } catch {
            print("Could not insert transaction certs: \(error.localizedDescription)")
        }
    }
    
    func insertVehicle(plate: String, xn: String, image: Data, id: Int64, code: String, isBefore: Bool, partner: String) {
        let context = CoreDataManager.getSaveContext()
        let vehicle = BASmartVehicleImages(context: context)
        vehicle.plate = plate
        vehicle.xn = Int64(xn) ?? 0
        vehicle.image = image
        vehicle.id = id
        vehicle.isBefore = isBefore
        vehicle.code = code
        vehicle.userName = UserInfo.shared.userName
        vehicle.creator = UserInfo.shared.name
        vehicle.partner = partner
        
        do {
            try context.save()
        } catch {
            print("Could not insert transaction certs: \(error.localizedDescription)")
        }
    }
    
    func deleteAttach(id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.attach)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            var results = try CoreDataManager.viewContext.fetch(fetchRequest) as! [BASmartAttachs]
            results = results.filter({$0.id == id})
            CoreDataManager.viewContext.delete(results[0])
            try CoreDataManager.viewContext.save()
        } catch let error {
            print("Detele all data in \(Entity.attach) error :", error)
        }
    }
    
    func deleteVehicle(id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.vehicle)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            var results = try CoreDataManager.viewContext.fetch(fetchRequest) as! [BASmartVehicleImages]
            results = results.filter({$0.id == id})
            CoreDataManager.viewContext.delete(results[0])
            try CoreDataManager.viewContext.save()
        } catch let error {
            print("Detele all data in \(Entity.vehicle) error :", error)
        }
    }
    
    func deleteAllData(entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try CoreDataManager.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                CoreDataManager.viewContext.delete(objectData)
            }
            try CoreDataManager.viewContext.save()
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
}

