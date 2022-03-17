//
//  YearScrollCell.swift
//  BAPMobile
//
//  Created by Emcee on 9/13/21.
//

import UIKit

struct YearCell {
    var year: Int
    var isSelect: Bool
    var isSide: Bool
}

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
        yearLabel.textColor = UIColor(hexString: "B4B4B4")
        yearLabel.font = yearLabel.font.withSize(14)
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
    func setupData(list: [DateObject], idx: Int){
        let obj = list[idx]
        yearLabel.text = String(obj.date.getComponents().year ?? 0)
        //trường hợp được active
        if(obj.isActive){
            yearLabel.font = yearLabel.font.withSize(18)
            yearLabel.textColor = UIColor().defaultColor()
        }
        //trường hợp không được active
        
        let idxActive = Int( list.firstIndex(where: {$0.isActive == true}) ?? 0)
        if idx == (idxActive - 1) ||
        idx == (idxActive + 1){
            yearLabel.font = yearLabel.font.withSize(16)
            yearLabel.textColor = UIColor(hexString: "B4B4B4")
        }
    }
    
    func selectedCell() {
        yearLabel.font = yearLabel.font.withSize(16)
        yearLabel.textColor = UIColor().defaultColor()
    }
    
    func sideCell() {
        yearLabel.font = yearLabel.font.withSize(14)
        yearLabel.textColor = UIColor(hexString: "B4B4B4")
    }
}
