//
//  BASmartSupporterListTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/3/21.
//

import UIKit

class BASmartSupporterListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewSeperate: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonCheckbox: UIButton!
    
    var state = false
    var isReason = false
    var index = 0
    var delegate: SelectCheckBoxDelegate?
    
    let imageCheck = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 30, height: 30))
    let imageUncheck = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 30, height: 30))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewSeperate.drawDottedLine(view: viewSeperate)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCell))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tap)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(supporterData: BASmartUtilitySupportData?, state: Bool, index: Int, isReason: Bool, reasonData: BASmartCustomerCatalogItems?) {
        self.isReason = isReason
        if isReason {
            labelName.text = reasonData?.name
        } else {
            labelName.text = "\((supporterData?.fullName ?? "")) (\((supporterData?.userName ?? "")))"
        }
        self.state = state
        self.index = index
        
        let image = state == true ? imageCheck : imageUncheck
        buttonCheckbox.setImage(image, for: .normal)
    }
    
    override func prepareForReuse() {
        labelName.text = ""
    }
    
    @IBAction func buttonCheckboxTap(_ sender: Any) {
        tapCell()
    }
    
    @objc func tapCell() {
        state = !state
        let image = state == true ? imageCheck : imageUncheck
        buttonCheckbox.setImage(image, for: .normal)
        
        delegate?.selectAction(state: state, index: index)
    }
    
}
