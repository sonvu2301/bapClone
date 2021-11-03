//
//  View.swift
//  BAPMobile
//
//  Created by Emcee on 12/4/20.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(cornerRadius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.5
    }
    
    func addShadowWithColor(color: UIColor, cornerRadius: CGFloat ) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1
    }
    
    func setViewCorner(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func setViewCircle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    func setCornerRadiusPopover() {
        self.layer.cornerRadius = 14
    }
    
    func drawDottedLine(view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor().defaultColor().cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 7] // 7 is the length of dash, 3 is length of the gap.
        shapeLayer.opacity = 0.5
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: view.bounds.minX, y: view.bounds.minY), CGPoint(x: view.bounds.maxX, y: view.bounds.minY)])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }

}
//Loading indicator
extension UIView {
    func showBlurLoader() {
        let blurLoader = BlurLoader(frame: frame)
        self.addSubview(blurLoader)
    }

    func removeBlurLoader() {
        if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
    }
}


class BlurLoader: UIView {

    var blurEffectView: UIVisualEffectView?

    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        super.init(frame: frame)
        addSubview(blurEffectView)
        addLoader()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLoader() {
        guard let blurEffectView = blurEffectView else { return }
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        activityIndicator.startAnimating()
    }
}

