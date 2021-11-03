//
//  NotificationModel.swift
//  BAPMobile
//
//  Created by Emcee on 12/17/20.
//

import Foundation

struct NotificationModel: Codable {
    var error_code: Int
    var message: String?
    var state: Bool
    var data: NotificationData
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}

struct NotificationData: Codable {
    var next_time: Int
    var notify_list: [NotifyList]
    var remain_flag: Bool
    
    enum CodingKeys: String, CodingKey {
        case next_time = "nexttimets"
        case notify_list = "notifylist"
        case remain_flag = "remainflag"
    }
}

struct NotifyList: Codable {
    var data_str: String
    var time_unix: Int
    var title_str: String
    
    enum CodingKeys: String, CodingKey {
        case data_str = "datastr"
        case time_unix = "timeunix"
        case title_str = "titlestr"
    }
}
