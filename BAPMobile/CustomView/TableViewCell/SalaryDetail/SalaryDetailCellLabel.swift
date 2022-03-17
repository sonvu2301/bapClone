//
//  SalaryDetailCellLabel.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 10/03/2022.
//

import UIKit

class SalaryDetailCellLabel: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupView(item: SalaryDefaultData){
        lblName.text = item.name
        lblValue.text = "\(String(describing: item.value ?? 0))"
    }
    func setupView(item: SalaryDetailSaftyItems){
        lblName.text = item.name
        lblValue.text = "\(String(describing: item.value ?? 0))"
    }
    func setupView(name: String, value: String){
        lblName.text = name
        lblValue.text = value
    }

}
