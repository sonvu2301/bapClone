//
//  DateScrollCell.swift
//  BAPMobile
//
//  Created by Emcee on 3/2/21.
//

import UIKit

class DateScrollCell: UICollectionViewCell {

    @IBOutlet weak var labelWeekDay: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
    }
    
    override func prepareForReuse() {
        labelDate.text = "0/0"
        labelWeekDay.text = "CN"
        labelDate.textColor = .black
        labelWeekDay.textColor = .black
        labelWeekDay.font = labelWeekDay.font.withSize(14)
        labelDate.font = labelDate.font.withSize(14)
        labelWeekDay.textColor = UIColor(hexString: "DCDCDC")
        labelDate.textColor = UIColor(hexString: "DCDCDC")
    }

    func setupData(setting: DateScroll) {
        labelWeekDay.text = setting.dateOfWeek
        labelDate.text = setting.dateString
        if setting.isSelect {
            selectedCell()
        }
        
        if setting.isSideCell {
            sideCell()
        }
    }
    func setupData(list: [DateObject], idx: Int){
        let obj = list[idx]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        labelDate.text = dateFormatter.string(from: obj.date)
        labelWeekDay.text = obj.date.dayOfWeek()
        
        //trường hợp được active
        if(obj.isActive){
            labelDate.font = labelDate.font.withSize(14)
            labelDate.textColor = UIColor().defaultColor()
            labelWeekDay.font = labelWeekDay.font.withSize(18)
            labelWeekDay.textColor = UIColor().defaultColor()
        }
        //trường hợp không được active
        let idxActive = Int( list.firstIndex(where: {$0.isActive == true}) ?? 0)
        if idx == (idxActive - 1) ||
            idx == (idxActive + 1){
            labelDate.font = labelDate.font.withSize(15)
            labelDate.textColor = .systemGray
            
            labelWeekDay.font = labelWeekDay.font.withSize(15)
            labelWeekDay.textColor = .systemGray
        }
    }
    
    func selectedCell() {
        labelWeekDay.font = labelWeekDay.font.withSize(16)
        labelDate.font = labelDate.font.withSize(16)
        labelWeekDay.textColor = UIColor().defaultColor()
        labelDate.textColor = UIColor().defaultColor()
    }
    
    func sideCell() {
        labelWeekDay.font = labelWeekDay.font.withSize(15)
        labelDate.font = labelDate.font.withSize(15)
        labelWeekDay.textColor = UIColor(hexString: "B4B4B4")
        labelDate.textColor = UIColor(hexString: "B4B4B4")
    }
}
