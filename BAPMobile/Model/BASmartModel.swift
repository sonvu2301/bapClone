//
//  BASmartModel.swift
//  BAPMobile
//
//  Created by Emcee on 12/30/20.
//

import Foundation

struct BASmartModel: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: BASmartData?
}

struct BASmartData: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var customer_data: BASmartHomeScreenCustomerData?
    var schedule_list: [BASmartSchedule]?
    var warning_data: BASmartWarningData?
    var working_data: BASmartWorkingData?
    var work_mark: BASmartWorkMarkData?
    var work_move: BASmartWorkMoveData?
    
    enum CodingKeys: String, CodingKey {
        case customer_data = "customerdata"
        case schedule_list = "schedulelist"
        case warning_data = "warningdata"
        case working_data = "workingdata"
        case work_mark = "workmark"
        case work_move = "workmove"
    }
}

struct BASmartDailyWorkingParam: Codable {
    var photolist: [BASmartDailyWorkingPhotolist]
}

struct BASmartDailyWorkingPhotolist: Codable {
    var image: String
    var time: Int
    
    enum CodingKeys: String, CodingKey {
        case image = "imgdata"
        case time = "timeindex"
    }
}

struct BASmartHomeScreenCustomerData: Codable {
    var data_count: Int?
    var quote: String?
    var title: String?
    var unit_name: String?
    
    enum CodingKeys: String, CodingKey {
        case data_count = "datacount"
        case quote = "quotestr"
        case title = "titlestr"
        case unit_name = "unitname"
    }
}

struct BASmartSchedule: Codable {
    var end_time: Int?
    var start_time: Int?
    var state: Int?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case end_time = "endtime"
        case start_time = "starttime"
        case state = "state"
        case title = "titlestr"
    }
}

struct BASmartWarningData: Codable {
    var data_list: [BASmartWaringDataList]?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case data_list = "datalist"
        case title = "titlestr"
    }
}

struct BASmartWaringDataList: Codable {
    var icon: String?
    var time: Int?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case icon = "iconstr"
        case time = "timeindex"
        case title = "titlestr"
    }
}

struct BASmartWorkingData: Codable {
    var data_count: Int?
    var quote: String?
    var title: String?
    var unit_name: String?
    
    enum CodingKeys: String, CodingKey {
        case data_count = "datacount"
        case quote = "quotestr"
        case title = "titlestr"
        case unit_name = "unitname"
    }
}


struct BASmartWorkMarkData: Codable {
    var data_list: [BASmartWorkMarkDataList]
    var line_color: String?
    var line_quote: String?
    var line_value: Int?
    var main_quote: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case data_list = "datalist"
        case line_color = "linecolor"
        case line_quote = "linequote"
        case line_value = "linevalue"
        case main_quote = "mainquote"
        case title = "titlestr"
    }
}

struct BASmartWorkMarkDataList: Codable {
    var color: String?
    var index: Int?
    var value: Int?
}

struct BASmartWorkMoveData: Codable {
    var data_list: [BASmartWorkMoveDataList]?
    var line_color: String?
    var line_quote: String?
    var line_value: Int?
    var main_quote: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case data_list = "datalist"
        case line_color = "linecolor"
        case line_quote = "linequote"
        case line_value = "linevalue"
        case main_quote = "mainquote"
        case title = "titlestr"
    }
}

struct BASmartWorkMoveDataList: Codable {
    var color: String?
    var index: Int?
    var value: Int?
}


//MARK: Customer List

struct BASmartCustomerList: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: [BASmartCustomerListData]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct BASmartCustomerListData: Codable {
    var address: String?
    var group_id: Int?
    var kh_code: String?
    var name: String?
    var object_id: Int?
    var phone: String?
    var rank_info: BASmartCustomerListRank?
    var region: String?
    var state_info: BASmartCustomerListStateInfo?
    var vehicle_count: Int?
    var xn_code: String?
    var blur: Bool?
    var partner: BASmartCustomerPartnerInfo?
    var rate: BASmartCustomerListRank?
    var seller: BASmartCustomerListRank?
    
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case group_id = "groupid"
        case kh_code = "khcode"
        case name = "name"
        case object_id = "objectid"
        case phone = "phone"
        case rank_info = "rankinfo"
        case region = "region"
        case state_info = "stateinfo"
        case vehicle_count = "vehiclecount"
        case xn_code = "xncode"
        case blur = "blurflag"
        case partner = "partnerinfo"
        case rate = "rateinfo"
        case seller = "sellerinfo"
    }
}

