//
//  BASmartSelectVTypeTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 4/29/21.
//

import UIKit

class BASmartSelectVTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonFirstCheckbox: UIButton!
    @IBOutlet weak var buttonSecondCheckbox: UIButton!
    
    @IBOutlet weak var firstSeperateLine: UIView!
    @IBOutlet weak var secondSeperateLine: UIView!
    @IBOutlet weak var secondItemView: UIView!
    
    var firstCellData = BASmartComboSaleModel()
    var secondCellData = BASmartComboSaleModel()
    var isFirstCheckbox = false
    var isSecondCheckbox = false
    var delegate: SelectVtypeStateDelegate?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstSeperateLine.drawDottedLine(view: firstSeperateLine)
        secondSeperateLine.drawDottedLine(view: secondSeperateLine)
        
        let image = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        buttonFirstCheckbox.setImage(image, for: .normal)
        buttonSecondCheckbox.setImage(image, for: .normal)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonFirstCheckboxTap(_ sender: Any) {
        isFirstCheckbox = !isFirstCheckbox
        checkboxState(button: buttonFirstCheckbox, state: isFirstCheckbox)
        delegate?.selectVtype(isSelected: isFirstCheckbox, index: index)
    }
    
    @IBAction func buttonSecondCheckboxTap(_ sender: Any) {
        isSecondCheckbox = !isSecondCheckbox
        checkboxState(button: buttonSecondCheckbox, state: isSecondCheckbox)
        delegate?.selectVtype(isSelected: isSecondCheckbox, index: index + 1)
    }
    
    private func checkboxState(button: UIButton, state: Bool) {
        let uncheckImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let checkImage = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        
        switch state {
        case true:
            button.setImage(checkImage, for: .normal)
        case false:
            button.setImage(uncheckImage, for: .normal)
        }
    }
    
    func setupData(first: BASmartComboSaleModel, second: BASmartComboSaleModel?, firstState: Bool, secondState: Bool, index: Int) {
        let uncheckImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let checkImage = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        isFirstCheckbox = firstState
        isSecondCheckbox = secondState
        self.index = index
        
        let firstCheckbox = isFirstCheckbox == true ? checkImage : uncheckImage
        let secondCheckbox = isSecondCheckbox == true ? checkImage : uncheckImage
        buttonFirstCheckbox.setImage(firstCheckbox, for: .normal)
        buttonSecondCheckbox.setImage(secondCheckbox, for: .normal)
        
        buttonFirstCheckbox.setTitle("  \((first.name ?? ""))", for: .normal)
        buttonSecondCheckbox.setTitle("  \((second?.name ?? ""))", for: .normal)
        
        firstCellData = first
        secondCellData = second ?? BASmartComboSaleModel()
        if second == nil {
            secondItemView.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        let checkboxImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        buttonFirstCheckbox.setImage(checkboxImage, for: .normal)
        buttonSecondCheckbox.setImage(checkboxImage, for: .normal)
        buttonFirstCheckbox.setTitle("", for: .normal)
        buttonSecondCheckbox.setTitle("", for: .normal)
        secondItemView.isHidden = false
    }
}
