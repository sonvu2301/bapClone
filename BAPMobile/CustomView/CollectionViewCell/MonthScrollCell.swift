//
//  MonthScrollCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 06/03/2022.
//

import UIKit

class MonthScrollCell: UICollectionViewCell {

    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
    }

    override func prepareForReuse() {
        lblMonth.text = ""
        lblMonth.font = lblMonth.font.withSize(12)
        lblMonth.textColor = UIColor(hexString: "B4B4B4")
        lblYear.text = ""
        lblYear.font = lblYear.font.withSize(12)
        lblYear.textColor = UIColor(hexString: "B4B4B4")
    }
    func setupData(list: [DateObject], idx: Int){
        let obj = list[idx]
        lblMonth.text = "Tháng " + String(obj.date.getComponents().month ?? 0)
        lblYear.text = String(obj.date.getComponents().year ?? 0)
        
        //trường hợp được active
        if(obj.isActive){
            lblMonth.font = lblMonth.font.withSize(16)
            lblMonth.textColor = UIColor().defaultColor()
            lblYear.font = lblYear.font.withSize(16)
            lblYear.textColor = UIColor().defaultColor()
        }
        //trường hợp không được active
        let idxActive = Int( list.firstIndex(where: {$0.isActive == true}) ?? 0)
        if idx == (idxActive - 1) ||
            idx == (idxActive + 1){
            lblMonth.font = lblMonth.font.withSize(14)
            lblMonth.textColor = .systemGray
            
            lblYear.font = lblYear.font.withSize(14)
            lblYear.textColor = .systemGray
        }
    }
}
