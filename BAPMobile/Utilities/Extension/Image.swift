//
//  Image.swift
//  BAPMobile
//
//  Created by Emcee on 12/10/20.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 2)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeImageWithRate() -> UIImage {
        var size = self.size
        let targetSize = DataParam.shared.size > 0 ? DataParam.shared.size : 1920
        let ratio = DataParam.shared.ratio > 0 ? Double(DataParam.shared.ratio) / 100 : 0.8
        
        if size.width > size.height {
            size.height = size.height * CGFloat(targetSize) / size.width
            size.width = CGFloat(targetSize)
        } else {
            size.width = size.width * CGFloat(targetSize) / size.height
            size.height = CGFloat(targetSize)
        }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(ratio))
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func cropToSquare() -> UIImage {
        let cgimage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        let posX = contextSize.width > contextSize.height ? ((contextSize.width - contextSize.height) / 2) : 0
        let posY = contextSize.width > contextSize.height ? 0 : ((contextSize.height - contextSize.width) / 2)
        let cgSize = size.width > size.height ? size.height : size.width
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgSize, height: cgSize)
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
    
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
