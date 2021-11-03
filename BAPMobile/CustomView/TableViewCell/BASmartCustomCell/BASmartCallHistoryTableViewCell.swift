//
//  BASmartCallHistoryTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 3/19/21.
//

import UIKit

class BASmartCallHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelContent.text = ""
        labelPhoneNumber.text = ""
        labelTime.text = ""
    }
    
    func setupData(content: String, phone: String, time: Int) {
        labelContent.text = content
        labelPhoneNumber.text = phone
        labelTime.text = Date().getHourMinute(time: time)
        
    }
    
}
