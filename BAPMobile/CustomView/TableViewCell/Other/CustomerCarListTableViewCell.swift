//
//  CustomerCarListTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 12/18/20.
//

import UIKit

class CustomerCarListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var buttonCheckbox: UIButton!
    @IBOutlet weak var labelVehiclePlate: UILabel!
    @IBOutlet weak var labelGPSTime: UILabel!
    @IBOutlet weak var labelLockState: UILabel!
    @IBOutlet weak var labelExtendTime: UILabel!
    @IBOutlet weak var labelTotalDay: UILabel! 
    @IBOutlet weak var labelState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonCheckboxTap(_ sender: Any) {
    }
    
    func setupData(vehicle: String, gps_time: String, lock_state: String, extend_time: String, total_day: String, mc_flag: Bool, bt_flag: Bool, sc_flag: Bool, grf_flag: Bool) {
        labelVehiclePlate.text = vehicle
        labelGPSTime.text = gps_time
        labelLockState.text = lock_state
        labelExtendTime.text = extend_time
        labelTotalDay.text = "(\(total_day) ngày)"
        if !grf_flag {
            buttonCheckbox.isHidden = true
        }
        //Add all true flag
        var flagArray = [String]()
        if mc_flag {
            flagArray.append("MC")
        }
        if bt_flag {
            flagArray.append("BT")
        }
        if sc_flag {
            flagArray.append("SC")
        }
        
        flagArray.forEach { (item) in
            labelState.text = item == flagArray[0] ? item : "\(labelState.text ?? "")\n\(item)"
        }
    }
    
    override func prepareForReuse() {
        labelVehiclePlate.text = ""
        labelGPSTime.text = ""
        labelLockState.text = ""
        labelExtendTime.text = ""
        labelTotalDay.text = ""
        labelState.text = ""
        buttonCheckbox.isHidden = false
        buttonCheckbox.setImage(UIImage(named: "ic_uncheck"), for: .normal)
    }
}


