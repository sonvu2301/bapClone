//
//  BASmartSelectCustomerModelTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 10/19/21.
//

import UIKit

class BASmartSelectCustomerModelTableViewCell: UITableViewCell {

    @IBOutlet weak var seperateView: UIView!
    
    @IBOutlet weak var buttonSelect: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var buttonPlus: UIButton!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    
    var quantity = 1
    var rowInfo = BASmartCustomerCatalogItems()
    var isSelectCell = false
    var delegate: BASmartCustomerChangeModelDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonPlus.setViewCircle()
        buttonMinus.setViewCircle()
        seperateView.drawDottedLine(view: seperateView)
        
        buttonMinus.isHidden = !isSelectCell
        buttonPlus.isHidden = !isSelectCell
        labelQuantity.isHidden = !isSelectCell
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelName.text = ""
        labelQuantity.text = "0"
        buttonSelect.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        buttonMinus.isHidden = true
        buttonPlus.isHidden = true
        labelQuantity.isHidden = true
    }
    
    func setupData(name: BASmartCustomerCatalogItems) {
        rowInfo = name
        labelName.text = rowInfo.name
    }
    
    func setupQuantity(data: BASmartCustomerModel) {
        isSelectCell = true
        quantity = data.ri ?? 1
        setupView()
    }
    
    private func setupView(){
        buttonMinus.isHidden = !isSelectCell
        buttonPlus.isHidden = !isSelectCell
        labelQuantity.isHidden = !isSelectCell
        let imageSelect = UIImage(named: "ic_check")
        let imageDeselect = UIImage(named: "ic_uncheck")
        let image = isSelectCell == true ? imageSelect : imageDeselect
        buttonSelect.setImage(image, for: .normal)
        labelQuantity.text = "\(quantity)"
    }
    
    @IBAction func buttonSelectTap(_ sender: Any) {
        isSelectCell = !isSelectCell
        setupView()
        delegate?.selectModel(isSelect: isSelectCell, id: rowInfo.id ?? 0)
    }
    
    @IBAction func buttonPlusTap(_ sender: Any) {
        quantity += 1
        labelQuantity.text = "\(quantity)"
        delegate?.changeQuantity(isPlus: true, id: rowInfo.id ?? 0)
    }
    
    @IBAction func buttonMinusTap(_ sender: Any) {
        if quantity > 1 {
            quantity -= 1
            labelQuantity.text = "\(quantity)"
            delegate?.changeQuantity(isPlus: false, id: rowInfo.id ?? 0)
        }
    }
    
}
