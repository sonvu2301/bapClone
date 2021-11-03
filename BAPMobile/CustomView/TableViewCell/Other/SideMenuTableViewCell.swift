//
//  SideMenuTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 12/24/20.
//

import UIKit
import Kingfisher

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        iconImage.image = UIImage()
        nameLabel.text = ""
    }
    
    func setupCell(icon: String, name: String) {
        let url = URL(string: icon)
        iconImage.kf.setImage(with: url)
        nameLabel.text = name
    }
}
