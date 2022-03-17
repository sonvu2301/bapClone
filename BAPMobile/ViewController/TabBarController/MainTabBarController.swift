//
//  MainTabBarController.swift
//  BAPMobile
//
//  Created by Emcee on 12/4/20.
//

import UIKit

protocol MainTabBarDelegate {
    func changeIndex(index: Int)
    func backToLogin()
}

class MainTabBarController: UITabBarController {
    
    var data: LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarButton()
        // Do any additional setup after loading the view.
    }
    
    func setupTabBarButton() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        let vc3 = storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
         
        vc1.tabBarItem = UITabBarItem(title: "Trang chủ", image: UIImage(named: "ic_menu_home")?.resizeImage(targetSize: CGSize(width: 20, height: 30)), tag: 1)
        
        vc2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), tag: 2)
        vc3.tabBarItem = UITabBarItem(title: "Thông báo", image: UIImage(named: "ic_menu_notify")?.resizeImage(targetSize: CGSize(width: 20, height: 30)), tag: 3)
        
        
        vc1.data = self.data
        vc2.data = self.data?.data.users
        vc2.delegate = self
        vc3.delegate = self
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        viewControllers = [nav1, nav2, nav3]
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white
        self.tabBar.barTintColor = .white
    }
    
}

extension MainTabBarController: MainTabBarDelegate {
    func backToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func changeIndex(index: Int) {
        selectedIndex = index
    }
}
