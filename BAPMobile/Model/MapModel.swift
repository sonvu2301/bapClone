//
//  MapModel.swift
//  BAPMobile
//
//  Created by Emcee on 3/10/21.
//

import Foundation

struct MapLocation: Codable {
    var lng: Double
    var lat: Double
}

struct MapSearchParam: Codable {
    var keys: String
    var size: Int
    var distance: Int
    var location: MapLocation
}

struct MapModel: Codable {
    var error_code: Int?
    var state: Bool?
    var data: [MapData]?
    
    enum CodingKeys: String, CodingKey {
        case error_code = "errorcode"
        case state = "state"
        case data = "data"
    }
}

struct MapData: Codable {
    var address: String?
    var coords: [MapLocation]?
    var kind: String?
    var name: String?
    var search: String?
    var shape_id: Int?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case coords = "coords"
        case kind = "kindname"
        case name = "name"
        case search = "searchstr"
        case shape_id = "shapeid"
    }
}

struct MapSelectParam: Codable {
    var latstr: String
    var lngstr: String
}


struct MapCheckingParam: Codable {
    var location: MapLocation?
}