struct BASmartCustomerPartnerInfo: Codable {
    var bcolor: String?
    var code: String?
    var fcolor: String?
    var ricon: String?
    var ticon: String?
}

struct BASmartCustomerListRank: Codable {
    var color: String?
    var name: String?
    var opts: Int?
}

struct BASmartCustomerListStateInfo: Codable {
    var color: String?
    var name: String?
    var opts: Int?
}

struct BASmartCustomerDetail: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: BASmartCustomerDetailData?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct BASmartCustomerDetailData: Codable {
    var approach_list: [BASmartCustomerDetailApproachList]?
    var competitor_list: [BASmartCustomerDetailCompetitorList]?
    var general_info: BASmartCustomerDetailGeneral?
    var human_list: [BASmartCustomerDetailHumanList]?
    var menu_action: BASmartCustomerDetailMenuAction?
    var vehicle_list: [BASmartCustomerVehicleList]?
    var partner_list: [BASmartPartnerList]?
    
    enum CodingKeys: String, CodingKey {
        case approach_list = "approachlist"
        case competitor_list = "competitorlist"
        case general_info = "generalinfo"
        case human_list = "humanlist"
        case menu_action = "menuaction"
        case vehicle_list = "vehiclelist"
        case partner_list = "partnerlist"
    }
}

struct BASmartCustomerUpdateParam: Codable {
    var address: String?
    var contact: String?
    var description: String?
    var email: String?
    var facebook: String?
    var foundation: String?
    var kind_info: Int?
    var location: BASmartLocationParam?
    var modelList: [BASmartCustomerModel]?
    var name: String?
    var object_id: Int?
    var phone: String?
//    var scale_info: Int?
    var taxoridn: String?
    var type_info: Int?
    var website: String?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case contact = "contact"
        case description = "description"
        case email = "email"
        case facebook = "facebook"
        case foundation = "foundation"
        case kind_info = "kindid"
        case location = "location"
        case modelList = "modellist"
        case name = "name"
        case object_id = "objectid"
        case phone = "phone"
//        case scale_info = "scaleid"
        case taxoridn = "taxoridn"
        case type_info = "typeid"
        case website = "website"
    }
}

struct BASmartCustomerModel: Codable {
    var id: Int?
    var ri: Int?
}

struct BASmartPartnerList: Codable {
    var code: String?
    var name: String?
    var icon: String?
}

struct BASmartPartnerInfo: Codable {
    var code: String?
    var icon: String?
}

struct BASmartCustomerCatalog: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: BASmartCustomerCatalogData?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}



struct BASmartApproachParam: Codable {
    var customerId: Int?
    var objectId: Int?
    var start: Int?
    var total: Int?
    var purpose: [BASmartCustomerCatalogItems]?
    var result: String?
    var vehicleCount: Int?
    var expectedTime: Int?
    var scheme: String?
    var transport: BASmartCustomerCatalogItems?
    var nextTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customerid"
        case objectId = "objectid"
        case start = "starttime"
        case total = "totaltime"
        case purpose = "purposelist"
        case result = "resultstr"
        case vehicleCount = "vehiclecount"
        case expectedTime = "expectedtime"
        case scheme = "schemestr"
        case transport = "transportinfo"
        case nextTime = "nextTime"
    }
}


struct BASmartApproachResult: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: BASmartApproachResultData?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct BASmartApproachResultData: Codable {
    var objectId: Int?
    var rate: BASmartCustomerCatalogItems?
    var start: Int?
    var total: Int?
    var purpose: [BASmartCustomerCatalogItems]?
    var address: String?
    var location: BASmartLocationParam?
    var result: String?
    var vehicleCount: Int?
    var expectedTime: Int?
    var scheme: String?
    var transport: BASmartCustomerCatalogItems?
    var nextTime: Int?
    var photoList: [BASmartImageLink]?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectid"
        case rate = "rateinfo"
        case start = "starttime"
        case total = "totaltime"
        case purpose = "purposelist"
        case address = "address"
        case location = "location"
        case result = "resultstr"
        case vehicleCount = "vehiclecount"
        case expectedTime = "expectedtime"
        case scheme = "schemestr"
        case transport = "transportinfo"
        case nextTime = "nexttime"
        case photoList = "photolist"
    }
}

