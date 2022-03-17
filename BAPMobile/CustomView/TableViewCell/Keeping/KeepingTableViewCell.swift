//
//  KeepingTableViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 14/03/2022.
//

import UIKit

class KeepingTableViewCell: UITableViewCell {
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var valueKeepingLabel: UILabel!
    @IBOutlet weak var valueVacationLabel: UILabel!
    @IBOutlet weak var valueVacationInSalaryLabel: UILabel!
    @IBOutlet weak var valueVacationLeftLabel: UILabel!
    @IBOutlet weak var valueSupportBoardingLabel: UILabel!
    @IBOutlet weak var valueLunchBoardingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupView(item: TimeKeepingItem){
        bgImage.downloaded(from: item.imageSrc ?? "", contentMode: .scaleToFill)
        
        let monthStr = Date().toDate(monthIndex: item.monthIndex ?? 0).toDateFormat(format: "MM")
        monthLabel.text = "Tháng \(monthStr)"
        
        valueKeepingLabel.text = item.workdays?.formatPrice()
        valueVacationLabel.text = item.vacation?.formatPrice()
        valueVacationInSalaryLabel.text = item.restpaid?.formatPrice()
        valueVacationLeftLabel.text = item.remained?.formatPrice()
        valueSupportBoardingLabel.text = String(item.eating ?? 0)
        valueLunchBoardingLabel.text = String(item.budget ?? 0)
        descriptionLabel.text = item.quoteStr ?? ""
    }

}
