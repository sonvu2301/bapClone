//
//  BASmartCustomerListDescriptionTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/13/21.
//

import UIKit

class BASmartCustomerListDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var labelContent: UILabel!
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
    }
    
    func setupData(content: String) {
        labelContent.text = content
    }
    
}