struct BASmartCustomerCreateApproachParam: Codable {
    var customerId: Int?
//    var planId: Int?
    var pkind: Int?
    var start: Int?
    var total: Int?
    var project: [BASmartIdInfo]?
    var rate: Int?
    var reason: [BASmartIdInfo]?
    var ability: Int?
    var result: String?
    var vehicleCount: Int?
    var expect: Int?
    var scheme: String?
    var price: Int?
    var transport: Int?
    var next: Int?
    var department: Int?
    var location: BASmartLocationParam?
    var purpose: [BASmartIdInfo]?
    var photo: [BASmartDailyWorkingPhotolist]?
    var ignore: Bool?
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customerid"
//        case planId = "planid"
        case pkind = "pkindid"
        case start = "starttime"
        case total = "totaltime"
        case project = "projectlist"
        case rate = "rateid"
        case reason = "reasonlist"
        case ability = "abilityid"
        case result = "resultstr"
        case vehicleCount = "vehiclecount"
        case expect = "expectedtime"
        case scheme = "schemestr"
        case price = "pricevalue"
        case transport = "transportid"
        case next = "nexttime"
        case department = "departmentid"
        case location = "location"
        case purpose = "purposelist"
        case photo = "photolist"
        case ignore = "ignoreflag"
    }
}


struct BASmartCustomerCatalogData: Codable {
    var customer_kind: [BASmartCustomerCatalogItems]?
    var ethnic: [BASmartCustomerCatalogItems]?
    var gender: [BASmartCustomerCatalogItems]?
    var human_kind: [BASmartCustomerCatalogItems]?
    var leave_level: [BASmartCustomerCatalogItems]?
    var marital: [BASmartCustomerCatalogItems]?
    var model: [BASmartCustomerCatalogItems]?
    var position: [BASmartCustomerCatalogItems]?
    var provider: [BASmartCustomerCatalogItems]?
    var purpose: [BASmartCustomerCatalogItems]?
    var region: [BASmartCustomerCatalogItems]?
    var religion: [BASmartCustomerCatalogItems]?
    var scale: [BASmartCustomerCatalogItems]?
    var side: [BASmartCustomerCatalogItems]?
    var source: [BASmartCustomerCatalogItems]?
    var state: [BASmartCustomerCatalogItems]?
    var transport: [BASmartCustomerCatalogItems]?
    var type: [BASmartCustomerCatalogItems]?
    var rate: [BASmartCustomerCatalogItems]?
    var reason: [BASmartCustomerCatalogItems]?
    var project: [BASmartCustomerCatalogItems]?
    var department: [BASmartCustomerCatalogItems]?
    var ability: [BASmartCustomerCatalogItems]?
    var humanProf: [BASmartCustomerCatalogItemsDetail]?
    
    enum CodingKeys: String, CodingKey {
        case customer_kind = "customerkind"
        case ethnic = "ethniclist"
        case gender = "genderlist"
        case human_kind = "humankind"
        case leave_level = "leavelevel"
        case marital = "maritallist"
        case model = "modellist"
        case position = "positionlist"
        case provider = "providerlist"
        case purpose = "purposelist"
        case region = "regionlist"
        case religion = "religionlist"
        case scale = "scalelist"
        case side = "sidelist"
        case source = "sourcelist"
        case state = "statelist"
        case transport = "transportlist"
        case type = "typelist"
        case rate = "ratelist"
        case reason = "reasonlist"
        case project = "projectlist"
        case department = "departmentlist"
        case ability = "abilitylist"
        case humanProf = "humanprof"
    }
}

struct BASmartCustomerCatalogItems: Codable {
    var id: Int?
    var ri: Int?
    var name: String?
    var target: Bool?
}

struct BASmartCustomerCatalogItemsDetail: Codable {
    var id: Int?
    var name: String?
    var state: Bool?
    var group: String?
}

