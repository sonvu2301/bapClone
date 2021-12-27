//
//  SideMenuViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/24/20.
//

import UIKit
import SideMenu


class SideMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelOffice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems = [SideMenuItem]()
    var menuDatas = [BASmartMenuList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenuView()
        // Do any additional setup after loading the view.
    }
    
    
    private func setupSideMenuView() {
        navigationController?.navigationBar.isHidden = true
        let sideMenuManager = SideMenuItems.shared
        menuItems = [SideMenuItem]()
        menuDatas = [BASmartMenuList]()
        menuItems = sideMenuManager.getSideMenuItems()
        menuDatas = sideMenuManager.getSideMenuDatas()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        tableView.separatorStyle = .none
        
        //Make header view shorter when it isn't device with bunny ears
        if !Device().checkDevice() {
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        }
        
        labelName.text = UserInfo.shared.name
        labelEmail.text = UserInfo.shared.email
        labelOffice.text = UserInfo.shared.branchName
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        let data = menuDatas[indexPath.row]
        cell.setupCell(icon: data.icon ?? "",
                       name: data.name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch menuItems[indexPath.row] {
        case .main, .customer_list, .plan, .call_data, .reopen_request, .form, .inventory, .customer_data:
            self.navigationController?.pushViewController(menuItems[indexPath.row].vc, animated: true)
        case .blank, .statistical_report, .move_schedule, .request_new:
            break
        case .end_day:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckoutBASmart"), object: nil)
        case .back:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseBASmart"), object: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
