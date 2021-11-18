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
    
    @IBOutlet weak var viewAutoAuthen: UIView!
    
    var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        let isBiomestric = userDefault.bool(forKey: "Biomestric")
        let isAuto = userDefault.bool(forKey: "AutoBiomestric")
        
        switchBiomestric.setOn(isBiomestric, animated: false)
        switchAuthen.setOn(isAuto, animated: false)
        
        if !isBiomestric {
            viewAutoAuthen.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "CẤU HÌNH SINH TRẮC HỌC"
    }
    
    @IBAction func switchBiomestricTap(_ sender: Any) {
        let isBiomestric = userDefault.bool(forKey: "Biomestric")

        userDefault.setValue(!isBiomestric, forKey: "Biomestric")
        userDefault.setValue(false, forKey: "AutoBiomestric")
        viewAutoAuthen.isHidden = isBiomestric
        switchAuthen.setOn(false, animated: false)
    }
    
    @IBAction func switchAuthenTap(_ sender: Any) {
        let isAuto = userDefault.bool(forKey: "AutoBiomestric")
        userDefault.setValue(!isAuto, forKey: "AutoBiomestric")
    }
    
}