struct BASmartCustomerDetailApproachList: Codable {
    var objectId: Int?
    var projectList: [BASmartDetailInfo]?
    var rate: BASmartDetailInfo?
    var reason: [BASmartDetailInfo]?
    var ability: BASmartDetailInfo?
    var startTime: Int?
    var totalTime: Int?
    var purposeList: [BASmartDetailInfo]?
    var address: String?
    var location: BASmartLocationParam?
    var result: String?
    var vehicleCount: Int?
    var expectedTime: Int?
    var scheme: String?
    var price: BASmartCustomerPriceInfo?
    var nextTime: Int?
    var department: BASmartDetailInfo?
    var transport: BASmartDetailInfo?
    var photo: [BASmartImageLink]?
    var opinion: [BASmartCustomerOpinion]?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectid"
        case projectList = "projectlist"
        case rate = "rateinfo"
        case reason = "reasonlist"
        case ability = "abilityinfo"
        case startTime = "starttime"
        case totalTime = "totaltime"
        case purposeList = "purposelist"
        case address = "address"
        case location = "location"
        case result = "resultstr"
        case vehicleCount = "vehiclecount"
        case expectedTime = "expectedtime"
        case scheme = "schemestr"
        case price = "priceinfo"
        case nextTime = "nexttime"
        case department = "departmentinfo"
        case transport = "transportinfo"
        case photo = "photolist"
        case opinion = "opinionlist"
        case icon = "iconsrc"
    }
}

struct BASmartCustomerDetailCompetitorList: Codable {
    var description: String?
    var expried_date: Int?
    var leave_level_info: BASmartDetailInfo?
    var object_id: Int?
    var price_str: String?
    var provider_info: BASmartDetailInfo?
    var vehicle_count: Int?
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case expried_date = "exprieddate"
        case leave_level_info = "leavelevelinfo"
        case object_id = "objectid"
        case price_str = "pricestr"
        case provider_info = "providerinfo"
        case vehicle_count = "vehiclecount"
    }
}

struct BASmartCustomerDetailGeneral: Codable {
    var address: String?
    var contact: String?
    var description: String?
    var email: String?
    var facebook: String?
    var foundation: String?
    var group_id: Int?
    var kh_code: String?
    var kind_info: BASmartDetailInfo?
    var location: BASmartLocationParam?
    var model_list: [BASmartModelInfo]?
    var name: String?
    var object_id: Int?
    var phone: String?
    var region_info: BASmartDetailInfo?
    var scale_info: BASmartDetailInfo?
    var source_info: BASmartDetailInfo?
    var taxoridn: String?
    var type_info: BASmartDetailInfo?
    var website: String?
    var xn_code: String?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case contact = "contact"
        case description = "description"
        case email = "email"
        case facebook = "facebook"
        case foundation = "foundation"
        case group_id = "groupid"
        case kh_code = "khcode"
        case kind_info = "kindinfo"
        case location = "location"
        case model_list = "modellist"
        case name = "name"
        case object_id = "objectid"
        case phone = "phone"
        case region_info = "regioninfo"
        case scale_info = "scaleinfo"
        case source_info = "sourceinfo"
        case taxoridn = "taxoridn"
        case type_info = "typeinfo"
        case website = "website"
        case xn_code = "xncode"
    }
}

struct BASmartCustomerDetailHumanList: Codable {
    var birthday: String?
    var email: String?
    var ethnic_info: BASmartDetailInfo?
    var facebook: String?
    var full_name: String?
    var gender_info: BASmartDetailInfo?
    var hobbit: String?
    var kind_info: BASmartDetailInfo?
    var marital_info: BASmartDetailInfo?
    var object_id: Int?
    var phone: String?
    var position_info: BASmartDetailInfo?
    var religion_info: BASmartDetailInfo?
    var prof: [BASmartCustomerCatalogItemsDetail]?
    
    enum CodingKeys: String, CodingKey {
        case birthday = "birthday"
        case email = "email"
        case ethnic_info = "ethnicinfo"
        case facebook = "facebook"
        case full_name = "fullname"
        case gender_info = "genderinfo"
        case hobbit = "hobbit"
        case kind_info = "kindinfo"
        case marital_info = "maritalinfo"
        case object_id = "objectid"
        case phone = "phone"
        case position_info = "positioninfo"
        case religion_info = "religioninfo"
        case prof = "proflist"
    }
}

struct BASmartCustomerDetailMenuAction: Codable {
    var approach: [BASmartDetailMenuDetail]?
    var competitor: [BASmartDetailMenuDetail]?
    var human: [BASmartDetailMenuDetail]?
    var main: [BASmartDetailMenuDetail]?
}

struct BASmartCustomerPriceInfo: Codable {
    var price: Int?
    var style: BASmartCustomerListRank?
    
    enum CodingKeys: String, CodingKey {
        case price = "pricevalue"
        case style = "styleinfo"
    }
}

