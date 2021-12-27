//
//  BASmartWarrantyListTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/21/21.
//

import UIKit
import Kingfisher

class BASmartWarrantyListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var viewTitleBackground: UIView!
    @IBOutlet weak var viewEmployee: UIView!
    @IBOutlet weak var viewAccount: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelXNCode: UILabel!
    @IBOutlet weak var labelCustomerName: UILabel!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelEmployee: UILabel!
    @IBOutlet weak var labelPartner: UILabel!
    @IBOutlet weak var labelVehicleCount: UILabel!
    @IBOutlet weak var labelAccount: UILabel!
    
    @IBOutlet weak var buttonCodePhoneNumber: UIButton!
    @IBOutlet weak var buttonContactPhoneNumber: UIButton!
    @IBOutlet weak var buttonEmployeePhoneNumber: UIButton!
    
    @IBOutlet weak var imageTitle: UIImageView!
    
    var codePhone = 0
    var contactPhone = 0
    var employeePhone = 0
    var data = BASmartTechnicalData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let phoneImage = UIImage(named: "ic_tel_01")?.resizeImage(targetSize: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        
        buttonCodePhoneNumber.setImage(phoneImage, for: .normal)
        buttonContactPhoneNumber.setImage(phoneImage, for: .normal)
        buttonEmployeePhoneNumber.setImage(phoneImage, for: .normal)
        
        buttonCodePhoneNumber.tintColor = UIColor().defaultColor()
        buttonContactPhoneNumber.tintColor = UIColor().defaultColor()
        buttonEmployeePhoneNumber.tintColor = UIColor().defaultColor()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        viewAccount.isHidden = true
    }
    
    func setupData(data: BASmartTechnicalData) {
        self.data = data
        labelTitle.textColor = UIColor(hexString: data.task?.fcolor ?? "")
        labelTitle.text = "\(data.task?.kind ?? "") (\(data.task?.taskNumber ?? ""))"
        labelXNCode.text = data.customer?.xncode ?? ""
        labelCustomerName.text = data.customer?.name
        labelContact.text = data.contact?.name
        labelTime.text = Date().millisecToDateHour(time: data.implement ?? 0)
        labelAddress.text = data.address
        labelEmployee.text = data.seller?.name
        labelPartner.text = data.partner?.code
        labelPartner.textColor = UIColor(hexString: data.partner?.fcolor ?? "")
        labelAccount.text = data.account
        labelVehicleCount.text = String(data.vehicleCount ?? 0)
        
        buttonCodePhoneNumber.setTitle(data.customer?.phone ?? "", for: .normal)
        buttonContactPhoneNumber.setTitle(data.contact?.mobile ?? "", for: .normal)
        buttonEmployeePhoneNumber.setTitle(data.seller?.mobile ?? "", for: .normal)
        
        viewTitleBackground.backgroundColor = UIColor(hexString: data.task?.bcolor ?? "")
        viewEmployee.backgroundColor = UIColor(hexString: data.partner?.bcolor ?? "")
        
        boundView.setViewCorner(radius: 5)
        boundView.layer.borderWidth = 1
        boundView.layer.borderColor = UIColor(hexString: data.task?.bcolor ?? "").cgColor
        
        guard let url = URL.init(string: data.task?.icon ?? "") else { return }
        let resource = ImageResource(downloadURL: url)
        
        imageTitle.kf.setImage(with: url)
        KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result) in
            switch result {
            case .success(let value):
                let image = value.image.cropToSquare().withRenderingMode(.alwaysTemplate)
                self?.imageTitle.image = image
                self?.imageTitle.tintColor = UIColor(hexString: data.task?.fcolor ?? "")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        codePhone = Int(data.customer?.phone ?? "0") ?? 0
        contactPhone = Int(data.contact?.mobile ?? "0") ?? 0
        employeePhone = Int(data.seller?.mobile ?? "0") ?? 0
        
        viewAccount.isHidden = (data.account?.count ?? 0) < 1 ? true : false
    }
    
    @IBAction func buttonCodePhoneNumberTap(_ sender: Any) {
        if let url = URL(string: "tel://\(codePhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func buttonContactPhoneNumberTap(_ sender: Any) {
        if let url = URL(string: "tel://\(contactPhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func buttonEmployeePhoneNumberTap(_ sender: Any) {
        if let url = URL(string: "tel://\(employeePhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
