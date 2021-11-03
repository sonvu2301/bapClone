//
//  SettingTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 11/1/21.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(status: String, title: String, icon: String) {
        labelStatus.text = status
        labelTitle.text = title
        self.icon.image = UIImage(named: icon)
    }
    
}
