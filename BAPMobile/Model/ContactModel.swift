//
//  ContactModel.swift
//  BAPMobile
//
//  Created by Emcee on 8/27/21.
//

import Foundation

struct GeneralContactList: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: [GeneralContactListData]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct GeneralContactListData: Codable {
    var branch: ContactBranch?
    var items: [ContactItem]?
}

struct ContactBranch: Codable {
    var code: String?
    var name: String?
}

struct ContactItem: Codable {
    var online: Bool?
    var avata: String?
    var department: String?
    var fullname: String?
    var position: String?
    var email: String?
    var mobile: String?
}
