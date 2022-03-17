//
//  KeepingDetailTableViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 17/03/2022.
//

import UIKit

class KeepingDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var parrentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //imgAbleDetail.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
