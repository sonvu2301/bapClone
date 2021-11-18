//
//  AllMainMenuViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/4/20.
//

import UIKit

//define all menu type
enum MenuType {
    case epl_contact, tkp_task, sad_task, smt_task, deploy_task, authenticate_info, wrt_task, chg_task, car_info, sps_task, vgs_task, customer_marketing, basmart, map_service, personal_data, bus_fleet, setting
    
    var id: Int {
        switch self {
        case .epl_contact:
            return 1
        case .tkp_task:
            return 13
        case .sad_task:
            return 19
        case .smt_task:
            return 20
        case .deploy_task:
            return 88
        case .authenticate_info:
            return 118
        case .wrt_task:
            return 147
        case .chg_task:
            return 441
        case .car_info:
            return 442
        case .sps_task:
            return 481
        case .vgs_task:
            return 450
        case .customer_marketing:
            return 964
        case .basmart:
            return 977
        case .map_service:
            return 1009
        case .personal_data:
            return 1010
        case .bus_fleet:
            return 1011
        case .setting:
            return 31743
        }
    }
    
    var name: String {
        switch self {
        case .epl_contact:
            return "Danh Bạ"
        case .tkp_task:
            return "Chấm Công"
        case .sad_task:
            return "Tạm Ứng Lương"
        case .smt_task:
            return "Bảng Lương"
        case .deploy_task:
            return "Phiếu Triển Khai"
        case .authenticate_info:
            return "Xác Thực Thông Tin"
        case .wrt_task:
            return "Phiếu Bảo Hành"
        case .chg_task:
            return "Danh Sách Khách Hàng"
        case .car_info:
            return "Thông Tin Xe"
        case .sps_task:
            return "Đề Xuất Nạp Sim"
        case .vgs_task:
            return "Bảo Lãnh Gia Hạn Dịch Vụ"
        case .customer_marketing:
            return "Danh Sách Khách Hàng"
        case .basmart:
            return "Quản lý kinh doanh"
        case .map_service:
            return "Dịch Vụ Bản Đồ"
        case .personal_data:
            return "Dữ Liệu Cá Nhân"
        case .bus_fleet:
            return "Danh Sách Tuyến Bus"
        case .setting:
            return "Cấu hình hệ thống"
        }
    }
    
    var image: UIImage {
        switch self {
        case .epl_contact:
            return UIImage(named: "ic_menu_contact_book.png") ?? UIImage()
        case .tkp_task:
            return UIImage(named: "ic_menu_bang_cham_cong.png") ?? UIImage()
        case .sad_task:
            return UIImage(named: "ic_menu_tam_ung_luong.png") ?? UIImage()
        case .smt_task:
            return UIImage(named: "ic_menu_bang_luong.png") ?? UIImage()
        case .deploy_task:
            return UIImage(named: "ic_menu_deployment.png") ?? UIImage()
        case .authenticate_info:
            return UIImage(named: "ic_menu_authenticate_info.png") ?? UIImage()
        case .wrt_task:
            return UIImage(named: "ic_menu_warranty.png") ?? UIImage()
        case .chg_task:
            return UIImage(named: "ic_menu_customer_list.png") ?? UIImage()
        case .car_info:
            return UIImage(named: "ic_menu_car_info.png") ?? UIImage()
        case .sps_task:
            return UIImage(named: "ic_menu_sim_payment.png") ?? UIImage()
        case .vgs_task:
            return UIImage(named: "ic_menu_guarantee.png") ?? UIImage()
        case .customer_marketing:
            return UIImage(named: "ic_menu_customer_marketing.png") ?? UIImage()
        case .basmart:
            return UIImage(named: "ic_menu_customer_marketing.png") ?? UIImage()
        case .map_service:
            return UIImage(named: "ic_menu_map_service.png") ?? UIImage()
        case .personal_data:
            return UIImage(named: "ic_menu_personal_data.png") ?? UIImage()
        case .bus_fleet:
            return UIImage(named: "ic_menu_bus_fleet.png") ?? UIImage()
        case .setting:
            return UIImage(named: "ic_menu_deployment") ?? UIImage()
        }
    }
    
    var vc: UIViewController {
        switch self {
        case .epl_contact:
            return UIViewController()
        case .tkp_task:
            return UIViewController()
        case .sad_task:
            return UIViewController()
        case .smt_task:
            return UIViewController()
        case .deploy_task:
            return UIViewController()
        case .authenticate_info:
            return UIViewController()
        case .wrt_task:
            return UIViewController()
        case .chg_task:
            let vc = UIStoryboard(name: "CustomerList", bundle: nil).instantiateViewController(withIdentifier: "CustomerListViewController") as! CustomerListViewController
            vc.title = "Danh Sách Khách Hàng"
            return vc
        case .car_info:
            let vc = UIStoryboard(name: "Vehicle", bundle: nil).instantiateViewController(withIdentifier: "VehicleSearchViewController") as! VehicleSearchViewController
            return vc
        case .sps_task:
            return UIViewController()
        case .vgs_task:
            return UIViewController()
        case .customer_marketing:
            return UIViewController()
        case .basmart:
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartMainViewController") as! BASmartMainViewController
            return vc
        case .map_service:
            return UIViewController()
        case .personal_data:
            return UIViewController()
        case .bus_fleet:
            return UIViewController()
        case .setting:
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            return vc
        }
    }
}

class AllMainMenuViewController: UIViewController {

    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var data: [MenuList]?
    var menuList = [MenuType]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addListMenu()
        menuCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //add list menu type to array
    func addListMenu() {
        data?.forEach({ (item) in
            switch item.menuid {
            case 1:
                menuList.append(.epl_contact)
            case 13:
                menuList.append(.tkp_task)
            case 19:
                menuList.append(.sad_task)
            case 20:
                menuList.append(.smt_task)
            case 88:
                menuList.append(.deploy_task)
            case 118:
                menuList.append(.authenticate_info)
            case 147:
                menuList.append(.wrt_task)
            case 441:
                menuList.append(.chg_task)
            case 442:
                menuList.append(.car_info)
            case 450:
                menuList.append(.vgs_task)
            case 481:
                menuList.append(.sps_task)
            case 964:
                menuList.append(.customer_marketing)
            case 977:
                menuList.append(.basmart)
            case 1009:
                menuList.append(.map_service)
            case 1010:
                menuList.append(.personal_data)
            case 1011:
                menuList.append(.bus_fleet)
            case 31743:
                menuList.append(.setting)
            default:
                return
            }
        })
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCell")
    }
}


extension AllMainMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //setup data + selection of cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        let index = indexPath.section != 0 ? indexPath.section * 2 + indexPath.row  : indexPath.row
        cell.imageView.image = menuList[index].image
        cell.titleLabel.text = menuList[index].name
        if indexPath.row == 1 {
            cell.imageSeperateLine.image = UIImage(named: "flat_list_horizontal_left")?.withHorizontallyFlippedOrientation()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section != 0 ? indexPath.section * 2 + indexPath.row  : indexPath.row
        if menuList[index] == .basmart {
            let nav = UINavigationController(rootViewController: menuList[index].vc)
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(menuList[index].vc, animated: true)
        }
    }
    
    
    
    //setup collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.bounds.size.width / 2
        return CGSize(width: cellWidth, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = menuList.count - 2 >= section * 2 ? 2 : 1
        return number
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let number = menuList.count % 2 == 0 ? menuList.count / 2 : menuList.count / 2 + 1
        return number
    }
    
}
