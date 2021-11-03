//
//  BASmartCustomerCatalog.swift
//  BAPMobile
//
//  Created by Emcee on 2/1/21.
//

import Foundation

class BASmartCustomerCatalogDetail: NSObject {
    static let shared = BASmartCustomerCatalogDetail()
    
    var customerKind = [BASmartCustomerCatalogItems]()
    var ethnic = [BASmartCustomerCatalogItems]()
    var gender = [BASmartCustomerCatalogItems]()
    var humanKind = [BASmartCustomerCatalogItems]()
    var leaveLevel = [BASmartCustomerCatalogItems]()
    var marital = [BASmartCustomerCatalogItems]()
    var model = [BASmartCustomerCatalogItems]()
    var position = [BASmartCustomerCatalogItems]()
    var provider = [BASmartCustomerCatalogItems]()
    var purpose = [BASmartCustomerCatalogItems]()
    var region = [BASmartCustomerCatalogItems]()
    var religion = [BASmartCustomerCatalogItems]()
    var scale = [BASmartCustomerCatalogItems]()
    var side = [BASmartCustomerCatalogItems]()
    var source = [BASmartCustomerCatalogItems]()
    var state = [BASmartCustomerCatalogItems]()
    var transport = [BASmartCustomerCatalogItems]()
    var type = [BASmartCustomerCatalogItems]()
    var rate = [BASmartCustomerCatalogItems]()
    var reason = [BASmartCustomerCatalogItems]()
    var project = [BASmartCustomerCatalogItems]()
    var ability = [BASmartCustomerCatalogItems]()
    var department = [BASmartCustomerCatalogItems]()
    var humanProf: [BASmartCustomerCatalogItemsDetail]?
    
    func setBASmartCustomerCatalog(customerKind: [BASmartCustomerCatalogItems],
                                   ethnic: [BASmartCustomerCatalogItems],
                                   gender: [BASmartCustomerCatalogItems],
                                   humanKind: [BASmartCustomerCatalogItems],
                                   leaveLevel: [BASmartCustomerCatalogItems],
                                   marital: [BASmartCustomerCatalogItems],
                                   model: [BASmartCustomerCatalogItems],
                                   position: [BASmartCustomerCatalogItems],
                                   provider: [BASmartCustomerCatalogItems],
                                   purpose: [BASmartCustomerCatalogItems],
                                   region: [BASmartCustomerCatalogItems],
                                   religion: [BASmartCustomerCatalogItems],
                                   scale: [BASmartCustomerCatalogItems],
                                   side: [BASmartCustomerCatalogItems],
                                   source: [BASmartCustomerCatalogItems],
                                   state: [BASmartCustomerCatalogItems],
                                   transport: [BASmartCustomerCatalogItems],
                                   type: [BASmartCustomerCatalogItems],
                                   rate: [BASmartCustomerCatalogItems],
                                   reason: [BASmartCustomerCatalogItems],
                                   project: [BASmartCustomerCatalogItems],
                                   ability: [BASmartCustomerCatalogItems],
                                   department: [BASmartCustomerCatalogItems],
                                   humanProf:  [BASmartCustomerCatalogItemsDetail]) {
        
        self.customerKind = customerKind
        self.ethnic = ethnic
        self.gender = gender
        self.humanKind = humanKind
        self.leaveLevel = leaveLevel
        self.marital = marital
        self.model = model
        self.position = position
        self.provider = provider
        self.purpose = purpose
        self.region = region
        self.religion = religion
        self.scale = scale
        self.side = side
        self.source = source
        self.state = state
        self.transport = transport
        self.type = type
        self.rate = rate
        self.reason = reason
        self.project = project
        self.ability = ability
        self.department = department
        self.humanProf = humanProf
    }
}
