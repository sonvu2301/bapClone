//
//  LoginModel.swift
//  BAPMobile
//
//  Created by Emcee on 12/16/20.
//

import Foundation

struct LoginParam: Codable {
    var user: String?
    var pass: String?
    
    enum CodingKeys: String, CodingKey {
        case user = "username"
        case pass = "password"
    }
}

struct LoginModel: Codable {
    var error_code: Int
    var message: String?
    var state: Bool
    var data: LoginData
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct LoginData: Codable {
    var comunicate: Comunicate?
    var header: [LoginHeader]
    var menu_list: [MenuList]
    var partner_current: PartnerCurrent
    var partner_list: [PartnerList]
    var users: User
    var utility: Utility
    var param: ParamData
    
    enum CodingKeys: String, CodingKey {
        case menu_list = "menulist"
        case partner_current = "partnercurrent"
        case partner_list = "partnerlist"
        case comunicate = "comunicate"
        case header = "header"
        case users = "users"
        case utility = "utility"
        case param = "paramdata"
    }
}

struct Comunicate: Codable {
    var src: String
    var url: String
    var opt: Int
}

struct LoginHeader: Codable {
    var src: String
}

struct User: Codable {
    var brance_name: String
    var department_name: String
    var email: String
    var full_name: String
    var mobile: String
    var public_flag: Bool
    var user_name: String
    
    enum CodingKeys: String, CodingKey {
        case brance_name = "branchname"
        case department_name = "departmentname"
        case email = "email"
        case full_name = "fullname"
        case mobile = "mobile"
        case public_flag = "publicflag"
        case user_name = "username"
    }
}

struct Utility: Codable {
    var security: String
    var sequence: Int
}


struct MenuList: Codable {
    var description: String
    var menuid: Int
    var name: String
    var record: Int
}


struct PartnerCurrent: Codable {
    var code: String
    var name: String
}


struct PartnerList: Codable {
    var code: String
    var name: String
}

struct ParamData: Codable {
    var attsize: Int?
    var imgratio: Int?
    var imgsize: Int?
}


struct ClientRegisterModel: Codable {
    var error_code: Int
    var message: String?
    var state: Bool
    var data: ClientRegisterData
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct ClientRegisterData: Codable {
    var clientid: Int
    var regable: Bool
    var pasable: Bool
}
