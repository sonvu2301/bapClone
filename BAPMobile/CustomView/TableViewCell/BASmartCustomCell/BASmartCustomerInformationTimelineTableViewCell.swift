//
//  BASmartCustonmerInformationTimelineTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/26/21.
//

import UIKit
import Kingfisher

class BASmartCustomerInformationTimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var iconOnlineImage: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var labelContact: UILabel!
    
    var delegate: BASmartGetPhoneNumberDelegate?
    var objectId = 0
    var kindId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dotView.drawDottedLine(view: dotView)
        let phoneImage = UIImage(named: "ic_tel_01")?.resizeImage(targetSize: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        buttonCall.setImage(phoneImage, for: .normal)
        buttonCall.tintColor = UIColor().defaultColor()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelTime.text = ""
        labelContent.text = ""
        labelContact.text = ""
        labelTitle.text = ""
        buttonCall.setTitle("", for: .normal)
        iconOnlineImage.image = UIImage()
        dotView.isHidden = false
    }
    
    func setupData(time: Int, content: String, title: String, contact: String, phone: String, icon: String, objectId: Int, kindId: Int) {
        labelTitle.text = title
        labelContent.text = content
        labelContact.text = contact
        labelTime.text = Date().millisecToHourMinute(time: time)
        buttonCall.setTitle(" \(phone)", for: .normal)
        let url = URL(string: icon)
        iconOnlineImage.kf.setImage(with: url)
        self.objectId = objectId
        self.kindId = kindId
    }
    
    @IBAction func buttonPhoneTap(_ sender: Any) {
        delegate?.getPhoneNumber(objectId: objectId, kindId: kindId)
    }
    
}
