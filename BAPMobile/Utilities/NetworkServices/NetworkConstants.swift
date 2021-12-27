//
//  NetworkConstants.swift
//  BAPMobile
//
//  Created by Emcee on 12/16/20.
//

import Foundation

struct NetworkConstants {
    //MARK: BAP Base Url
    static var baseURL: String {
        return "http://bapm.api.binhanh.vn:21600/"
    }
    
    static var baseStockURL: String {
        return "http://bapm.api.binhanh.vn:21602/"
    }
    
    static var baseInstallMngURL: String {
        return "http://bapm.api.binhanh.vn:21603/"
    }
    
    static var baseWarrantyURL: String {
        return "http://bapm.api.binhanh.vn:21605/"
    }
    
    static var baseChargeMngURL: String {
        return "http://bapm.test.binhanh.vn:21609/"
    }
    
    static var baseMarketingMngURL: String {
        return "http://bapm.test.binhanh.vn:21614/"
    }

    static var baseTestURL: String {
        return "http://bapm.test.binhanh.vn:21600/"
    }
    
    static var baseTestStockURL: String {
        return "http://bapm.test.binhanh.vn:21602/"
    }
    
    static var baseTestInstallMngURL: String {
        return "http://bapm.test.binhanh.vn:21603/"
    }
    
    static var baseTestWarrantyURL: String {
        return "http://bapm.test.binhanh.vn:21605/"
    }
    
    static var baseTestChargeMngURL: String {
        return "http://bapm.test.binhanh.vn:21609/"
    }
    
    static var baseTestBASmartMngURL: String {
        return "http://bapm.test.binhanh.vn:21614/"
    }
    
    static var baseHrmURL: String {
        return "http://bapm.test.binhanh.vn:21601/"
    }
    
    static var clientReg: String {
        return baseTestURL + "ClientReg"
    }
    
    static var login: String {
        return baseTestURL + "LoginSys"
    }
    
    static var logout: String {
        return baseTestURL + "LogoutSys"
    }
    
    static var notification: String {
        return baseTestURL + "NotifyGet"
    }
    
    static var customer_list: String {
        return baseTestChargeMngURL + "guarantee/task/list"
    }
    
    static var customer_list_car: String {
        return baseTestChargeMngURL + "guarantee/task/detail"
    }
    
    static var create_vgs_task: String {
        return baseTestChargeMngURL + "guarantee/task/create"
    }
    
    
    //MARK: BASMart

