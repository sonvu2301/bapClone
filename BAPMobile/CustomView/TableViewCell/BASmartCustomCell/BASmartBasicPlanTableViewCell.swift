//
//  BASmartBasicPlanTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/16/21.
//

import UIKit

class BASmartBasicPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        labelName.text = ""
        labelStartTime.text = ""
        labelEndTime.text = ""
        labelAddress.text = ""
        contentView.backgroundColor = .white
    }
    
    func setupData(name: String, start: String, end: String, address: String) {
        labelName.text = name
        labelStartTime.text = start
        labelEndTime.text = end
        labelAddress.text = address
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
