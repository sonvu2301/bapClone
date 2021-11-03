//
//  SettingBiometricViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/1/21.
//

import UIKit

class SettingBiometricViewController: BaseViewController {
    @IBOutlet weak var switchBiomestric: UISwitch!
    @IBOutlet weak var switchAuthen: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "CẤU HÌNH SINH TRẮC HỌC"
    }
    
}
