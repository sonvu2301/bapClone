//
//  BASmartWarningTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 12/30/20.
//

import UIKit
import Kingfisher

class BASmartWarningTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
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
        icon.image = UIImage()
        labelTime.text = ""
    }
    
    func setupView(icon: String, time: Int, content: String) {
        let url = URL(string: icon)
        let day = Date().millisecToHourDate(time: time)
        self.icon.kf.setImage(with: url)
        labelTime.text = "\(day): \(content)"
    }
}
