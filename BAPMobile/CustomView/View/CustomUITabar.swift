//
//  CustomUITabar.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 11/03/2022.
//

import UIKit

@IBDesignable
class CustomUITabar: UITabBar {
    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        //self.addShape()
        self.setupMiddleButton()
    }
     
    func setupMiddleButton() {
        let userButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        shadowView.addShadowWithColor(color: UIColor().defaultColor(), cornerRadius: shadowView.frame.height)
        var menuButtonFrame = userButton.frame
        menuButtonFrame.origin.y = Device.shared.checkDevice() == true ? self.bounds.height - menuButtonFrame.height - 34 : self.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = self.bounds.width/2 - menuButtonFrame.size.width/2
        userButton.frame = menuButtonFrame
        userButton.backgroundColor = UIColor().defaultColor()
        userButton.layer.cornerRadius = menuButtonFrame.height/2
        userButton.clipsToBounds = true
        userButton.setImage(UIImage(named: "ic_user_default"), for: .normal)
        
        shadowView.addSubview(userButton)
        self.addSubview(shadowView)
        
        //userButton.addTarget(self, action: #selector(selectUserButton(sender:)), for: .touchUpInside)
        self.layoutIfNeeded()
    }
    
//    @objc private func selectUserButton(sender: UIButton) {
//        selectedIndex = 1
//    }
}
