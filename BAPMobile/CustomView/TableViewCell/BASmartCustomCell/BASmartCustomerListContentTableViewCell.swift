//
//  BASmartCustomerListContentTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/5/21.
//

import UIKit

class BASmartCustomerListContentTableViewCell: UITableViewCell {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var dotView: UIView!
    
    @IBOutlet weak var labelUserCode: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelUserAddress: UILabel!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelNextState: UILabel!
    @IBOutlet weak var labelPartner: UILabel!
    @IBOutlet weak var labelEvaluate: UILabel!
    
    @IBOutlet weak var buttonCallIcon: UIButton!
    @IBOutlet weak var buttonCallNumber: UIButton!
    
    var delegate: BASmartGetPhoneNumberDelegate?
    var objectId = 0
    var kindId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.setViewCorner(radius: 5)
        roundedView.layer.borderWidth = 1
        roundedView.layer.borderColor = UIColor(hexString: "C8C8C8").cgColor
        dotView.drawDottedLine(view: dotView)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelUserCode.text = ""
        labelUserName.text = ""
        labelUserAddress.text = ""
        labelState.text = ""
        labelNextState.text = ""
        labelState.textColor = .black
        labelNextState.textColor = .black
        buttonCallNumber.setTitle("", for: .normal)
        labelPartner.text = "Trạng thái"
        labelPartner.textAlignment = .left
        labelPartner.font = UIFont.systemFont(ofSize: 15)
    }
    
    
    func setupCell(code: String, name: String, address: String, stateName: String, stateColor: String, rankName: String, rankColor: String, phone: String, rate: String, rateColor: String, objectId: Int, kindId: Int) {
        labelUserCode.text = code
        labelUserName.text = name
        labelUserAddress.text = address
        labelState.text = stateName
        labelState.textColor = UIColor(hexString: stateColor)
        labelNextState.text = rankName
        labelNextState.textColor = UIColor(hexString: rankColor)
        buttonCallNumber.setTitle(phone, for: .normal)
        labelEvaluate.text = rate
        labelEvaluate.textColor = UIColor(hexString: rateColor)
        self.objectId = objectId
        self.kindId = kindId
    }
    
    func setupPartnerInfo(name: String, bcolor: String, fcolor: String) {
        labelPartner.backgroundColor = UIColor(hexString: bcolor)
        labelPartner.textColor = UIColor(hexString: fcolor)
        labelPartner.text = name
        labelPartner.textAlignment = .center
        labelPartner.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    @IBAction func buttonPhoneTap(_ sender: Any) {
        delegate?.getPhoneNumber(objectId: objectId, kindId: kindId)
    }
    
}
