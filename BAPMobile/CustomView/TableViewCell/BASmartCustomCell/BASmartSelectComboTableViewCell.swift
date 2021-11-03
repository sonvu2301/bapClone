//
//  BASmartSelectComboTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 4/23/21.
//

import UIKit

class BASmartSelectComboTableViewCell: UITableViewCell {

    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.drawDottedLine(view: lineView)
        boundView.layer.borderColor = UIColor.black.cgColor
        boundView.layer.borderWidth = 1
        boundView.setViewCorner(radius: 5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelName.text = ""
        labelCode.text = ""
        labelDescription.text = ""
    }
    
    func setupData(name: String, code: String, description: String, bcolor: String, fcolor: String) {
        labelCode.text = code
        labelName.text = name
        labelDescription.text = description
        labelCode.backgroundColor = UIColor(hexString: bcolor)
        labelCode.textColor = UIColor(hexString: fcolor)
    }
    
}
