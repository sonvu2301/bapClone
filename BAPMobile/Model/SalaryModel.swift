//
//  SalaryModel.swift
//  BAPMobile
//
//  Created by Emcee on 9/16/21.
//

import Foundation

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
    var radiusIn: Int?
    var radiusOut: Int?
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
    var beforeTax: Int?
    var taxEarning: Int?
    var reduceSafety: Int?
    var reduceOther: Int?
    var advance: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "taskid"
        case month = "monthindex"
        case beforeTax = "beforetax"
        case taxEarning = "taxearning"
        case reduceSafety = "reducesafety"
        case reduceOther = "reduceother"
        case advance = "sadvance"
    }
}


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
}


struct SalaryDefaultData: Codable {
    var name: String?
    var value: Int?
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
    var money: Int?
    var percent: Int?
    var salary: Int?
    var taxval: Int?
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
    var value: Int?
}
