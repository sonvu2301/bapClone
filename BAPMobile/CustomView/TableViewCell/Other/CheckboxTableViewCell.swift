//
//  CheckboxTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 11/8/21.
//

import UIKit

protocol CheckboxStateDelegate {
    func checkbox(isCheck: Bool, id: Int)
}

class CheckboxTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var viewSeperate: UIView!
    
    var delegate: CheckboxStateDelegate?
    var isCheck = false
    var isWarehouse = false
    var item = BASmartCustomerCatalogItems()
    var itemWarehouse = BASmartDetailInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapAction))
        self.addGestureRecognizer(tap)
        // Initialization code
    }
    
    override func prepareForReuse() {
        checkBoxImage.image = UIImage(named: "ic_uncheck")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWarehouse(isCheck: Bool, item: BASmartDetailInfo) {
        let checkImg = UIImage(named: "ic_check")
        let uncheckImg = UIImage(named: "ic_uncheck")
        
        checkBoxImage.image = isCheck == true ? checkImg : uncheckImg
        labelContent.text = item.name
        self.isCheck = isCheck
        self.itemWarehouse = item
        isWarehouse = true
        viewSeperate.drawDottedLine(view: viewSeperate)
    }
    
    func setupCell(isCheck: Bool, item: BASmartCustomerCatalogItems) {
        let checkImg = UIImage(named: "ic_check")
        let uncheckImg = UIImage(named: "ic_uncheck")
        
        checkBoxImage.image = isCheck == true ? checkImg : uncheckImg
        labelContent.text = item.name
        self.isCheck = isCheck
        self.item = item
    }
    
    @objc func cellTapAction() {
        isCheck = !isCheck
        let checkImg = UIImage(named: "ic_check")
        let uncheckImg = UIImage(named: "ic_uncheck")
        
        checkBoxImage.image = isCheck == true ? checkImg : uncheckImg
        let id = isWarehouse == true ? itemWarehouse.id : item.id
        delegate?.checkbox(isCheck: isCheck, id: id ?? 0)
    }
    
}
