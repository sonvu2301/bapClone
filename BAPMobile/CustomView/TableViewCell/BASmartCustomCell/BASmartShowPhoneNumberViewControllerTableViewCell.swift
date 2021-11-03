//
//  BASmartShowPhoneNumberViewControllerTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 5/18/21.
//

import UIKit

class BASmartShowPhoneNumberViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonPhone: UIButton!
    
    var phone = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonPhone.setImage(UIImage(named: "ic_tel_02")?.resizeImage(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(phone: String) {
        buttonPhone.setTitle("  \(phone)", for: .normal)
        self.phone = phone
    }
    
    @IBAction func buttonPhoneTap(_ sender: Any) {
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func prepareForReuse() {
        buttonPhone.setTitle("", for: .normal)
    }
    
}
