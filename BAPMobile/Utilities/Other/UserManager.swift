//
//  UserManager.swift
//  BAPMobile
//
//  Created by Emcee on 12/16/20.
//

import Foundation

class UserManager: NSObject {
    static let shared = UserManager()
    
    var clientId = 0
    var reqable = false
    var pasable = false
    var sequence = 0
    var secret = ""
    
    func setClientReq(clientId: Int, reqable: Bool, pasable: Bool) {
        self.clientId = clientId
        self.reqable = reqable
        self.pasable = pasable
    }
    
    func setUtilities(seq: Int, sec: String) {
        sequence = seq
        secret = sec
    }
}


class UserInfo: NSObject {
    static let shared = UserInfo()
    var name = ""
    var branchName = ""
    var email = ""
    var userName = ""
    var mobile = ""
    
    func setUserInfo(name: String, branch: String, email: String, userName: String, mobile: String) {
        self.name = name
        self.branchName = branch
        self.email = email
        self.userName = userName
        self.mobile = mobile
    }
    
}

class DataParam: NSObject {
    static let shared = DataParam()
    var attSize = 0
    var ratio = 0
    var size = 0
    
    func setDataParam(attSize: Int, ratio: Int, size: Int) {
        self.attSize = attSize
        self.ratio = ratio
        self.size = size
    }
}
