//
//  TableView.swift
//  BAPMobile
//
//  Created by Emcee on 2/1/21.
//

import Foundation
import UIKit

extension UITableView {

    func isLast(for indexPath: IndexPath) -> Bool {

        let totalRows = self.numberOfRows(inSection: indexPath.section)
        if indexPath.row == totalRows - 1 {
            return true
        } else {
            return false
        }
    }
}
