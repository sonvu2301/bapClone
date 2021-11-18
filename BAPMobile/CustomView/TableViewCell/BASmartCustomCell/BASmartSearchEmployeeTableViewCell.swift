//
//  BASmartSearchEmployeeTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 11/12/21.
//

import UIKit

class BASmartSearchEmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    @IBOutlet weak var viewSeperate: UIView!
    
    var data = BASmartUtilitySupportData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewSeperate.drawDottedLine(view: viewSeperate)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelName.text = ""
        labelPhone.text = ""
    }
    
    func setupData(data: BASmartUtilitySupportData) {
        self.data = data
        labelName.text = "\(data.fullName ?? "") (\(data.userName ?? ""))"
        labelPhone.text = data.mobile
    }
    
}