struct BASmartCustomerOpinion: Codable {
    var key: String?
    var val: String?
}

struct BASmartCustomerVehicleList: Codable {
    var object_id: Int?
    var provider_info: BASmartDetailInfo?
    var vehicle_plate: String?
    var register_date: Int?
    var expried_date: Int?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case object_id = "objectid"
        case provider_info = "providerinfo"
        case vehicle_plate = "vehicleplate"
        case register_date = "registerdate"
        case expried_date = "exprieddate"
        case description = "description"
    }
}

struct BASmartModelInfo: Codable {
    var id: Int?
    var name: String?
    var ri: Int?
}

struct BASmartDetailInfo: Codable {
    var id: Int?
    var name: String?
}

struct BASmartIdInfo: Codable {
    var id: Int?
}

struct BASmartDetailMenuDetail: Codable {
    var icon: String?
    var id: Int?
    var name: String?
}

struct BASmartCustomerTimeline: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: [BASmartCustomerTimelineData]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct BASmartCustomerTimelineData: Codable {
    var begin_group: Bool?
    var contact: String?
    var edit_time: Int?
    var group: String?
    var icon: String?
    var id: Int?
    var phone: String?
    var quote: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case begin_group = "begingroup"
        case contact = "contact"
        case edit_time = "edittime"
        case group = "groupstr"
        case icon = "iconsrc"
        case id = "indexid"
        case phone = "phone"
        case quote = "quotestr"
        case title = "titlestr"
    }
}

struct BASmartCustomerGallery: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: [BASmartCustomerGalleryData]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct BASmartCustomerGalleryData: Codable {
    var edit_time: Int?
    var group: String?
    var link_full: String?
    var link_small: String?
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case edit_time = "edittime"
        case group = "groupstr"
        case link_full = "linkfull"
        case link_small = "linksmall"
        case id = "objectid"
    }
}

struct BASmartImageLink: Codable {
    var link_full: String?
    var link_small: String?
    
    enum CodingKeys: String, CodingKey {
        case link_full = "linkfull"
        case link_small = "linksmall"
    }
}



// Checkin and get list of Side Menu
struct BASmartCheckin: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: BASmartCheckinData
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct BASmartCheckinAction: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: BASmartCheckinData?
    var menuList: [BASmartMenuList]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
        case menuList = "menulist"
    }
}

struct BASmartCheckoutModel: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: String?
    var menuList: [BASmartMenuList]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
        case menuList = "menulist"
    }
}

struct BASmartCheckinData: Codable {
    var menulist: [BASmartMenuList]?
    var state: Int?
    var wtime: Int?
}

struct BASmartMenuList: Codable {
    var icon: String?
    var menuid: Int?
    var name: String?
    var permis: Int?
}


struct BASmartCheckingParam: Codable {
    var state: Int
    var location: BASmartLocationParam
}

struct BASmartDailyWorkingCheckinParam: Codable {
    var plan: Int?
    var address: String?
    var location: BASmartLocationParam?
    var support: String
    
    enum CodingKeys: String, CodingKey {
        case plan = "planid"
        case address = "address"
        case location = "location"
        case support = "supportstr"
    }
}

struct BASmartCustomerCheckinParam: Codable {
    var id: Int?
    var address: String?
    var location: BASmartLocationParam?
    var support: String?
    var purpose: [BASmartIdInfo]?
    var end: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "customerid"
        case address = "address"
        case location = "location"
        case support = "supportstr"
        case end = "endtime"
        case purpose = "purposelist"
    }
}

struct BASmartDailyWorkingCheckoutParam: Codable {
    var rate: Int?
    var result: String?
    var purpose: [BASmartIdInfo]?
    var vehicleCount: Int?
    var expectTime: Int?
    var scheme: String?
    var nextTime: Int?
    var transport: Int?
    var location: BASmartLocationParam?
    var reason: [BASmartIdInfo]?
    var project: [BASmartIdInfo]?
    var department: Int?
    var ability: Int?
    
    enum CodingKeys: String, CodingKey {
        case rate = "rateid"
        case result = "resultstr"
        case purpose = "purposelist"
        case vehicleCount = "vehiclecount"
        case expectTime = "expectedtime"
        case scheme = "schemestr"
        case nextTime = "nexttime"
        case transport = "transportid"
        case location = "location"
        case reason = "reasonlist"
        case project = "projectlist"
        case department = "departmentid"
        case ability = "abilityid"
    }
}

