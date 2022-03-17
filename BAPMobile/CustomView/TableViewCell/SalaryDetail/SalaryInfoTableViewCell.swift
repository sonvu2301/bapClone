//
//  SalaryInfoTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 9/16/21.
//

import UIKit
import Charts

class SalaryInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var salaryTotalView: SalaryTotalView!
    @IBOutlet weak var boundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func prepareForReuse() {
        salaryTotalView.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupData(data: SalaryModelItem){
        salaryTotalView.setupData(data: data)
    }
    
}
