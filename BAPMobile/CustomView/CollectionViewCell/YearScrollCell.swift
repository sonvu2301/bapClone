//
//  YearScrollCell.swift
//  BAPMobile
//
//  Created by Emcee on 9/13/21.
//

import UIKit

class YearScrollCell: UICollectionViewCell {

    @IBOutlet weak var yearLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
    }

    override func prepareForReuse() {
        yearLabel.text = ""
    }
    
    func setupData(data: YearCell) {
        yearLabel.text = String(data.year)
        if data.isSelect {
            selectedCell()
        }
        if data.isSide {
            sideCell()
        }
    }
    
    
    
    func selectedCell() {
        yearLabel.font = yearLabel.font.withSize(16)
        yearLabel.textColor = UIColor().defaultColor()
    }
    
    func sideCell() {
        yearLabel.font = yearLabel.font.withSize(15)
        yearLabel.textColor = UIColor(hexString: "B4B4B4")
    }
}
