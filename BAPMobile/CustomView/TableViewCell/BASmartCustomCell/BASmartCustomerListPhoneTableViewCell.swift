//
//  BASmartCustomerListPhoneTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/13/21.
//

import UIKit

class BASmartCustomerListPhoneTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonCallNumber: UIButton!
    @IBOutlet weak var buttonCallIcon: UIButton!
    
    var objectId = 0
    var kindId = 0
    var delegate: BASmartGetPhoneNumberDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelTitle.text = ""
        buttonCallNumber.setTitle("", for: .normal)
    }
    
    func setupData(title: String, phone: String, objectId: Int, kindId: Int) {
        labelTitle.text = title
        buttonCallNumber.setTitle(phone, for: .normal)
        self.objectId = objectId
        self.kindId = kindId
    }
    
    @IBAction func buttonPhoneTap(_ sender: Any) {
        delegate?.getPhoneNumber(objectId: objectId, kindId: kindId)
    }
    
}
