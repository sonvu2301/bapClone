//
//  CustomerListTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 12/18/20.
//

import UIKit

class CustomerListTableViewCell: UITableViewCell {

    @IBOutlet weak var xnCode: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        xnCode.text = ""
        nameLabel.text = ""
        addressLabel.text = ""
        phoneNumberLabel.text = ""
    }
    
    func setupData(xn: String, name: String, address: String, phone: String) {
        xnCode.text = xn
        nameLabel.text = name
        addressLabel.text = address
        phoneNumberLabel.text = phone
    }
}
