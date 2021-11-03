//
//  BASmartWarrantyModel.swift
//  BAPMobile
//
//  Created by Emcee on 6/29/21.
//

import Foundation
import UIKit

struct BASmartTechnicalTask: Codable {
    var state: Bool?
    var errorcode: Int?
    var message: String?
    var data: [BASmartTechnicalData]?
}

struct BASmartTechnicalData: Codable {
    var task: BASmartTaskData?
    var customer: BASmartCustomerInfo?
    var contact: BASmartContactInfo?
    var account: String?
    var implement: Int?
    var address: String?
    var location: BASmartLocationParam?
    var partner: BASmartCustomerPartnerInfo?
    var seller: BASmartContactInfo?
    
    enum CodingKeys: String, CodingKey {
        case task = "taskinfo"
        case customer = "customerinfo"
        case contact = "contactinfo"
        case account = "accountstr"
        case implement = "implementtime"
        case address = "address"
        case location = "location"
        case partner = "partnerinfo"
        case seller = "sellerinfo"
    }
    
}

struct BASmartTaskData: Codable {
    var icon: String?
    var bcolor: String?
    var fcolor: String?
    var kind: String?
    var kindId: Int?
    var id: Int?
    var taskNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case icon = "iconstr"
        case bcolor = "bcolor"
        case fcolor = "fcolor"
        case kind = "kindstr"
        case kindId = "kindid"
        case id = "taskid"
        case taskNumber = "tasknumber"
    }
}

struct BASmartCustomerInfo: Codable {
    var xncode: String?
    var khcode: String?
    var maxn: Int?
    var code: String?
    var name: String?
    var address: String?
    var phone: String?
}

struct BASmartContactInfo: Codable {
    var name: String?
    var mobile: String?
}

struct BASmartTechnicalDetailTaskParam: Codable {
    var taskid: Int?
    var location: BASmartLocationParam?
}

struct BASmartTechnicalDetailTask: Codable {
    var state: Bool?
    var errorcode: Int?
    var message: String?
    var data: BASmartTechnicalDetailTaskData?
}

struct BASmartTechnicalDetailTaskData: Codable {
    var file: [BASmartFileAttach]?
    var memo: [BASmartMemo]?
    var vehicle: [BASmartVehicle]?
    var mstate: [BASmartDetailInfo]?
    var permission: BASmartPermission?
    
    enum CodingKeys: String, CodingKey {
        case file = "fileattach"
        case memo = "memolist"
        case vehicle = "vehiclelist"
        case mstate = "mstatelist"
        case permission = "permission"
    }
}

struct BASmartFileAttach: Codable {
    var editTime: Int?
    var abort: Bool?
    var group: String?
    var kind: Int?
    var full: String?
    var small: String?
    var objectId: Int?
    
    enum CodingKeys: String, CodingKey {
        case editTime = "edittime"
        case abort = "flagabort"
        case group = "groupstr"
        case kind = "kindid"
        case full = "linkfull"
        case small = "linksmall"
        case objectId = "objectid"
    }
}

struct BASmartMemo: Codable {
    var title: String?
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "titlestr"
        case content = "content"
    }
}

struct BASmartVehicle: Codable {
    var id: Int?
    var display: BASmartDisplay?
    var plate: String?
    var dev: String?
    var dateActived: Int?
    var imei: Int?
    var state: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "vehicleid"
        case display = "displayinfo"
        case plate = "platestr"
        case dev = "devgroup"
        case dateActived = "dateactived"
        case imei = "imeinumber"
        case state = "state"
    }
}

struct BASmartPermission: Codable {
    var getTask: Bool?
    var giveBack: Bool?
    var implement: Bool?
    var transfer: Bool?
    var vehicleAdd: Bool?
    
    enum CodingKeys: String, CodingKey {
        case getTask = "gettask"
        case giveBack = "giveback"
        case implement = "implement"
        case transfer = "transfer"
        case vehicleAdd = "vehicleadd"
    }
}

