//
//  BASmartCustomerSellOptionTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 4/28/21.
//

import UIKit

class BASmartCustomerSellOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonCheckbox: UIButton!
    
    @IBOutlet weak var seperateLine: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    var delegate: SelectCustomerSellOptionDelegate?
    var data = BASmartComboSaleCustomerCommon()
    var isChecked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        seperateLine.drawDottedLine(view: seperateLine)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupData(name: String, price: String, item: BASmartComboSaleCustomerCommon) {
        labelPrice.text = price + " đ"
        labelName.text = name
        data = item
    }
    
    @IBAction func buttonCheckboxTap(_ sender: Any) {
        let unselectedImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        let selectedImage = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        isChecked = !isChecked
        let image = isChecked == true ? selectedImage : unselectedImage
        buttonCheckbox.setImage(image, for: .normal)
        
        delegate?.selectRow(item: data, isSelect: isChecked)
    }
    
    override func prepareForReuse() {
        buttonCheckbox.setImage(UIImage(named: ""), for: .normal)
        labelName.text = ""
        labelPrice.text = ""
    }
}