struct BASmartLocationParam: Codable {
    var lng: Double
    var lat: Double
    var opt: Int
}

struct BASmartRequestReopenParam: Codable {
    var reason: String
    var location: BASmartLocationParam
}

struct BASmartRequestReopenConfirmParam: Codable {
    var id: Int
    var location: BASmartLocationParam
    var state: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "requestid"
        case location = "location"
        case state = "state"
    }
}


//MARK: BASmart Customer

struct BASmartAddHumanParam: Codable {
    var customerId: Int
    var kind: Int
    var name: String
    var phone: String
    var birthDay: String
    var gender: Int
    var marital: Int
    var ethnic: Int
    var religion: Int
    var position: Int
    var email: String
    var facebook: String
    var hobbit: String
    var profList: [BASmartVtype]
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customerid"
        case kind = "kindid"
        case name = "fullname"
        case phone = "phone"
        case birthDay = "birthday"
        case gender = "gender"
        case marital = "marital"
        case ethnic = "ethnicid"
        case religion = "religionid"
        case position = "positionid"
        case email = "email"
        case facebook = "facebook"
        case hobbit = "hobbit"
        case profList = "proflist"
    }
}

struct BASmartEditHumanParam: Codable {
    var customerId: Int
    var objectId: Int
    var kind: Int
    var name: String
    var phone: String
    var birthDay: String
    var gender: Int
    var marital: Int
    var ethnic: Int
    var religion: Int
    var position: Int
    var email: String
    var facebook: String
    var hobbit: String
    var profList: [BASmartVtype]
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customerid"
        case objectId = "objectid"
        case kind = "kindid"
        case name = "fullname"
        case phone = "phone"
        case birthDay = "birthday"
        case gender = "gender"
        case marital = "marital"
        case ethnic = "ethnicid"
        case religion = "religionid"
        case position = "positionid"
        case email = "email"
        case facebook = "facebook"
        case hobbit = "hobbit"
        case profList = "proflist"
    }
}

struct BASmartAddCompetitorParam: Codable {
    var customerId: Int
    var provider: Int
    var vehicleCount: Int
    var level: Int
    var date: Int
    var price: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customerid"
        case provider = "providerid"
        case vehicleCount = "vehiclecount"
        case level = "leavelevel"
        case date = "exprieddate"
        case price = "pricestr"
        case description = "description"
    }
}

struct BASmartEditCompetitorParam: Codable {
    var customerId: Int
    var objectId: Int
    var provider: Int
    var vehicleCount: Int
    var level: Int
    var date: Int
    var price: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customerid"
        case objectId = "objectid"
        case provider = "providerid"
        case vehicleCount = "vehiclecount"
        case level = "leavelevel"
        case date = "exprieddate"
        case price = "pricestr"
        case description = "description"
    }
}


