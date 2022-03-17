//
//  Decimal.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 14/03/2022.
//

import Foundation
extension Decimal{
    func formatPrice() -> String{
        let format = NumberFormatter()
        format.maximumFractionDigits  = 1
        format.minimumFractionDigits = 0
        format.numberStyle = .decimal
        
        return format.string(for: self) ?? ""
    }
}
