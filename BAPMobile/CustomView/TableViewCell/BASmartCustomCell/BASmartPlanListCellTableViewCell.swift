//
//  BASmartPlanListCellTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 3/10/21.
//

import UIKit
import Kingfisher
import DropDown

class BASmartPlanListCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var viewCreator: UIView!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPurpose: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelCreatorName: UILabel!
    
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var buttonPhone: UIButton!
    @IBOutlet weak var buttonCreatorPhone: UIButton!
    
    var objectId = 0
    var createPhone = 0
    var data = BASmartPlanListData()
    var dropDown = DropDown()
    var delegate: BASmartPlanMenuActionDelegate?
    var menuList = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boundView.setViewCorner(radius: 10)
        boundView.layer.borderWidth = 1
        boundView.layer.borderColor = UIColor().defaultColor().cgColor
        dropDown.anchorView = buttonMenu
        dropDown.width = 200
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        let phoneImage = UIImage(named: "ic_tel_01")?.resizeImage(targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        buttonPhone.setImage(phoneImage, for: .normal)
        buttonPhone.tintColor = UIColor().defaultColor()
        buttonCreatorPhone.setImage(phoneImage, for: .normal)
        buttonCreatorPhone.tintColor = UIColor().defaultColor()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        iconImage.image = UIImage()
        labelTitle.text = ""
        labelStartTime.text = ""
        labelEndTime.text = ""
        labelAddress.text = ""
        labelPurpose.text = ""
        labelDescription.text = ""
        labelCreatorName.text = ""
        viewCreator.isHidden = true
    }
    
    func setupDate(data: BASmartPlanListData?, image: String, title: String, start: Int, end: Int, address: String, purpose: [BASmartDetailInfo], description: String, state: String, isMenu: Bool) {
        if isMenu == false {
            buttonMenu.isHidden = true
        }
        let url = URL(string: image)
        iconImage.kf.setImage(with: url)
        iconImage.setImageColor(color: UIColor(hexString: data?.stateInfo?.fcolor ?? "FFFFFF"))
        self.data = data ?? BASmartPlanListData()
        labelTitle.text = title
        labelStartTime.text = Date().millisecToHourMinute(time: start)
        labelEndTime.text = Date().millisecToHourMinute(time: end)
        labelAddress.text = address
        labelDescription.text = description
        labelState.text = state
        var purposeString = ""
        if purpose.count > 0 {
            purpose.forEach { (item) in
                purposeString += ( ( item.name ?? "" ) + ", " )
            }
        }
        if purposeString.count > 0 {
            purposeString = String(purposeString.dropLast())
            purposeString = String(purposeString.dropLast())
        }
        
        labelPurpose.text = purposeString
        menuList = data?.menuAction?.map({($0.id ?? 0)}) ?? [Int]()
        setupDropdown()
        
        topView.backgroundColor = UIColor(hexString: data?.stateInfo?.bcolor ?? "FFFFFF")
        boundView.layer.borderColor = UIColor(hexString: data?.stateInfo?.bcolor ?? "FFFFFF").cgColor
        labelTitle.textColor = UIColor(hexString: data?.stateInfo?.fcolor ?? "FFFFFF")
        
        buttonPhone.setTitle("  \(data?.phone ?? "")", for: .normal)
        objectId = data?.planId ?? 0
        
        if data?.creatorInfo?.name != nil {
            buttonCreatorPhone.setTitle(" \(data?.creatorInfo?.mobile ?? "")", for: .normal)
            labelCreatorName.text = data?.creatorInfo?.name
            createPhone = (Int(data?.creatorInfo?.mobile ?? "") ?? 0)
            viewCreator.isHidden = false
        } else {
            viewCreator.isHidden = true
        }
    }
    
    private func setupDropdown() {
        dropDown.dataSource = data.menuAction?.map({$0.name ?? ""}) ?? [String]()
        
        dropDown.cellNib = UINib(nibName: "BasicDropdownTableViewCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? BasicDropdownTableViewCell else { return }
            let url = URL(string: self.data.menuAction?[index].icon ?? "")
            cell.logoImageView.kf.setImage(with: url)
        }
    }
    
    @IBAction func buttonMenuTap(_ sender: Any) {
        dropDown.show()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDown.deselectRow(index)
            switch self?.menuList[index] {
            case BASmartPlanMenuAction.signin_approach.id:
                self?.buttonTapAction(action: .signin_approach)
            case BASmartPlanMenuAction.update.id:
                self?.buttonTapAction(action: .update)
            case BASmartPlanMenuAction.receive.id:
                self?.buttonTapAction(action: .receive)
            case BASmartPlanMenuAction.abort.id:
                self?.buttonTapAction(action: .abort)
            case BASmartPlanMenuAction.approach_result.id:
                self?.buttonTapAction(action: .approach_result)
            case BASmartPlanMenuAction.customer_info.id:
                self?.buttonTapAction(action: .customer_info)
            default:
                break
            }
        }
    }
    
    private func buttonTapAction(action: BASmartPlanMenuAction) {
        delegate?.menuAction(action: action, data: data)
    }
    
    @IBAction func buttonPhoneTap(_ sender: Any) {
        delegate?.buttonCallTap(objectId: objectId)
    }
    
    @IBAction func buttonPhoneCreatorTap(_ sender: Any) {
        if let url = URL(string: "tel://\(createPhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}