struct BASmartDisplay: Codable {
    var bcolor: String?
    var fcolor: String?
    var icon: String?
}

struct BASmartVehicleList: Codable {
    var state: Bool?
    var error: Int?
    var message: String?
    var data: [BASmartVehicle]?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error = "errorcode"
        case message = "message"
        case data = "data"
    }
}

struct BASmartVehicleSearchParam: Codable {
    var id: Int?
    var key: String?
    var location: BASmartLocationParam?
    
    enum CodingKeys: String, CodingKey {
        case id = "taskid"
        case key = "searchstr"
        case location = "location"
    }
}

struct BASmartTechnicalVehicleActionParam: Codable {
    var kind: Int?
    var task: Int?
    var vehicles: [BASmartVehicleListAction]?
    var location: BASmartLocationParam?
    
    enum CodingKeys: String, CodingKey {
        case kind = "kindid"
        case task = "taskid"
        case vehicles = "vehiclelist"
        case location = "location"
    }
}

struct BASmartVehicleListAction: Codable {
    var id: Int?
    var state: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "vehicleid"
        case state = "state"
    }
}

struct BASmartUploadAttachParam: Codable {
    var task: BASmartUploadAttachTaskInfo?
    var file: [BASmartFileAttachParam]?
    
    enum CodingKeys: String, CodingKey {
        case task = "taskinfo"
        case file = "fileattach"
    }
}


struct BASmartUploadAttachTaskInfo: Codable {
    var task: Int?
    var partner: String?
    var number: String?
    
    enum CodingKeys: String, CodingKey {
        case task = "taskid"
        case partner = "partnercode"
        case number = "tasknumber"
    }
}

struct BASmartFileAttachParam: Codable {
    var imgdata: String?
}

struct BASmartDeleteAttachParam: Codable {
    var task: Int?
    var objectId: Int?
    
    enum CodingKeys: String, CodingKey {
        case task = "taskid"
        case objectId = "objectid"
    }
}


struct BASmartTechnicalTransferParam: Codable {
    var task: Int?
    var state: Int?
    var location: BASmartLocationParam?
    
    enum CodingKeys: String, CodingKey {
        case task = "taskid"
        case state = "mstate"
        case location = "location"
    }
}

struct BASmartSavedAttachs: Codable {
    var name: String?
    var image: Data?
}

struct BASmartVehiclePhotoSearchParam: Codable {
    var xn: Int?
    var plate: String?
    
    enum CodingKeys: String, CodingKey {
        case xn = "xncode"
        case plate = "platestr"
    }
}


struct BASmartVehiclePhotoSearch: Codable {
    var state: Bool?
    var error: Int?
    var message: String?
    var data: BASmartVehiclePhotoSearchData?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error = "errorcode"
        case message = "message"
        case data = "data"
    }
}

struct BASmartVehiclePhotoSearchData: Codable {
    var menu: [BASmartDetailMenuDetail]?
    var vehicle: [BASmartVehicleSearchData]?
}

struct BASmartVehicleSearchData: Codable {
    var objectId: Int?
    var partner: BASmartCustomerPartnerInfo?
    var customer: BASmartCustomerInfo?
    var vehicle: BASmartVehicleSearchInfo?
    var blur: Bool?
    var seller: BASmartContactInfo?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectid"
        case partner = "partnerinfo"
        case customer = "customerinfo"
        case vehicle = "vehicleinfo"
        case blur = "blurflag"
        case seller = "sellerinfo"
    }
}

struct BASmartVehicleSearchInfo: Codable {
    var plate: String?
    var date: Int?
    var imei: String?
    var dev: String?
    var simNumber: String?
    var simNetwork: String?
    var gpsTime: Int?
    var state: String?
    
    enum CodingKeys: String, CodingKey {
        case plate = "platestr"
        case date = "dateactived"
        case imei = "imeinumber"
        case dev = "devgroup"
        case simNumber = "simnumber"
        case simNetwork = "simnetwork"
        case gpsTime = "gpstime"
        case state = "state"
    }
}
