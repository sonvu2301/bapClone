//
//  SalaryDetailTaxCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 10/03/2022.
//

import UIKit

class SalaryDetailTaxCell: UITableViewCell {
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblTaxVal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupView(item: SalaryDetailTaxItems){
        
        let format = NumberFormatter()
        format.maximumFractionDigits  = 1
        format.minimumFractionDigits = 0
        format.numberStyle = .decimal
        lblMoney.text = "\(format.string(for: (item.money ?? 0)/1000000) ?? "?")M"
        colorView.backgroundColor = UIColor(hexString: item.color ?? "#000000")
        lblSalary.text = "\(format.string(for: item.salary ?? 0) ?? "?")"
        lblPercent.text = "\(String(describing: item.percent ?? 0))%"
        lblTaxVal.text = "\(format.string(for: item.taxval ?? 0) ?? "?")"//String(describing: item.taxval ?? 0)
    }
}
