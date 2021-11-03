//
//  GetPhoneModel.swift
//  BAPMobile
//
//  Created by Emcee on 5/21/21.
//

import Foundation


// Get Phone
enum GetPhoneKind {
    case basmartDefault, search, plan, human
    
    var kindId: Int {
        switch self {
        case .basmartDefault:
            return 1
        case .search:
            return 4
        case .plan:
            return 6
        case .human:
            return 2
        }
    }
}

// Model Type
enum BASmartCustomerType {
    case BA, competitor, both, not_yet
    
    var id : Int {
        switch self {
        case .BA:
            return 1
        case .competitor:
            return 2
        case .both:
            return 3
        case .not_yet:
            return 4
        }
    }
}

//BASmart Model Type
enum BASmartCustomerKindType {
    case enterprise, coop, personal
    
    var id: Int {
        switch self {
        case .enterprise:
            return 8
        case .coop:
            return 16
        case .personal:
            return 24
        }
    }
}


//BASmart Plan Menu Action
enum BASmartPlanMenuAction {
    case signin_approach, update, receive, abort, approach_result, customer_info
    
    var id: Int {
        switch self {
        case .signin_approach:
            return 1
        case .update:
            return 2
        case .receive:
            return 3
        case .abort:
            return 8
        case .approach_result:
            return 32
        case .customer_info:
            return 64
        }
    }
    
    var name: String {
        switch self {
        case .signin_approach:
            return "Vào điểm tiếp xúc"
        case .update:
            return "Cập nhật kế hoạch"
        case .receive:
            return "Ghi nhận kết quả"
        case .abort:
            return "Huỷ kế hoạch"
        case .approach_result:
            return "Kết quả tiếp xúc"
        case .customer_info:
            return "Thông tin khách hàng"
        }
    }
}


//BASmart Customer Group
enum BASmartCustomerGroup {
    case potential, old
    
    var id: Int {
        switch self {
        case .potential:
            return 1
        case .old:
            return 2
        }
    }
}

enum BASmartMenuAction {
    case edit, delete, checkin, create, tb, ba, photoList, history, diary, tranfer, none
    
    var id: Int {
        switch self {
        case .none:
            return 0
        case .edit:
            return 2
        case .delete:
            return 8
        case .checkin:
            return 65
        case .create:
            return 66
        case .tb:
            return 97
        case .ba:
            return 98
        case .photoList:
            return 129
        case .history:
            return 130
        case .diary:
            return 131
        case .tranfer:
            return 67
        }
    }
}

enum BASmartKindId {
    case customer, detailCustomer, plan, byPhone, timeline
    
    var id: Int {
        switch self {
        case .customer:
            return 1
        case .plan:
            return 6
        case .detailCustomer:
            return 2
        case .byPhone:
            return 4
        case .timeline:
            return 3
        }
    }
}

enum BASmartSellKindId {
    case BA, TB
    
    var id: Int {
        switch self {
        case .BA:
            return 2
        case .TB:
            return 1
        }
    }
}

enum BASmartPlanKind {
    case customer, plan
    
    var id: Int {
        switch self {
        case .customer:
            return 2
        case .plan:
            return 3
        }
    }
}

enum BASmartVehicleActionKind {
    case note, search
    
    var id: Int{
        switch self {
        case .note:
            return 1
        case .search:
            return 2
        }
    }
}

enum TimeZone {
    case vn
    
    var number: Int {
        switch self {
        case .vn:
            return 25200
        }
    }
}

enum VehiclePhotolistFrom {
    case search, warranty
    
    var kindId: Int {
        switch self {
        case .search:
            return 1
        case .warranty:
            return 2
        }
    }
}
