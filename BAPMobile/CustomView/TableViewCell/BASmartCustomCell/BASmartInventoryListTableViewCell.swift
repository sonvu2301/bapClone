//
//  BASmartInventoryListTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 11/17/21.
//

import UIKit

class BASmartInventoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    var data = BASmartInventoryCommodity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelName.text = ""
        labelQuantity.text = ""
        boundView.backgroundColor = .white
        labelName.font = UIFont.systemFont(ofSize: 13)
    }
    
    func setupData(cellData: BASmartInventoryCommodity) {
        data = cellData
        labelName.text = data.name
        labelQuantity.text = "\(data.quantity ?? 0).0"
        if data.imei ?? false {
            labelName.font = UIFont.boldSystemFont(ofSize: 13)
        }
    }
    
}
