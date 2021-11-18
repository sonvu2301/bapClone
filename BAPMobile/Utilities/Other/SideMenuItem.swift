//
//  SideMenuItem.swift
//  BAPMobile
//
//  Created by Emcee on 1/12/21.
//

import Foundation
import UIKit

enum SideMenuItem {
    case blank, main, customer_list, plan, call_data, statistical_report, move_schedule, reopen_request, end_day, back, form, customer_data, request_new, inventory
    var vc: UIViewController {
        switch self {
        case .main:
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartMainViewController") as! BASmartMainViewController
            return vc
        case .customer_list:
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerListViewController") as! BASmartCustomerListViewController
            return vc
        case .plan:
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartPlanViewController") as! BASmartPlanViewController
            return vc
        case .call_data:
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCallDataViewController") as! BASmartCallDataViewController
            return vc
        case .form:
            let vc = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartWarrantyListViewController") as! BASmartWarrantyListViewController
            return vc
        case .inventory:
            let vc = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartInventoryViewController") as! BASmartInventoryViewController
            return vc
        case .blank, .statistical_report, .move_schedule, .end_day, .back, .customer_data, .request_new:
            return UIViewController()
        case .reopen_request:
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartRequestOpenViewController") as! BASmartRequestOpenViewController
            return vc
        }
    }
}

class SideMenuItems: NSObject {
    static let shared = SideMenuItems()
    var items = [BASmartMenuList]()
    var list = [SideMenuItem]()
    
    //Add Side menu item from API
    func addSideMenuItems(items: [BASmartMenuList]) {
        self.items = items
    }
    
    //Get Side Menu data such as name and icon url
    func getSideMenuDatas() -> [BASmartMenuList] {
        return items
    }
    
    //Get Side Menu type
    func getSideMenuItems() -> [SideMenuItem] {
        list = [SideMenuItem]()
        items.forEach { [weak self] (item) in
            switch item.menuid {
            case 1:
                self?.list.append(.main)
            case 2:
                self?.list.append(.customer_list)
            case 3:
                self?.list.append(.plan)
            case 4:
                self?.list.append(.statistical_report)
            case 5:
                self?.list.append(.move_schedule)
            case 6:
                self?.list.append(.reopen_request)
            case 7:
                self?.list.append(.end_day)
            case 8:
                self?.list.append(.back)
            case 9:
                self?.list.append(.call_data)
            case 10:
                self?.list.append(.customer_data)
            case 33:
                self?.list.append(.form)
            case 40:
                self?.list.append(.request_new)
            case 65:
                self?.list.append(.inventory)
            default:
                self?.list.append(.blank)
            }
        }
        return list
    }
}


