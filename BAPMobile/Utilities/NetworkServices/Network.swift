//
//  Network.swift
//  BAPMobile
//
//  Created by Emcee on 12/8/20.
//

import Foundation
import Alamofire
import Toaster
import UIKit


class Network: NSObject {
    static let shared = Network()
    let key = "123456789012345678901234"
    let keyMap = "kikgKfi1Md0uKgCJ42P7r8aI"
    let encoder = JSONParameterEncoder.default
    
    
    //MARK: Login request
    func clientReq(completion: @escaping(Bool) -> Void) {
        let param = ["ostype": "2",
                     "osversion": "13.0",
                     "imeinumber": "351234567890123",
                     "dataext": "1",
                     "machine": "SonVN"]
        let headers: HTTPHeaders = ["keys": key]
        AF.request(NetworkConstants.clientReg, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(false)
                    return
                }
                
                let data = try JSONDecoder().decode(ClientRegisterModel.self, from: json)
                UserManager.shared.setClientReq(clientId: data.data.clientid, reqable: data.data.regable, pasable: data.data.pasable)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(true)
            } catch {
                print(error)
                completion(false)
            }
        }
    }

    
    func login(param: LoginParam, completion: @escaping(LoginModel?) -> Void) {
        let headers: HTTPHeaders = ["keys": key,
                                    "clientid": "\(UserManager.shared.clientId)"]
        
        AF.request(NetworkConstants.login, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }   
                let data = try JSONDecoder().decode(LoginModel.self, from: json)
                UserManager.shared.setUtilities(seq: data.data.utility.sequence, sec: data.data.utility.security)
                let userInfo = data.data.users
                UserInfo.shared.setUserInfo(name: userInfo.full_name,
                                            branch: userInfo.brance_name,
                                            email: userInfo.email,
                                            userName: userInfo.user_name,
                                            mobile: userInfo.mobile)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func logout(completion: @escaping(BasicModel?) -> Void) {
        let param = [""]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.logout, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    
    func getNotification(time: Int, completion: @escaping (NotificationModel?) -> Void) {
        let param = ["lasttimets": "\(time)"]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.notification, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(NotificationModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    
    func getCustomerList(key: String, completion: @escaping (CustomerModel?) -> Void) {
        let param = ["searchs": key]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.customer_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(CustomerModel.self, from: json)
                if data.error_code != 0{
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func getCustomerListCar(obj_id: Int, completion: @escaping (CustomerCarModel?) -> Void) {
        let param = ["taskid": "\(obj_id)"]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.customer_list_car, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(CustomerCarModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func createVGSTask(day: Int, vehicleIds: [Int], completion: @escaping (BasicModel?) -> Void) {
        //Body
        var vehicles = [VehicleId]()
        vehicleIds.forEach { (item) in
            vehicles.append(VehicleId(vehicleid: item))
        }
        let param = VGSTastCreateParam(guarantee: day, data: vehicles)
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.create_vgs_task, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
}

//MARK: BASmart
extension Network {
    func BASmartGetMainProcessHome(completion: @escaping (BASmartData?) -> Void) {
        let param = [""]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.get_main_process_home, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartTimeChecking(state: Int, lat: Double, long: Double, opt: Int, completion: @escaping (BASmartCheckinAction?) -> Void) {
        let headers = self.getHeaders()
        let a = 105.21235413
        let b = 21.21453697
        let locationParam = BASmartLocationParam(lng: a, lat: b, opt: opt)
        let param = BASmartCheckingParam(state: state, location: locationParam)
        
        AF.request(NetworkConstants.basmart_checking_action, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCheckinAction.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartCheckout(lat: Double, long: Double, opt: Int, completion: @escaping (BASmartCheckoutModel?) -> Void) {
        let headers = self.getHeaders()
        let a = 105.21235413
        let b = 21.21453697
        let locationParam = BASmartLocationParam(lng: a, lat: b, opt: opt)
        let param = BASmartCheckingParam(state: 7, location: locationParam)
        
        AF.request(NetworkConstants.basmart_checking_action, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCheckoutModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartTimeKeepingCheck(completion: @escaping (BASmartCheckin?) -> Void) {
        let param = [""]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_checking, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCheckin.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartRequestReopen(param: BASmartRequestReopenParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_request_reopen, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartRequestReopenConfirm(param: BASmartRequestReopenConfirmParam, id: Int, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_request_reopen_confirm, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDailyWorkingPhoto(param: BASmartDailyWorkingParam, completion: @escaping (BASmartCheckin?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_checking, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCheckin.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    //MARK: Customer
    func BASmartGetCustomerList(group_id: Int,completion: @escaping ([BASmartCustomerListData]?) -> Void) {
        let param = ["groupid": group_id]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_get_customer_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCustomerList.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDeleteCustomer(objectId: Int,completion: @escaping (BasicModel?) -> Void) {
        let param = ["objectid": objectId]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_delete_customer, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartUpdateCustomer(param: BASmartCustomerUpdateParam,completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_update_customer, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartTransferCustomer(id: Int, seller: String, completion: @escaping (BasicModel?) -> Void) {
        let param = ["objectid": "\(id)",
                     "sellerstr": seller]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_transfer_customer, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartAuthenCustomer(id: Int, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        let param = ["id": id]
        
        AF.request(NetworkConstants.basmart_authen_customer, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartUpdateApproach(param: BASmartApproachParam,completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_approach , method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDeleteApproach(customerId: Int, objectId: Int, completion: @escaping (BasicModel?) -> Void) {
        let param = ["customerid": "\(customerId)",
                     "objectid": "\(objectId)"]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_approach_delete , method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartCreateApproach(param: BASmartCustomerCreateApproachParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_approach_create , method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartGetCustomerCatalog(completion: @escaping (BASmartCustomerCatalogData?) -> Void) {
        let param = [""]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_get_customer_catalog, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCustomerCatalog.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartGetCustomerDetail(objectId: Int, kindId: Int, completion: @escaping (BASmartCustomerDetailData?) -> Void) {
        let param = ["objectid": objectId,
                     "kindid": kindId]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_get_customer_detail, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCustomerDetail.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartGetCustomerTimeline(objectId: Int,completion: @escaping ([BASmartCustomerTimelineData]?) -> Void) {
        let param = ["objectid": objectId]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_get_customer_timeline, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCustomerTimeline.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartAddCustomerTimeline(param: BASmartCustomerDiary, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_get_customer_diary, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    
    func BASmartGetCustomerGallery(objectId: Int, kindView: Int, completion: @escaping ([BASmartCustomerGalleryData]?) -> Void) {
        let param = ["objectid": objectId,
                     "viewkind": kindView]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_get_customer_gallery, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCustomerGallery.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartAddCustomer(param: BASmartAddCustomertParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_create_customer, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartAddHuman(param: BASmartAddHumanParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_add_human, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartEditHuman(param: BASmartEditHumanParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_edit_human, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDeleteHuman(customerId: Int, objectId: Int, completion: @escaping (BasicModel?) -> Void) {
        let param = ["customerid": customerId,
                     "objectid": objectId]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_delete_human, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartAddCompetitor(param: BASmartAddCompetitorParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_add_competitor, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartEditCompetitor(param: BASmartEditCompetitorParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_edit_competitor, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDeleteCompetitor(customerId: Int, objectId: Int, completion: @escaping (BasicModel?) -> Void) {
        let param = ["customerid": customerId,
                     "objectid": objectId]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_delete_competitor, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartGetPhoneNumber(kindId: Int, objectId: Int, completion: @escaping ([BASmartPhoneNumberData]?) -> Void) {
        let param = ["kindid": kindId,
                     "objectid": objectId]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_get_phone_number, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartPhoneNumber.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDailyWorkingCheckin(param: BASmartDailyWorkingCheckinParam, completion: @escaping (BasicModel?) -> Void) {
        
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_dailyworking_checkin, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDailyWorkingCheckout(param: BASmartDailyWorkingCheckoutParam, completion: @escaping (BasicModel?) -> Void) {
        
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_dailyworking_checkout, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartCustomerDailyWorkingCheckin(param: BASmartCustomerCheckinParam, completion: @escaping (BasicModel?) -> Void) {
        
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_customer_dailyworking_checkin, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    
    //MARK: Combo
    func BASmartComboSaleList(partner: String, kind: Int, completion: @escaping (BASmartComboSaleData?) -> Void) {
        let param = ["partnercode": partner,
                     "kindid": String(kind)]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_combosale_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartComboSale.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data ?? BASmartComboSaleData())
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartComboSaleDetail(customer: Int, combo: Int, completion: @escaping (BASmartComboSaleDetailData?) -> Void) {
        let param = ["customerid": String(customer),
                     "comboid": String(combo)]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_combosale_detail, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartComboSaleDetailModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: String(data.error_code ?? 0), duration: Delay.long).show()
                }
                completion(data.data ?? BASmartComboSaleDetailData())
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartComboSaleFeature(model: Int, completion: @escaping (BASmartComboSaleFeatureData?) -> Void) {
        let param = ["modelid": model]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_combosale_feature, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartComboSaleFeatureModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: String(data.error_code ?? 1), duration: Delay.long).show()
                }
                completion(data.data ?? BASmartComboSaleFeatureData())
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartCreateOrder(param: BASmartCreateOrderParam, completion: @escaping (Bool) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_combosale_create_order, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(false)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.state ?? false)
            } catch {
                print(error)
                completion(false)
            }
        }
    }
    
    
    //MARK: Plan
    func BASmartPlanList(day: Int, completion: @escaping ([BASmartPlanListData]?) -> Void) {
        let param = ["dayindex": day]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_plan_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartPlanListModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartPlanCheckinList(param: MapCheckingParam, completion: @escaping ([BASmartPlanListCheckinData]?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_plan_checkin_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartPlanListCheckinModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartCreatePlan(param: BASmartCreatePlanParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_plan_create, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartUpdatePlan(param: BASmartUpdatePlanParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_plan_update, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDeletePlan(objectId: Int, completion: @escaping (BasicModel?) -> Void) {
        let param = ["objectid": objectId]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_delete_human, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartReopenRequestList(completion: @escaping ([BASmartReopenRequestData]?) -> Void) {
        let param = [""]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_reopen_request_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartReopenRequestModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartPlanResultApproach(planId: Int, completion: @escaping (BASmartApproachResult?) -> Void) {
        let param = ["planid": planId]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_result_approach, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartApproachResult.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartPlanSearchCustomer(param: BASmartPlanSearchCustomerParam, completion: @escaping ([BASmartCustomerListData]?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_plan_search_customer, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCustomerList.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartCustomerSearchByPhone(phone: String, completion: @escaping (BASmartCustomerList?) -> Void) {
        
        let param = ["phonestr": phone]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_customer_search_byphone, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCustomerList.self, from: json)
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartGetSupport(search: String, completion: @escaping (BASmartUtilitySupport?) -> Void) {
        
        let param = ["searchstr": search]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_datautility_support, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartUtilitySupport.self, from: json)
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartGetSeller(search: String, completion: @escaping (BASmartUtilitySupport?) -> Void) {
        
        let param = ["searchstr": search]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_list_seller, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartUtilitySupport.self, from: json)
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    //MARK: Call data
    func BASmartCallList(day: Int, completion: @escaping ([BASmartCallData]?) -> Void) {
        let param = ["dayindex": day]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_call_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartCallListModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    
    
    //MARK: Technical
    func BASmartTechnicalListTask(param: BASmartLocationParam, completion: @escaping (BASmartTechnicalTask?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_task_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartTechnicalTask.self, from: json)
                if data.errorcode != 0 && data.errorcode != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartTechnicalTaskDetail(param: BASmartTechnicalDetailTaskParam, completion: @escaping (BASmartTechnicalDetailTask?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_task_detail, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartTechnicalDetailTask.self, from: json)
                if data.errorcode != 0 && data.errorcode != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartTechnicalVehicleList(id: Int, completion: @escaping (BASmartVehicleList?) -> Void) {
        let param = ["taskid": id]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_vehicle_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartVehicleList.self, from: json)
                if data.error != 0 && data.error != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartTechnicalVehicleSearch(param: BASmartVehicleSearchParam, completion: @escaping (BASmartVehicleList?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_vehicle_search, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartVehicleList.self, from: json)
                if data.error != 0 && data.error != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartTechnicalVehicleAction(param: BASmartTechnicalVehicleActionParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_vehicle_action, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartUploadFileAttach(param: BASmartUploadAttachParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_upload_attach, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func BASmartDeleteFileAttach(param: BASmartDeleteAttachParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_remove_attach, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }

    func BASmartTechnicalTransfer(param: BASmartTechnicalTransferParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_transfer, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    
    //MARK: Inventory
    func BASmartGetInventoryList(date: Int, completion: @escaping (BASmartInventoryList?) -> Void) {
        
        let param = ["dateindex": "\(date)"]
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_inventory_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartInventoryList.self, from: json)
                if data.errorCode != 0 && data.errorCode != nil {
                    Toast(text: "\(data.errorCode ?? 0)", duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
}


//MARK: Vehicle
extension Network {
    
    func VehicleSearch(param: BASmartVehiclePhotoSearchParam, completion: @escaping (BASmartVehiclePhotoSearch?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.vehicle_search, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                
                let data = try JSONDecoder().decode(BASmartVehiclePhotoSearch.self, from: json)
                
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func VehicleDetailInfo(param: BASmartTechnicalTransferParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.basmart_technical_transfer, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: data.message, duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func VehiclePhotoList(param: VehiclePhotoListParam, completion: @escaping (VehiclePhotolistModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.vehicle_gallery_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(VehiclePhotolistModel.self, from: json)
                if data.error != 0 && data.error != nil {
                    Toast(text: String(data.error ?? -1), duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func VehicleAddPhoto(param: VehicleUploadImageParam, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.vehicle_add_new_photo, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BasicModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: String(data.message ?? ""), duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func VehicleUploadMultiSavedImage(param: BASmartVehiclePhotoSearchParam, item: BASmartVehicleImages, image: String, completion: @escaping (BasicModel?) -> Void) {
        let headers = self.getHeaders()
        
        AF.request(NetworkConstants.vehicle_search, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(BASmartVehiclePhotoSearch.self, from: json)
                
                let task = VehicleTaskParam(partner: item.partner,
                                            task: item.code)
                let addParam = VehicleUploadImageParam(kindId: VehiclePhotolistFrom.search.kindId,
                                                objectId: data.data?.vehicle?.first?.objectId,
                                                type: 1,
                                                task: task,
                                                quote: "",
                                                image: image)
                
                self.VehicleAddPhoto(param: addParam) { (data) in
                    completion(data)
                }

            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
}


//MARK: General Info
extension Network {
    func GetContactInfo(completion: @escaping ([GeneralContactListData]?) -> Void) {
        let headers = self.getHeaders()
        let param = [""]
        
        AF.request(NetworkConstants.contact_list, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                
                let data = try JSONDecoder().decode(GeneralContactList.self, from: json)
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
}


//MARK: Map
extension Network {
    func SearchMap(param: MapSearchParam, completion: @escaping ([MapData]?) -> Void) {
        let headers = self.getMapHeaders()
        
        AF.request(NetworkConstants.map_search, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(MapModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: "Lỗi", duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func SelectMap(param: MapSelectParam, completion: @escaping ([MapData]?) -> Void) {
        let headers = self.getMapHeaders()
        
        AF.request(NetworkConstants.map_select, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(MapModel.self, from: json)
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: "Lỗi", duration: Delay.long).show()
                }
                completion(data.data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
}

//MARK: Salary
extension Network {
    func GetSalaryInfo(year: Int, completion: @escaping (SalaryModel?) -> Void) {
        let headers = self.getHeaders()
        let param = ["yearindex": String(year)]
        
        AF.request(NetworkConstants.salary_info, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(SalaryModel.self, from: json)
                
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: "Lỗi", duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func GetSalaryDetail(id: Int, completion: @escaping (SalaryDetailModel?) -> Void) {
        let headers = self.getHeaders()
        let param = ["taskid": String(id)]
        
        AF.request(NetworkConstants.salary_detail, method: .post, parameters: param, encoder: encoder, headers: headers).response { response in
            do {
                guard let json = response.data else {
                    print(response.error as Any)
                    completion(nil)
                    return
                }
                let data = try JSONDecoder().decode(SalaryDetailModel.self, from: json)
                
                if data.error_code != 0 && data.error_code != nil {
                    Toast(text: "Lỗi", duration: Delay.long).show()
                }
                completion(data)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
}


//MARK: Header
extension Network {
    func getHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = ["keys": key,
                                    "clientid": "\(UserManager.shared.clientId)",
                                    "sequence": "\(UserManager.shared.sequence)"]
        return headers
    }
    
    
    func getMapHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = ["keys": keyMap,
                                    "sequence": "\(UserManager.shared.sequence)"]
        return headers
    }

}
