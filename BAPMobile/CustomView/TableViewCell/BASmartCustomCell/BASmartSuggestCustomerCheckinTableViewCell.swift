//
//  BASmartSuggestCustomerCheckinTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/16/21.
//

import UIKit
import Kingfisher

class BASmartSuggestCustomerCheckinTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonPhone: UIButton!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var imagePartner: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let phoneImage = UIImage(named: "ic_tel_01")?.resizeImage(targetSize: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        buttonPhone.setImage(phoneImage, for: .normal)
        buttonPhone.tintColor = UIColor().defaultColor()
        imagePartner.isHidden = true

        // Initialization code
    }

    override func prepareForReuse() {
        labelCode.text = ""
        labelName.text = ""
        labelAddress.text = ""
        buttonPhone.setTitle("", for: .normal)
        sideView.backgroundColor = .clear
        buttonPhone.isHidden = false
        imagePartner.isHidden = true
    }
    
    
    func setupDate(code: String, name: String, address: String, phone: String, bcolor: String, fcolor: String, partner: String ) {
        labelCode.text = code
        labelName.text = name
        labelAddress.text = address
        buttonPhone.setTitle(" \(phone)", for: .normal)
        sideView.backgroundColor = UIColor(hexString: bcolor)
        if phone == "" {
            buttonPhone.isHidden = true
        }
        //Check icon is empty
        if partner != "#" && partner != "" {
            imagePartner.isHidden = false
            guard let url = URL.init(string: partner) else { return }
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result) in
                switch result {
                case .success(let value):
                    let partnerImage = value.image.withRenderingMode(.alwaysTemplate)
                    self?.imagePartner.image = partnerImage
                    self?.tintColor = UIColor(hexString: fcolor)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
