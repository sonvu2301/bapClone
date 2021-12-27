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

enum LoginValidate {
    case userName, pass, success
    
    var bugNote: String {
        switch self {
        case .userName:
            return "Chưa nhập tên tài khoản"
        case .pass:
            return "Chưa nhập mật khẩu"
        case .success:
            return ""
        }
    }
}

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonBiometric: UIButton!
    @IBOutlet weak var buttonPassword: UIButton!
    @IBOutlet weak var buttonAutoLogin: UIButton!
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var imageUserCheck: UIImageView!
    
    var isAutoLogin = false
    var isShowPassword = false
    var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        callReq()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        buttonLogin.setViewCircle()
        buttonPassword.setViewCircle()
        navigationController?.navigationBar.isHidden = true
        isAutoLogin = userDefault.bool(forKey: "Save")
        let isBio = userDefault.bool(forKey: "Biomestric")
        
        autoLogin(isAutoLogin: isAutoLogin)
        
        userTextField.delegate = self
        userTextField.text = userDefault.string(forKey: "UserName")
        
        if (userTextField.text?.count ?? 0) > 1 {
            imageUserCheck.image = UIImage(named: "ic_check_done")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        }
        
        buttonBiometric.isHidden = !isBio
        buttonAutoLogin.isHidden = isBio
        
        let biometric = LAContext().biometricType
        
        switch biometric {
        case .none:
            buttonBiometric.isHidden = true
            if isAutoLogin {
                guard let user = userDefault.string(forKey: "UserName") else { return }
                guard let pass = userDefault.string(forKey: "Password") else { return }
                
                userTextField.text = user
                passTextField.text = pass
                
                login(userName: user, pass: pass)
            }
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
        
        let auto = userDefault.bool(forKey: "AutoBiomestric")
        if auto {
            biomestricAction(user: userDefault.string(forKey: "UserName") ?? "",
                             pass: userDefault.string(forKey: "Password") ?? "")
        }
        
        
    }
    
    private func callReq(){
        Network.shared.clientReq { (isDone) in
            
        }
    }
    
    private func login(userName: String, pass: String) {
        
        self.showBlurBackground()
        
        Network.shared.clientReq { (isDone) in
            let param = LoginParam(user: userName, pass: pass.crypto)
            
            Network.shared.login(param: param) { [weak self] (data) in
                self?.hideBlurBackground()
                if data?.error_code == 0 {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                    // Check auto login
                    self?.saveUser()
                    let param = data?.data.param
                    DataParam.shared.setDataParam(attSize: param?.attsize ?? 0,
                                                  ratio: param?.imgratio ?? 0 ,
                                                  size: param?.imgsize ?? 0)
                    //Setup Data
                    vc.data = data
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self?.presentBasicAlert(title: "Lỗi",
                                            message: "Tài khoản hoặc mật khẩu chưa chính xác",
                                            buttonTittle: "Đồng ý")
                }
            }
        }
    }
    
    private func autoLogin(isAutoLogin: Bool) {
        let imgCheck = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        let imgUncheck = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        
        let img = isAutoLogin ? imgCheck : imgUncheck
        let tintedImage = img?.withRenderingMode(.alwaysTemplate)
        buttonAutoLogin.setImage(tintedImage, for: .normal)
        buttonAutoLogin.tintColor = .white
        userDefault.set(isAutoLogin, forKey: "Save")
    }
    
    private func saveUser() {
        userDefault.set(userTextField.text, forKey: "UserName")
        userDefault.set(passTextField.text, forKey: "Password")
    }
    
    private func biomestricAction(user: String, pass: String) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Login by biomestrics"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async { [weak self] in
                    if success {
                        self?.userTextField.text = user
                        self?.passTextField.text = pass
                        self?.login(userName: user, pass: pass)
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
                            self?.userTextField.text = user
                            self?.passTextField.text = pass
                            self?.login(userName: user, pass: pass)
                        } else {
                            // error
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func loginButtonTap(_ sender: Any) {
        
        var state = LoginValidate.success
        state = (userTextField.text?.count ?? 0) < 1 ? .userName : .success
        if state != .userName {
            state = (passTextField.text?.count ?? 0) < 1 ? .pass : .success
        }
        
        switch state {
        case .userName, .pass:
            self.presentBasicAlert(title: "Lỗi", message: state.bugNote, buttonTittle: "Đồng ý")
        case .success:
            login(userName: userTextField.text ?? "",
                  pass: passTextField.text ?? "")
        }
        
        
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
    
    @IBAction func buttonAutologinTap(_ sender: Any) {
        isAutoLogin = !isAutoLogin
        autoLogin(isAutoLogin: isAutoLogin)
    }
    
    @IBAction func buttonBiometricTap(_ sender: Any) {
        guard let user = userDefault.string(forKey: "UserName") else { return }
        guard let pass = userDefault.string(forKey: "Password") else { return }
        biomestricAction(user: user, pass: pass)
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userTextField {
            let currentText:String = textField.text!
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if updatedText.count > 1 {
                imageUserCheck.image = UIImage(named: "ic_check_done")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
            } else {
                imageUserCheck.image = UIImage(named: "ic_check_off")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
            }
        }
        return true
    }
}
