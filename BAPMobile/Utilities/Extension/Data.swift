//
//  Data.swift
//  BAPMobile
//
//  Created by Emcee on 2/18/21.
//

import Foundation
import UIKit
import CryptoKit
import CommonCrypto

//MARK: Crypto to hex string
extension Data {
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
    
    var sha1: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(self.count), &hash)
        }
        return Data(hash)
    }
}

extension String {  
    
    var crypto: String {
        var cryp = self.data(using: .utf16LittleEndian)!.sha1.hexString
        var array = [Int]()
        for i in 2..<cryp.count {
            if i % 2 == 0 {
                array.insert(i, at: 0)
            }
        }
        array.forEach { (item) in
            cryp.insert("-", at: cryp.index(cryp.startIndex, offsetBy: item))
        }
        return cryp.uppercased()
    }
}
