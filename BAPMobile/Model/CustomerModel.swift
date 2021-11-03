//
//  CustomerModel.swift
//  BAPMobile
//
//  Created by Emcee on 12/18/20.
//

import Foundation

struct CustomerModel: Codable {
    var error_code: Int
    var message: String?
    var state: Bool
    var data: [CustomerData]
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct CustomerData: Codable {
    var address: String?
    var kh_code: String?
    var name: String?
    var object_id: Int?
    var phone: String?
    var region: String?
    var type_id: Int?
    var vehicle_count: Int?
    var xn_code: Int?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case kh_code = "khcode"
        case name = "name"
        case object_id = "objectid"
        case phone = "phone"
        case region = "region"
        case type_id = "typeid"
        case vehicle_count = "vehiclecount"
        case xn_code = "xncode"
    }
}


struct CustomerCarModel: Codable {
    var error_code: Int
    var message: String?
    var state: Bool
    var data: [CustomerCarData]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct CustomerCarData: Codable {
    var btflag: Bool?
    var checkflag: Bool?
    var exttime: Int?
    var gpstime: Int?
    var grflag: Bool?
    var mcflag: Bool?
    var scflag: Bool?
    var state: Int?
    var totalday: Int?
    var vehicleid: Int?
    var vehicleplate: String?
}


struct VGSTastCreateParam: Codable {
    var guarantee: Int
    var data: [VehicleId]
}

struct VehicleId: Codable {
    var vehicleid: Int
}

