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
    
    
}
