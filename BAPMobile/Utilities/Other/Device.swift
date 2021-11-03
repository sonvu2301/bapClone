//
//  Device.swift
//  BAPMobile
//
//  Created by Emcee on 12/8/20.
//

import Foundation
import UIKit

class Device: NSObject {
    static let shared = Device()
        
    func checkDevice() -> Bool {
        let isIphoneX = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0 ? true : false
        return isIphoneX
    }
}
