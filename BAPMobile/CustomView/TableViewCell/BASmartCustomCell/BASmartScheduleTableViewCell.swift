//
//  BASmartScheduleTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 12/30/20.
//

import UIKit

class BASmartScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dotView.setViewCircle()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelContent.text = ""
        labelTime.text = ""
    }
    
    func setupView(start: Int, end: Int, title: String) {
        let startStr = Date().millisecToHourMinute(time: start)
        let endStr = Date().millisecToHourMinute(time: end)
        labelContent.text = title
        labelTime.text = "\(startStr) - \(endStr)"
    }
}
