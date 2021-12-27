//
//  BasicModel.swift
//  BAPMobile
//
//  Created by Emcee on 12/23/20.
//

import Foundation

struct BasicModel: Codable {
    var errorCode: Int?
    var message: String?
    var state: Bool?
    var data: String?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
        case message = "message"
        case state = "state"
        case data = "data"
    }
}