    static var get_main_process_home: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/home"
    }
    
    static var basmart_checking_action: String {
        return baseTestBASmartMngURL + "basmart/timekepping/action"
    }
    
    static var basmart_checking: String {
        return baseTestBASmartMngURL + "basmart/timekepping/check"
    }
    
    static var basmart_request_reopen: String {
        return baseTestBASmartMngURL + "basmart/timekepping/open/request"
    }
    
    static var basmart_request_reopen_confirm: String {
        return baseTestBASmartMngURL + "basmart/timekepping/open/confirm"
    }
    
    static var basmart_dailyworking_photo: String {
        return baseTestBASmartMngURL + "basmart/dailyworking/photo"
    }
    
    static var basmart_dailyworking_quick: String {
        return baseTestBASmartMngURL + "basmart/dailyworking/quick"
    }
    
    static var basmart_dailyworking_checkin: String {
        return baseTestBASmartMngURL + "basmart/dailyworking/checkin"
    }
    
    static var basmart_dailyworking_checkout: String {
        return baseTestBASmartMngURL + "basmart/dailyworking/checkout"
    }
    
    static var basmart_customer_dailyworking_checkin: String {
        return baseTestBASmartMngURL + "basmart/dailyworking/quick"
    }
    
    static var basmart_get_customer_list: String {
        return baseTestBASmartMngURL + "basmart/customer/list"
    }
    
    static var basmart_delete_customer: String {
        return baseTestBASmartMngURL + "basmart/customer/delete"
    }
    
    static var basmart_update_customer: String {
        return baseTestBASmartMngURL + "basmart/customer/update"
    }
    
    static var basmart_authen_customer: String {
        return baseTestBASmartMngURL + "basmart/customer/authen"
    }
    
    static var basmart_create_customer: String {
        return baseTestBASmartMngURL + "basmart/customer/create"
    }
    
    static var basmart_get_customer_catalog: String {
        return baseTestBASmartMngURL + "basmart/customer/catalog"
    }
    
    static var basmart_get_customer_detail: String {
        return baseTestBASmartMngURL + "basmart/customer/detail"
    }
    
    static var basmart_get_customer_timeline: String {
        return baseTestBASmartMngURL + "basmart/customer/timeline"
    }
    
    static var basmart_get_customer_diary: String {
        return baseTestBASmartMngURL + "basmart/customer/diary"
    }
    
    static var basmart_get_customer_gallery: String {
        return baseTestBASmartMngURL + "basmart/customer/gallery"
    }
    
    static var basmart_transfer_customer: String {
        return baseTestBASmartMngURL + "basmart/customer/transfer"
    }
    
    static var basmart_add_human: String {
        return baseTestBASmartMngURL + "basmart/customer/human/create"
    }
    
    static var basmart_edit_human: String {
        return baseTestBASmartMngURL + "basmart/customer/human/update"
    }
    
    static var basmart_delete_human: String {
        return baseTestBASmartMngURL + "basmart/customer/human/delete"
    }
    
    static var basmart_add_competitor: String {
        return baseTestBASmartMngURL + "basmart/customer/competitor/create"
    }
    
    static var basmart_edit_competitor: String {
        return baseTestBASmartMngURL + "basmart/customer/competitor/update"
    }

    static var basmart_delete_competitor: String {
        return baseTestBASmartMngURL + "basmart/customer/competitor/delete"
    }
    
    static var basmart_approach_delete: String {
        return baseTestBASmartMngURL + "basmart/customer/approach/delete"
    }
    
    static var basmart_approach_create: String {
        return baseTestBASmartMngURL + "basmart/customer/approach/create"
    }
    
    static var basmart_result_approach: String {
        return baseTestBASmartMngURL + "basmart/customer/approach/byplan"
    }
    
    static var basmart_plan_list: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/plan/list"
    }
    
    static var basmart_plan_checkin_list: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/plan/checkin"
    }
    
    static var basmart_plan_create: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/plan/create"
    }
    
    static var basmart_plan_update: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/plan/update"
    }
    
    static var basmart_plan_delete: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/plan/delete"
    }
    
    static var basmart_get_phone_number: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/phone/info"
    }
    
    static var basmart_approach: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/approach/update"
    }
    
    static var basmart_plan_search_customer: String {
        return baseTestBASmartMngURL + "basmart/customer/utility/forplan"
    }
    
    static var basmart_customer_search_byphone: String {
        return baseTestBASmartMngURL + "basmart/customer/utility/byphone"
    }
    
    static var basmart_datautility_support: String {
        return baseTestBASmartMngURL + "basmart/datautility/support"
    }
    
    static var basmart_call_list: String {
        return baseTestBASmartMngURL + "basmart/mainprocess/call/list"
    }
    
    static var basmart_reopen_request_list: String {
        return baseTestBASmartMngURL + "basmart/timekepping/open/list"
    }
    
    static var basmart_combosale_list: String {
        return baseTestInstallMngURL + "catalog/combosale/list"
    }
    
    static var basmart_combosale_detail: String {
        return baseTestInstallMngURL + "catalog/combosale/detail"
    }
    
    static var basmart_combosale_feature: String {
        return baseTestInstallMngURL + "catalog/combosale/feature"
    }
    
    static var basmart_combosale_create_order: String {
        return baseTestInstallMngURL + "task/install/create/bacam"
    }
    
    static var basmart_list_seller: String {
        return baseTestBASmartMngURL + "basmart/datautility/seller"
    }
    
    //MARK: Warranty
    static var basmart_technical_task_list: String {
        return baseTestBASmartMngURL + "basmart/technical/task/manager"
    }
    
    static var basmart_technical_task_detail: String {
        return baseTestBASmartMngURL + "basmart/technical/task/detail"
    }
    
    static var basmart_technical_vehicle_list: String {
        return baseTestBASmartMngURL + "basmart/technical/task/vehicle/list"
    }
    
    static var basmart_technical_vehicle_search: String {
        return baseTestBASmartMngURL + "basmart/technical/task/vehicle/search"
    }
    
    static var basmart_technical_vehicle_action: String {
        return baseTestBASmartMngURL + "basmart/technical/task/vehicle/action"
    }
    
    static var basmart_technical_upload_attach: String {
        return baseTestBASmartMngURL + "basmart/technical/task/gallery/attach"
    }
    
    static var basmart_technical_remove_attach: String {
        return baseTestBASmartMngURL + "basmart/technical/task/gallery/abort"
    }
    
    static var basmart_technical_transfer: String {
        return baseTestBASmartMngURL + "basmart/technical/task/transfer"
    }
    
    //MARK: Inventory
    static var basmart_inventory_list: String {
        return baseTestStockURL + "report/stock/inventory/list"
    }
    
    static var basmart_inventory_detail: String {
        return baseTestStockURL + "report/stock/inventory/detail"
    }
    
    static var basmart_inventory_state: String {
        return baseTestStockURL + "report/stock/inventory/state"
    }
    
    //MARK: Ware House
    static var basmart_warehouse_customer_list: String {
        return baseTestBASmartMngURL + "basmart/warehouse/customer/list"
    }
    
    static var basmart_warehouse_add_customer: String {
        return baseTestBASmartMngURL + "basmart/warehouse/customer/create"
    }
    
    static var basmart_warehouse_customer_catalog: String {
        return baseTestBASmartMngURL + "basmart/warehouse/customer/catalog"
    }
 
    
    //MARK: Vehicle Infomation
    
    static var vehicle_search: String {
        return baseTestChargeMngURL + "chargeobject/vehicle/search"
    }
    
    static var vehicle_detailt_info: String {
        return baseTestChargeMngURL + "chargeobject/vehicle/detail"
    }
    
    static var vehicle_gallery_list: String {
        return baseTestChargeMngURL + "chargeobject/vehicle/gallery/list"
    }
    
    static var vehicle_add_new_photo: String {
        return baseTestChargeMngURL + "chargeobject/vehicle/gallery/photo"
    }
    
    static var vehicle_delete_photo: String {
        return baseTestChargeMngURL + "chargeobject/vehicle/gallery/abort"
    }
    
    //MARK: Map
    
    static var baseMapUrl: String {
        return "http://maps.geocode.laocai.bagroup.vn:5600/"
    }
    
    static var map_search: String {
        return baseMapUrl + "Search"
    }
    
    static var map_select: String {
        return baseMapUrl + "Geo2Add"
    }
    
    //MARK: Salary
    static var salary_info: String {
        return baseTestChargeMngURL + "SMTTaskGet"
    }
    
    static var salary_detail: String {
        return baseTestChargeMngURL + "SMTDetailGet"
    }
    
    
    //MARK: General Info
    static var contact_list: String {
        return baseHrmURL + "EPLContactGet"
    }
}


