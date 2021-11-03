//
//  BasicModel.swift
//  BAPMobile
//
//  Created by Emcee on 12/23/20.
//

import Foundation

struct BasicModel: Codable {
    var error_code: Int?
    var message: String?
    var state: Bool?
    var data: String?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}
