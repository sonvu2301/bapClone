//
//  BASmartVehicleTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/25/21.
//

import UIKit

class BASmartVehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonCheckbox: UIButton!
  
    @IBOutlet weak var labelPlate: UILabel!
    @IBOutlet weak var labelDev: UILabel!
    @IBOutlet weak var labelImei: UILabel!
    
    var imageCheck = UIImage(named: "ic_check")
    var imageUncheck = UIImage(named: "ic_uncheck")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelDev.text = ""
        labelPlate.text = ""
        labelImei.text = ""
        
        buttonCheckbox.setImage(imageUncheck, for: .normal)
    }
    
    func setupData(data: BASmartVehicle, isCheck: Bool) {
        labelDev.text = data.dev
        labelPlate.text = data.plate
        labelImei.text = String(data.imei ?? 0)
        
        let image = isCheck == true ? imageCheck : imageUncheck
        buttonCheckbox.setImage(image, for: .normal)
    }
    
    
    @IBAction func buttonCheckboxTap(_ sender: Any) {
    }
    
    
}