struct BASmartPlanListModel: Codable {
    var state: Bool?
    var error_code: Int?
    var message: String?
    var data: [BASmartPlanListData]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct BASmartPlanListData: Codable {
    var planId: Int?
    var partner: BASmartPartnerList?
    var kindInfo: BASmartKindInfo?
    var name: String?
    var start: Int?
    var end: Int?
    var address: String?
    var phone: String?
    var location: BASmartLocationParam?
    var purpose: [BASmartDetailInfo]?
    var rate: BASmartDetailInfo?
    var creatorInfo: BASmartContactInfo?
    var description: String?
    var menuAction: [BASmartDetailMenuDetail]?
    var stateInfo: BASmartStateInfo?
    
    enum CodingKeys: String, CodingKey {
        case planId = "planid"
        case partner = "partnerinfo"
        case kindInfo = "kindinfo"
        case name = "name"
        case start = "starttime"
        case end = "endtime"
        case address = "address"
        case phone = "phone"
        case location = "location"
        case purpose = "purposelist"
        case rate = "rateinfo"
        case creatorInfo = "creatorinfo"
        case description = "description"
        case menuAction = "menuaction"
        case stateInfo = "stateinfo"
    }
}

struct BASmartKindInfo: Codable {
    var name: String?
    var src: String
}

struct BASmartStateInfo: Codable {
    var id: Int?
    var name: String?
    var bcolor: String?
    var fcolor: String?
}

struct BASmartPlanListCheckinModel: Codable {
    var state: Bool?
    var error_code: Int?
    var message: String?
    var data: [BASmartPlanListCheckinData]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct BASmartPlanListCheckinData: Codable {
    var planId: Int?
    var partner: BASmartPartnerList?
    var name: String?
    var start: Int?
    var end: Int?
    var address: String?
    var location: BASmartLocationParam?
    var purpose: [BASmartDetailInfo]?
    var description: String?
    var state: String?
    
    enum CodingKeys: String, CodingKey {
        case planId = "planid"
        case partner = "partnerinfo"
        case name = "name"
        case start = "starttime"
        case end = "endtime"
        case address = "address"
        case location = "location"
        case purpose = "purposelist"
        case description = "description"
        case state = "state"
    }
}

struct BASmartCreatePlanParam: Codable {
    var sourceId: String?
    var objectId: Int?
    var day: Int?
    var start: Int?
    var end: Int?
    var address: String?
    var location: BASmartLocationParam?
    var purpose: [BASmartIdInfo]?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "sourceid"
        case objectId = "objectid"
        case day = "dayindex"
        case start = "starttime"
        case end = "endtime"
        case address = "address"
        case location = "location"
        case purpose = "purposelist"
        case description = "description"
    }
}

struct BASmartUpdatePlanParam: Codable {
    var objectId: Int?
    var day: Int?
    var start: Int?
    var end: Int?
    var address: String?
    var location: BASmartLocationParam?
    var purpose: [BASmartIdInfo]?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectid"
        case day = "dayindex"
        case start = "starttime"
        case end = "endtime"
        case address = "address"
        case location = "location"
        case purpose = "purposelist"
        case description = "description"
    }
}



struct BASmartPlanSearchCustomerParam: Codable {
    var day: Int?
    var key: String?
    var location: MapLocation?
    
    enum CodingKeys: String, CodingKey {
        case day = "dayindex"
        case key = "searchkey"
        case location = "location"
    }
}



struct BASmartCallListModel: Codable {
    var state: Bool?
    var error_code: Int?
    var message: String?
    var data: [BASmartCallData]?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error_code = "errorcode"
        case message = "message"
        case data = "data"
    }
}

struct BASmartCallData: Codable {
    var index: Int?
    var name: String?
    var phone: String?
    var state: Int?
    var call: Int?
    var group: String?
    
    
    enum CodingKeys: String, CodingKey {
        case index = "indexid"
        case name = "namestr"
        case phone = "phonestr"
        case state = "state"
        case call = "calltime"
        case group = "groupstr"
    }
}

struct BASmartReopenRequestModel: Codable {
    var state: Bool?
    var error_code: Int?
    var message: String?
    var data: [BASmartReopenRequestData]?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error_code = "errorcode"
        case message = "message"
        case data = "data"
    }
}

struct BASmartReopenRequestData: Codable {
    var color: String?
    var reason: String?
    var reqTime: Int?
    var requestId: Int?
    var state: Int?
    var userInfo: BASmartUserInfor?
    
    enum CodingKeys: String, CodingKey {
        case color = "color"
        case reason = "reason"
        case reqTime = "reqtime"
        case requestId = "requestid"
        case state = "state"
        case userInfo = "userinfo"
    }
}

struct BASmartUserInfor: Codable {
    var avatar: String?
    var fullName: String?
    var userName: String?
    
    enum CodingKeys: String, CodingKey {
        case avatar = "avatasrc"
        case fullName = "fullname"
        case userName = "username"
    }
}

//MARK: Combo Sale

struct BASmartComboSale: Codable {
    var state: Bool?
    var error_code: Int?
    var message: String?
    var data: BASmartComboSaleData?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error_code = "errorcode"
        case message = "message"
        case data = "data"
    }
}


struct BASmartComboSaleData: Codable {
    var common: [BASmartComboSaleDataDetail]?
    var owner: [BASmartComboSaleDataDetail]?
}

struct BASmartComboSaleDataDetail: Codable {
    var bcolor: String?
    var code: String?
    var description: String?
    var fcolor: String?
    var name: String?
    var objectid: Int?
}

struct BASmartComboSaleDetailModel: Codable {
    var state: Bool?
    var error_code: Int?
    var data: BASmartComboSaleDetailData?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error_code = "errorcode"
        case data = "data"
    }
}

