//
//  ViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/13/21.
//

import Foundation
import UIKit

protocol BASmartDoneCreateDelegate {
    func finishCreate()
}

extension UIViewController {
    //Create a basic alert
    func presentBasicAlert(title: String, message: String, buttonTittle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: buttonTittle, style: .default, handler: nil)
        acceptButton.setValue(UIColor().defaultColor(), forKey: "titleTextColor")
        alert.addAction(acceptButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagesToBase64(images: [UIImage]) -> [String] {
        var imagesConvert = [String]()
        images.forEach { (image) in
            imagesConvert.append(image.toBase64() ?? "")
        }
        
        return imagesConvert
    }
    
    func blurScreenWhenNotForgeground() {
        let notiToBackground = NotificationCenter.default
        notiToBackground.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        let notiToForgeground = NotificationCenter.default
        notiToForgeground.addObserver(self, selector: #selector(appAppear), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appAppear() {
        view.removeBlurLoader()
    }
    
    @objc func appMovedToBackground() {
        view.showBlurLoader()
    }
    
}

extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
