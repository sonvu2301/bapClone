//
//  BASmartComboFeatureTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 5/6/21.
//

import UIKit

class BASmartComboFeatureTableViewCell: UITableViewCell {

    @IBOutlet weak var seperateLine: UIView!
    @IBOutlet weak var buttonCheckbox: UIButton!
  
    var isChecked = false
    var isComboFeature = true
    var data = BASmartComboSaleModel()
    var delegate: SelectFeatureDelegate?
    var selectDelegate: CheckBoxSelectDelegate?
    var index = IndexPath()
    var flatIndex = 0
    var objectId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seperateLine.drawDottedLine(view: seperateLine)
        buttonCheckbox.titleLabel?.numberOfLines = 0
        buttonCheckbox.titleLabel?.lineBreakMode = .byWordWrapping
        buttonCheckbox.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        buttonCheckbox.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(isCheck: Bool, data: BASmartComboSaleModel, index: IndexPath) {
        checkboxState(isCheck: isCheck)
        isChecked = isCheck
        self.data = data
        self.index = index
        buttonCheckbox.setTitle("" + (data.name ?? ""), for: .normal)
    }
    
    func setupCheckbox(index: Int, id: Int, isCheck: Bool, name: String) {
        checkboxState(isCheck: isCheck)
        isChecked = isCheck
        flatIndex = index
        self.objectId = id
        buttonCheckbox.setTitle("" + (name), for: .normal)
    }
    
    func checkboxState(isCheck: Bool) {
        let uncheckImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        let checkImage = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        
        let image = isCheck == true ? checkImage : uncheckImage
        
        buttonCheckbox.setImage(image, for: .normal)
    }
    
    @IBAction func buttonCheckboxTap(_ sender: Any) {
        isChecked = !isChecked
        checkboxState(isCheck: isChecked)
        if isComboFeature {
            delegate?.selectedFeature(index: index,
                                      id: data.id ?? 0,
                                      state: isChecked)
        } else {
            selectDelegate?.selectedCheckbox(isSelect: isChecked,
                                             index: flatIndex,
                                             id: objectId)
        }
    }
    
    override func prepareForReuse() {
        buttonCheckbox.setImage(UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        buttonCheckbox.setTitle("", for: .normal)
    }
}