struct BASmartComboSaleDetailData: Codable {
    var customer: BASmartComboSaleCustomerDetail?
    var common: [BASmartComboSaleCustomerCommon]?
    var option: [BASmartComboSaleCustomerCommon]?
    var system: [BASmartComboSaleModel]?
    var model: [BASmartComboSaleModel]?
    var vtype: [BASmartComboSaleModel]?
    var payment: [BASmartComboSalePayment]?
    var receiver: [BASmartComboSalePayment]?
    var deploy: [BASmartComboSaleModel]?
}

struct BASmartComboSaleCustomerDetail: Codable {
    var tax: String?
    var turcoeff: Int?
    
    enum CodingKeys: String, CodingKey {
        case tax = "taxoridn"
        case turcoeff = "turcoeff"
    }
}

struct BASmartComboSaleCustomerDetailParam: Codable {
    var tax: String?
    var turcoeff: Int?
    var liqDate: Int?
    var user: String?
    var pass: String
}

struct BASmartComboSaleCustomerCommon: Codable {
    var object: Int?
    var name: String?
    var norm: Int?
    var price: Int?
    var date: Int?
    var month: Int?
    var fix: Bool?
    var req: Bool?
    var order: Int?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case object = "objectid"
        case name = "name"
        case norm = "norm"
        case price = "price"
        case date = "date"
        case month = "month"
        case fix = "fixpr"
        case req = "reqdt"
        case order = "order"
        case count = "count"
    }
}

struct BASmartComboSaleFeatureModel: Codable {
    var state: Bool?
    var error_code: Int?
    var data: BASmartComboSaleFeatureData?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case error_code = "errorcode"
        case data = "data"
    }
}

struct BASmartComboSaleFeatureData: Codable {
    var system: [BASmartComboSaleModel]?
    var device: [BASmartComboSaleModel]?
}


struct BASmartComboSaleModel: Codable {
    var id: Int?
    var state: Bool?
    var name: String?
}

struct BASmartComboSalePayment: Codable {
    var id: Int?
    var state: Bool?
    var code: String?
    var name: String?
}

struct BASmartCreateOrderParam: Codable {
    var customerId: Int?
    var comboId: Int?
    var detail: [BASmartDetailOrder]?
    var vat: Bool?
    var exchange: Int?
    var systemId: Int?
    var modelId: Int?
    var vType: [BASmartVtype]?
    var feature: [BASmartVtype]?
    var paymentId: Int?
    var receiverId: Int?
    var deployId: Int?
    var customer: BASmartComboSaleCustomerDetailParam?
    var contactName: String?
    var contactPhone: String?
    var reportName: String?
    var reportPhone: String?
    var deployTime: Int?
    var address: String?
    var location: BASmartLocationParam?
    var content: String?
    var fileAttach: [BASmartImageAttach]?
    
    enum CodingKeys: String, CodingKey {
        case customerId = "customerid"
        case comboId = "comboid"
        case detail = "detail"
        case vat = "vatflag"
        case exchange = "exchange"
        case systemId = "systemid"
        case modelId = "modelid"
        case vType = "vtype"
        case feature = "feature"
        case paymentId = "paymentid"
        case receiverId = "receiverid"
        case deployId = "deployid"
        case customer = "customer"
        case contactName = "contactname"
        case contactPhone = "contactphone"
        case reportName = "reportname"
        case reportPhone = "reportphone"
        case deployTime = "deploytime"
        case address = "address"
        case location = "location"
        case content = "contentstr"
        case fileAttach = "fileattach"
    }
}

struct BASmartDetailOrder: Codable {
    var objectid: Int?
    var norm: Int?
    var price: Int?
    var month: Int?
    var date: Int?
}

struct BASmartVtype: Codable {
    var id: Int?
}

struct BASmartImageAttach: Codable {
    var imgdata: String?
}

struct BASmartPhoneNumber: Codable {
    var state: Bool?
    var error_code: Int?
    var message: String?
    var data: [BASmartPhoneNumberData]?
}

struct BASmartPhoneNumberData: Codable {
    var phone: String?
    
    enum CodingKeys: String, CodingKey {
        case phone = "phonenumber"
    }
}

struct BASmartUtilitySupport: Codable {
    var state: Bool?
    var error_code: Int?
    var message: String?
    var data: [BASmartUtilitySupportData]?
}

struct BASmartUtilitySupportData: Codable {
    var userName: String?
    var fullName: String?
    var mobile: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case fullName = "fullname"
        case mobile = "mobilestr"
    }
}
