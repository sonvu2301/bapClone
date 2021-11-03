//
//  SettingViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/1/21.
//

import UIKit

class SettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "CẤU HÌNH HỆ THỐNG"
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        switch indexPath.row {
        case 0:
            cell.setupView(status: "Bật", title: "Đăng nhập sinh trắc học", icon: "")
        case 1:
            cell.setupView(status: "", title: "Thay đổi mật khẩu", icon: "")
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingBiometricViewController") as! SettingBiometricViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            break
        default:
            break
        }
        
    }
}
