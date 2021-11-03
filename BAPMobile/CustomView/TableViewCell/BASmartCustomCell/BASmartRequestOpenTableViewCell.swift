//
//  BASmartRequestOpenTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 3/22/21.
//

import UIKit
import Kingfisher

class BASmartRequestOpenTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var viewState: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.setViewCircle()
        // Initialization code
    }

    override func prepareForReuse() {
        icon.image = UIImage(named: "logo")
        labelName.text = ""
        labelContent.text = ""
        labelTime.text = ""
        viewState.backgroundColor = .green
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(icon: String, name: String, content: String, time: Int, color: String) {
        let url = URL(string: icon)
        self.icon.kf.setImage(with: url)
        labelName.text = name
        labelContent.text = content
        labelTime.text = Date().millisecToHourDate(time: time)
        viewState.backgroundColor = UIColor(hexString: color)
    }
    
}
