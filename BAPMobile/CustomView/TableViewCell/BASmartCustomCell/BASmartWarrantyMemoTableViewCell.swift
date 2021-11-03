//
//  BASmartWarrantyMemoTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/23/21.
//

import UIKit

class BASmartWarrantyMemoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    var data = BASmartMemo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(data: BASmartMemo) {
        labelTitle.text = data.title
        labelContent.text = data.content
    }
    
}
