//
//  Textview.swift
//  BAPMobile
//
//  Created by Emcee on 1/28/21.
//

import Foundation
import UIKit

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(0, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
