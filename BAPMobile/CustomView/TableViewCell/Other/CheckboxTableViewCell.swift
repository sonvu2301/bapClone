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
    
    var delegate: CheckboxStateDelegate?
    var isCheck = false
    var item = BASmartCustomerCatalogItems()
    
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
        delegate?.checkbox(isCheck: isCheck, id: item.id ?? 0)
    }
    
}
