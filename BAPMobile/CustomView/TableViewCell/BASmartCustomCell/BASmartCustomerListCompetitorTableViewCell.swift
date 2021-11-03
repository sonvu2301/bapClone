//
//  BASmartCustomerListCompetitorTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/15/21.
//

import UIKit
import DropDown

struct BASmartCompetitorCellSource {
    var provider: String?
    var vehicleCount: Int?
    var level: String?
    var expireDate: Int?
    var price: String?
    var description: String?
    var isEdit: Bool?
}

class BASmartCustomerListCompetitorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boundView: UIView!
    
    @IBOutlet weak var labelProvider: UILabel!
    @IBOutlet weak var labelVehicleCount: UILabel!
    @IBOutlet weak var labelLevel: UILabel!
    @IBOutlet weak var labelExpireDate: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    
    var dropDown = DropDown()
    var data: BASmartCompetitorCellSource?
    var objectId = 0
    var delegate: BASmartCompetitorListDelegate?
    
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
        labelProvider.text = ""
        labelVehicleCount.text = ""
        labelLevel.text = ""
        labelExpireDate.text = ""
        labelPrice.text = ""
        labelDescription.text = ""
    }
    
    func setupData(data: BASmartCompetitorCellSource, objectId: Int) {
        self.data = data
        self.objectId = objectId
        labelProvider.text = data.provider
        labelVehicleCount.text = String(data.vehicleCount ?? 0)
        labelLevel.text = data.level
        labelExpireDate.text = Date().millisecToDate(time: data.expireDate ?? 0)
        labelPrice.text = data.price
        labelDescription.text = data.description
        buttonEdit.isHidden = !(data.isEdit ?? false)
    }
    
    @IBAction func buttonEditTap(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDown.deselectRow(at: index)
            switch index {
            case 0:
                self?.delegate?.edit(data: self?.data ?? BASmartCompetitorCellSource(), cellId: self?.objectId ?? 0)
            case 1:
                self?.delegate?.delete(objectId: self?.objectId ?? 0)
            default:
                break
            }
        }
    }
    
}
