//
//  AppDelegate.swift
//  BAPMobile
//
//  Created by Emcee on 12/4/20.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        UINavigationBar.appearance().tintColor = .white
        
        //Add google map key
        GMSServices.provideAPIKey("AIzaSyB3KkvioYia26IQUMG6CPxnAnnewow-gTQ")
        GMSPlacesClient.provideAPIKey("AIzaSyB3KkvioYia26IQUMG6CPxnAnnewow")
        // Override point for customization after application launch.
        return true
    }

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "BASmart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {

                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()


}

