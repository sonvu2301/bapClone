//
//  SalaryModel.swift
//  BAPMobile
//
//  Created by Emcee on 9/16/21.
//

import Foundation

// =============Lương tháng=====================
struct SalaryModel: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: SalaryModelData?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}


struct SalaryModelData: Codable {
    var image: String?
    var radiusIn: Decimal?
    var radiusOut: Decimal?
    var colors: [String]?
    var items: [SalaryModelItem]?

    
    enum CodingKeys: String, CodingKey {
        case image = "bgimage"
        case radiusIn = "radiusin"
        case radiusOut = "radiusout"
        case colors = "colors"
        case items = "items"
    }
}

struct SalaryModelItem: Codable {
    var id: Int?
    var month: Int?
    var salaryTotal: Decimal?
    var taxEarning: Decimal?
    var reduceSafety: Decimal?
    var reduceOther: Decimal?
    var advance: Decimal?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "taskid"
        case month = "monthindex"
        case salaryTotal = "salarytotal"
        case taxEarning = "taxearning"
        case reduceSafety = "reducesafety"
        case reduceOther = "reduceother"
        case advance = "advance"
    }
}
//================================================

//============ Chi tiết lương tháng===============
struct SalaryDetailModel: Codable {
    var error_code: Int?
    var state: Bool?
    var data: SalaryDetailData?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case state = "state"
        case data = "data"
    }
}


struct SalaryDetailData: Codable {
    var timeKeeping: [SalaryDefaultData]?
    var earnIncome: [SalaryDefaultData]?
    var taxEarning: SalaryDetailTax?
    var safety: SalaryDetailSafety?
    var reduce: [SalaryDefaultData]?
    
    enum CodingKeys: String, CodingKey {
        case timeKeeping = "timekeeping"
        case earnIncome = "earnincome"
        case taxEarning = "taxearning"
        case safety = "safetyinfo"
        case reduce = "reducetotal"
    }
    
}


struct SalaryDefaultData: Codable {
    var id: Int?
    var name: String?
    var value: Decimal?
}

struct SalaryState: Codable {
    var state: Bool?
}

struct SalaryDetailTax: Codable {
    var flag: SalaryState?
    var money: SalaryDefaultData?
    var items: [SalaryDetailTaxItems]?
    
    enum CodingKeys: String, CodingKey {
        case flag = "dataflag"
        case money = "moneytax"
        case items = "items"
    }
}

struct SalaryDetailTaxItems: Codable {
    var color: String?
    var money: Decimal?
    var percent: Decimal?
    var salary: Decimal?
    var taxval: Decimal?
}

struct SalaryDetailSafety: Codable {
    var flag: SalaryState?
    var items: [SalaryDetailSaftyItems]?

    enum CodingKeys: String, CodingKey {
        case flag = "dataflag"
        case items = "items"
    }
}

struct SalaryDetailSaftyItems: Codable {
    var id: Int?
    var color: String?
    var label: String?
    var name: String?
    var value: Decimal?
}

//================ Lương tạm ứng =================
struct SalarySadModel: Codable {
    var error_code: Int?
    var state: Bool?
    var data: SalarySadData?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case state = "state"
        case data = "data"
    }
}
struct SalarySadData: Codable {
    var bgimage: String?
    var items: [SalarySadItem]?
    
    enum CodingKeys: String, CodingKey {
        case bgimage = "bgimage"
        case items = "items"
    }
    
}
struct SalarySadItem: Codable {
    var advance: Decimal?
    var imageSrc: String?
    var moneyOther: Decimal?
    var monthIndex: Int?
    var otherList: [SalarySadOtherItem]?
    var percent: Decimal?
    var salaryBasic: Decimal?
    var taskId: Int?
    
    enum CodingKeys: String, CodingKey{
        case advance = "advance"
        case imageSrc = "imagesrc"
        case moneyOther = "moneyother"
        case monthIndex = "monthindex"
        case otherList = "otherlist"
        case percent = "percent"
        case salaryBasic = "salarybasic"
        case taskId = "taskid"
    }
    
}
struct SalarySadOtherItem: Codable {
    var id: Int?
    var name: String?
    var value: Decimal?
}
//================================================

//================ DS Chấm công =================
struct TimekeepingModel: Codable {
    var error_code: Int?
    var state: Bool?
    var data: TimeKeepingData?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case state = "state"
        case data = "data"
    }
}
struct TimeKeepingData: Codable{
    var create: Bool?
    var taskList: [TimeKeepingItem]?
    
    enum CodingKeys: String, CodingKey {
        case create = "create"
        case taskList = "tasklist"
    }
}
struct TimeKeepingItem: Codable{
    var taskId: Int?
    var monthIndex: Int?
    var colorStr: String?
    var quoteStr: String?
    var imageSrc: String?
    var workdays: Decimal?
    var vacation: Decimal?
    var restpaid: Decimal?
    var unpaid: Decimal?
    var remained: Decimal?
    var others: Decimal?
    var eating: UInt8?
    var budget: UInt8?
     
    enum CodingKeys: String, CodingKey{
        case taskId = "taskid"
        case monthIndex = "monthindex"
        case colorStr = "colorstr"
        case quoteStr = "quotestr"
        case imageSrc = "imagesrc"
        case workdays = "workdays"
        case vacation = "vacation"
        case restpaid = "restpaid"
        case unpaid = "unpaid"
        case remained = "remained"
        case others = "others"
        case eating = "eating"
        case budget = "budget"
        
    }
}
// catalog
struct KeepingCatalogModel: Codable{
    var error_code: Int?
    var state: Bool?
    var data: KeepingCatalogData?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case state = "state"
        case data = "data"
    }
}
struct KeepingCatalogData: Codable{
    var cstateList: [Catalog]?
    var wstateList: [Catalog]?
    var dskindList: [Catalog]?
    var actionList: [Catalog]?
    
    enum CodingKeys: String, CodingKey{
        case cstateList = "cstatelist"
        case wstateList = "wstatelist"
        case dskindList = "dskindlist"
        case actionList = "actionlist"
        
    }
}
//================================================
