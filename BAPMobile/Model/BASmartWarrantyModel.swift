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
    var vehicleCount: Int?
    
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
        case vehicleCount = "vehiclecount"
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
    var button: BASmartTechnicalButtonStyle?
    var commodity: [BASmartCommodity]?
    var feature: [BASmartFeature]?
    var menu: [BASmartMenuActionModel]?
    var tab: [BASmartMenuActionModel]?
    
    enum CodingKeys: String, CodingKey {
        case file = "fileattach"
        case memo = "memolist"
        case vehicle = "vehiclelist"
        case mstate = "mstatelist"
        case permission = "permission"
        case button = "buttonstyle"
        case commodity = "commoditylist"
        case feature = "featurelist"
        case menu = "menuaction"
        case tab = "tabaction"
    }
}

struct BASmartTechnicalButtonStyle: Codable {
    var bcolor: String?
    var fcolor: String?
    var quote: String?
    var text: String?
}

struct BASmartCommodity: Codable {
    var name: String?
    var quantity: Int?
}

struct BASmartFeature: Codable {
    var id: Int?
    var name: String?
    var state: Bool?
    var group: String?
}

struct BASmartMenuActionModel: Codable {
    var icon: String?
    var id: Int?
    var name: String?
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


struct BASmartInventoryList: Codable {
    var state: Bool?
    var errorCode: Int?
    var data: BASmartInventoryListData?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case errorCode = "errorcode"
        case data = "data"
    }
}

struct BASmartInventoryListData: Codable {
    var stock: ContactBranch?
    var commodity: [BASmartInventoryCommodity]?
}

struct BASmartInventoryCommodity: Codable {
    var objectId: Int?
    var name: String?
    var quantity:Int?
    var imei: Bool?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectid"
        case name = "name"
        case quantity = "quantity"
        case imei = "imeiflag"
    }
}


struct BASmartInventoryDetail: Codable {
    var state: Bool?
    var errorCode: Int?
    var data: BASmartInventoryDetailData?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case errorCode = "errorcode"
        case data = "data"
    }
}

struct BASmartInventoryDetailData: Codable {
    var viewAll: Bool?
    var imei: [BASmartInventoryDetailImei]?
    
    enum CodingKeys: String, CodingKey {
        case viewAll = "viewall"
        case imei = "imeilist"
    }
}

struct BASmartInventoryDetailImei: Codable {
    var id: Int?
    var kind: String?
    var imei: String?
    var time: Int?
    var state: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "resourceid"
        case kind = "kindstr"
        case imei = "imeinumber"
        case time = "timeindex"
        case state = "state"
    }
}

struct BASmartInventoryStatusParam: Codable {
    var id: Int?
    var state: Bool?
    var type: Int?
    var reason: String
    
    enum CodingKeys: String, CodingKey {
        case id = "resourceid"
        case type = "typeid"
        case reason = "reason"
        case state = "state"
    }
}


struct BASmartWarehouseCustomer: Codable {
    var state: Bool?
    var errorCode: Int?
    var data: [BASmartWarehouseCustomerData]?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case errorCode = "errorcode"
        case data = "data"
    }
}

struct BASmartWarehouseCustomerData: Codable {
    var objectId: Int?
    var kind: BASmartDetailInfo?
    var project: BASmartDetailInfo?
    var source: String?
    var kh: String?
    var name: String?
    var phone: String?
    var scale: BASmartDetailInfo?
    var model: BASmartDetailInfo?
    var rate: String?
    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectid"
        case kind = "kindinfo"
        case project = "projectinfo"
        case source = "sourcestr"
        case kh = "khcode"
        case name = "name"
        case phone = "phone"
        case scale = "scaleinfo"
        case model = "modelinfo"
        case rate = "ratestr"
        case address = "address"
    }
}

struct BASmartWarehouseCatalog: Codable {
    var state: Bool?
    var errorCode: Int?
    var data: BASmartWarehouseCatalogData?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case errorCode = "errorcode"
        case data = "data"
    }
}

struct BASmartWarehouseCatalogData: Codable {
    var project: [BASmartDetailInfo]?
    var ckind: [BASmartDetailInfo]?
    var type: [BASmartDetailInfo]?
    var model: [BASmartDetailInfo]?
    var scale: [BASmartDetailInfo]?
    var branch: [BASmartDetailInfo]?
    var approachProject: [BASmartDetailInfo]?
    var pkind: [BASmartDetailInfo]?
    var rate: [BASmartDetailInfo]?
    
    enum CodingKeys: String, CodingKey {
        case project = "projectlist"
        case ckind = "ckindlist"
        case type = "ctypelist"
        case model = "modellist"
        case scale = "scalelist"
        case branch = "branchlist"
        case approachProject = "aprprjlist"
        case pkind = "pkindlist"
        case rate = "aratelist"
    }
}

struct BASmartWarehouseCreateCustomerParam: Codable {
    var general: BASmartWarehouseCreateGeneral?
    var approach: BASmartWarehouseCreateApproach?
}

struct BASmartWarehouseCreateGeneral: Codable {
    var kind: BASmartIdInfo?
    var type: BASmartIdInfo?
    var project: BASmartIdInfo?
    var source: BASmartSourceName?
    var name: String?
    var phone: String?
    var contact: String?
    var scale: BASmartIdInfo?
    var model: BASmartIdInfo?
    var address: String?
    var location: BASmartLocationParam?
    var branch: BASmartIdInfo?
    
    enum CodingKeys: String, CodingKey {
        case kind = "kindinfo"
        case type = "typeinfo"
        case project = "projectinfo"
        case source = "sourceinfo"
        case name = "name"
        case phone = "phone"
        case contact = "contact"
        case scale = "scaleinfo"
        case model = "modelinfo"
        case address = "address"
        case location = "location"
        case branch = "branchinfo"
    }
}

struct BASmartWarehouseCreateApproach: Codable {
    var ignore: Bool?
    var kind: Int?
    var project: [BASmartIdInfo]?
    var rate: Int?
    var result: String?
    var vehicleCount: Int?
    var expected: Int?
    var scheme: String?
    var next: Int?
    
    enum CodingKeys: String, CodingKey {
        case ignore = "ignoreflag"
        case kind = "pkindid"
        case project = "projectlist"
        case rate = "rateid"
        case result = "resultstr"
        case vehicleCount = "vehiclecount"
        case expected = "expectedtime"
        case scheme = "schemestr"
        case next = "nexttime"
    }
    
}

struct BASmartSourceName: Codable {
    var name: String?
}

