//
//  LoginViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/16/20.
//

import UIKit
import CryptoKit
import CommonCrypto
import LocalAuthentication
import Security

struct LoginForm: Codable {
    var user: String
    var pass: String
}

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var buttonCheckboxAutologin: UIButton!
    @IBOutlet weak var buttonAutoLogin: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonBiometric: UIButton!
    @IBOutlet weak var buttonPassword: UIButton!
    

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var labelVersion: UILabel!
    
    var isAutoLogin = false
    var isShowPassword = false
    var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        callReq()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        buttonLogin.setViewCircle()
        buttonPassword.setViewCircle()
        navigationController?.navigationBar.isHidden = true
        isAutoLogin = userDefault.bool(forKey: "Save")
        let isBio = userDefault.bool(forKey: "Biomestric")
        
        if isAutoLogin {
            userTextField.text = userDefault.string(forKey: "UserName")
            passTextField.text = userDefault.string(forKey: "Password")
            buttonCheckboxAutologin.setImage(UIImage(named: "ic_check_done"), for: .normal)
        }
        
        if isBio {
            buttonBiometric.isHidden = false
        }
        
        buttonCheckboxAutologin.setViewCircle()
        let biometric = LAContext().biometricType
        switch biometric {
        case .none:
            buttonBiometric.isHidden = true
        case .touchID:
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "touchid")
                let config = UIImage.SymbolConfiguration(pointSize: 60)
                buttonBiometric.setPreferredSymbolConfiguration(config, forImageIn: .normal)
                buttonBiometric.setImage(image?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                break
            }
        case .faceID:
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "faceid")
                let config = UIImage.SymbolConfiguration(pointSize: 60)
                buttonBiometric.setPreferredSymbolConfiguration(config, forImageIn: .normal)
                buttonBiometric.setImage(image?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                break
            }
        }
    }
    
    private func callReq(){
        Network.shared.clientReq { [weak self] (isDone) in
            if self?.isAutoLogin == true {
                self?.login(userName: self?.userTextField.text ?? "",
                            pass: self?.passTextField.text?.crypto ?? "")
            }
        }
    }
    
    private func login(userName: String, pass: String) {
        
        Network.shared.login(userName: userName, pass: pass) { [weak self] (data) in
            if data?.error_code == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                // Check auto login
                self?.saveUser()
                self?.userDefault.set(self?.isAutoLogin, forKey: "Save")
                let param = data?.data.param
                DataParam.shared.setDataParam(attSize: param?.attsize ?? 0,
                                              ratio: param?.imgratio ?? 0 ,
                                              size: param?.imgsize ?? 0)
                //Setup Data
                vc.data = data
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("error")
            }
        }
    }
    
    private func saveUser() {
        userDefault.set(userTextField.text, forKey: "UserName")
        userDefault.set(passTextField.text, forKey: "Password")
    }
    
    @IBAction func loginButtonTap(_ sender: Any) {
        login(userName: userTextField.text ?? "",
              pass: passTextField.text?.crypto ?? "")
    }
    
    @IBAction func buttonAutoLoginTap(_ sender: Any) {
        let image = isAutoLogin == true ? UIImage() : UIImage(named: "ic_check_done")
        buttonCheckboxAutologin.setImage(image, for: .normal)
        isAutoLogin = !isAutoLogin
    }
    
    @IBAction func buttonCheckboxAutologinTap(_ sender: Any) {
        let image = isAutoLogin == true ? UIImage() : UIImage(named: "ic_check_done")
        buttonCheckboxAutologin.setImage(image, for: .normal)
        isAutoLogin = !isAutoLogin
    }
    
    @IBAction func buttonPasswordTap(_ sender: Any) {
        passTextField.isSecureTextEntry = isShowPassword
        isShowPassword = !isShowPassword
        if isShowPassword {
            buttonPassword.setImage(UIImage(named: "show_password"), for: .normal)
        } else {
            buttonPassword.setImage(UIImage(named: "hide_password"), for: .normal)
        }
    }
    
    
    @IBAction func buttonBiometricTap(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Login by biomestrics"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async { [weak self] in
                    if success {
                        self?.userTextField.text = self?.userDefault.string(forKey: "UserName")
                        self?.passTextField.text = self?.userDefault.string(forKey: "Password")
                    } else {
                        // error
                    }
                }
            }
            
        } else {
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Login by locked password"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, authenticationError in
                    DispatchQueue.main.async { [weak self] in
                        if success {
                            self?.userTextField.text = self?.userDefault.string(forKey: "UserName")
                            self?.passTextField.text = self?.userDefault.string(forKey: "Password")
                        } else {
                            // error
                        }
                    }
                }
            }
        }
    }
}


