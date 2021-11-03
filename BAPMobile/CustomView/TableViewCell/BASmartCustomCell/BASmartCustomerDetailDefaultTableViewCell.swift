//
//  BASmartCustomerDetailDefaultTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/13/21.
//

import UIKit

class BASmartCustomerDetailDefaultTableViewCell: UITableViewCell {

    @IBOutlet weak var viewIcon: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
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
        labelContent.text = ""
    }
    
    func setupData(title: String, content: String, isShowIcon: Bool) {
        labelTitle.text = title
        labelContent.text = content
        viewIcon.isHidden = isShowIcon
    }
}
