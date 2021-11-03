//
//  VehicleModel.swift
//  BAPMobile
//
//  Created by Emcee on 7/7/21.
//

import Foundation


struct VehiclePhotoListParam: Codable {
    var kindId: Int?
    var objectId: Int?
    
    enum CodingKeys: String, CodingKey {
        case kindId = "kindid"
        case objectId = "objectid"
    }
}

struct VehiclePhotolistModel: Codable {
    var state: Bool?
    var error: Int?
    var message: String?
    var data: VehiclePhotolistData?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error = "errorcode"
        case data = "data"
    }
}

struct VehiclePhotolistData: Codable {
    var photo: [VehiclePhotoParam]?
    var type: [BASmartDetailInfo]?
}

struct VehiclePhotoParam: Codable {
    var id: Int?
    var group: String?
    var kind: Int?
    var type: String?
    var task: VehicleTaskParam?
    var quote: String?
    var linkFull: String?
    var linkSmall: String?
    var editer: String?
    var editTime: Int?
    var flag: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "objectid"
        case group = "groupstr"
        case kind = "kindid"
        case type = "typestr"
        case task = "taskinfo"
        case quote = "quote"
        case linkFull = "linkfull"
        case linkSmall = "linksmall"
        case editer = "editerstr"
        case editTime = "edittime"
        case flag = "flagabort"
    }
}

struct VehicleTaskParam: Codable {
    var partner: String?
    var task: String?
    
    enum CodingKeys: String, CodingKey {
        case partner = "partnercode"
        case task = "tasknumber"
    }
}

struct VehicleUploadImageParam: Codable {
    var kindId: Int?
    var objectId: Int?
    var type: Int?
    var task: VehicleTaskParam?
    var quote: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case kindId = "kindid"
        case objectId = "objectid"
        case type = "typeid"
        case task = "taskinfo"
        case quote = "quote"
        case image = "imgdata"
    }
}
