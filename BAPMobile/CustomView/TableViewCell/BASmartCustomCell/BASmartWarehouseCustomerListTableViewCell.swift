//
//  BASmartWarehouseCustomerListTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 11/30/21.
//

import UIKit

class BASmartWarehouseCustomerListTableViewCell: UITableViewCell {

    @IBOutlet weak var boundView: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCustomerCode: UILabel!
    @IBOutlet weak var labelProject: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var labelScale: UILabel!
    @IBOutlet weak var labelKind: UILabel!
    
    @IBOutlet weak var buttonPhone: UIButton!
    @IBOutlet weak var buttonSend: UIButton!
    
    
    var data = BASmartWarehouseCustomerData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        boundView.layer.borderWidth = 1
        boundView.layer.borderColor = UIColor().defaultColor().cgColor
        boundView.setViewCorner(radius: 5)
        
        let imageSend = UIImage(named: "login")
        let tintedImage = imageSend?.withRenderingMode(.alwaysTemplate)
        buttonSend.setImage(tintedImage, for: .normal)
        buttonSend.tintColor = .white
            
        buttonPhone.setImage(UIImage(named: "ic_tel_01")?.resizeImage(targetSize: CGSize(width: 18, height: 18)), for: .normal)
        buttonPhone.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        buttonPhone.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelName.text = ""
        labelCustomerCode.text = ""
        labelProject.text = ""
        labelAddress.text = ""
        labelModel.text = ""
        labelScale.text = ""
        labelKind.text = ""
        
        buttonPhone.setTitle("", for: .normal)
    }
    
    func setupData(data: BASmartWarehouseCustomerData) {
        self.data = data
        labelName.text = data.name
        labelCustomerCode.text = data.kh
        labelProject.text = data.project?.name
        labelAddress.text = data.address
        labelModel.text = data.model?.name
        labelScale.text = data.scale?.name
        labelKind.text = data.kind?.name
        
        buttonPhone.setTitle(data.phone, for: .normal)
    }
    
    
}
