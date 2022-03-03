//
//  ContactTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 12/14/20.
//

import UIKit
import Kingfisher

class ContactTableViewCell: UITableViewCell{

    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    
    var data = ContactItem()
    var phone = "090909090909"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setupData(data: ContactItem) {
        let urlImage = URL(string: data.avatar ?? "")
        avaImage.kf.setImage(with: urlImage)
        nameLabel.text = data.fullname
        positionLabel.text = data.position
        emailLabel.text = data.email
        
        self.data = data
    }
    
    
    @IBAction func callButtonTap(_ sender: UIButton) {
        if let url = URL(string: "tel://\(data.mobile ?? "")"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func prepareForReuse() {
        avaImage.image = UIImage()
        nameLabel.text = ""
        positionLabel.text = ""
        emailLabel.text = ""
    }
    
}
