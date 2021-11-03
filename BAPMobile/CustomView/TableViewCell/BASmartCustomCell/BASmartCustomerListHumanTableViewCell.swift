//
//  BASmartCustomerListHumanTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/14/21.
//

import UIKit
import DropDown

struct BASmartHumanCellSource {
    var name: String?
    var kind: String?
    var position: String?
    var birth: String?
    var email: String?
    var facebook: String?
    var marriage: String?
    var gender: String?
    var religion: String?
    var ethnic: String?
    var hobbit: String?
    var phone: String?
}

class BASmartCustomerListHumanTableViewCell: UITableViewCell {

    @IBOutlet weak var boundView: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelKind: UILabel!
    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var labelBirth: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelFacebook: UILabel!
    @IBOutlet weak var labelMarriage: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelReligion: UILabel!
    @IBOutlet weak var labelEthnic: UILabel!
    @IBOutlet weak var labelHobit: UILabel!
    
    @IBOutlet weak var buttonPhoneNumber: UIButton!
    @IBOutlet weak var buttonPhoneIcon: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    
    var dropDown = DropDown()
    var data: BASmartHumanCellSource?
    var delegate: BASmartHumanListDelegate?
    var callDelegate: BASmartGetPhoneNumberDelegate?
    var objectId = 0
    var kindId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boundView.setViewCorner(radius: 10)
        boundView.layer.borderWidth = 1
        boundView.layer.borderColor = UIColor().defaultColor().cgColor
        dropDown.dataSource = ["Sửa thông tin",
                               "Xóa Dữ Liệu"]
        dropDown.width = 200
        dropDown.direction = .bottom
        dropDown.anchorView = buttonEdit
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.cellNib = UINib(nibName: "BasicDropdownTableViewCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? BasicDropdownTableViewCell else { return }
            
            switch index {
            case 0:
                cell.logoImageView.image = UIImage(named: "edit")
            case 1:
                cell.logoImageView.image = UIImage(named: "delete")
            default:
                cell.logoImageView.image = UIImage(named: "")
            }
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelName.text = ""
        labelKind.text = ""
        labelPosition.text = ""
        labelBirth.text = ""
        labelEmail.text = ""
        labelFacebook.text = ""
        labelMarriage.text = ""
        labelGender.text = ""
        labelReligion.text = ""
        labelEthnic.text = ""
        labelHobit.text = ""
        buttonPhoneNumber.setTitle("", for: .normal)
    }
    
    func setupData(data: BASmartHumanCellSource, objectId: Int, kindId: Int) {
        self.data = data
        labelName.text = data.name
        labelKind.text = data.kind
        labelPosition.text = data.position
        labelBirth.text = data.birth
        labelEmail.text = data.email
        labelFacebook.text = data.facebook
        labelMarriage.text = data.marriage
        labelGender.text = data.gender
        labelReligion.text = data.religion
        labelEthnic.text = data.ethnic
        labelHobit.text = data.hobbit
        buttonPhoneNumber.setTitle(data.phone, for: .normal)
        
        self.objectId = objectId
        self.kindId = kindId
    }
    
    @IBAction func buttonEditTap(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDown.deselectRow(at: index)
            switch index {
            case 0:
                self?.delegate?.edit(data: self?.data ?? BASmartHumanCellSource(), objectId: self?.objectId ?? 0)
            case 1:
                self?.delegate?.delete(objectId: self?.objectId ?? 0)
            default:
                break
            }
        }
    }
    
    @IBAction func buttonCallTap(_ sender: Any) {
        callDelegate?.getPhoneNumber(objectId: objectId, kindId: kindId)
    }
    
}
