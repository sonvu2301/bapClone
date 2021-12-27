//
//  BASmartInventoryDetailTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 11/18/21.
//

import UIKit

class BASmartInventoryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var viewSerial: UIView!
    
    @IBOutlet weak var labelSerial: UILabel!
    @IBOutlet weak var labelKind: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelImei: UILabel!
    
    var data = BASmartInventoryDetailImei()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        labelSerial.text = ""
        labelKind.text = ""
        labelDate.text = ""
        viewSerial.backgroundColor = UIColor(hexString: "F0F0F0")
        labelSerial.textColor = .black
        labelImei.textColor = UIColor(hexString: "F0F0F0")
        
        let attr = NSMutableAttributedString(attributedString: (labelImei?.attributedText)!)
        let originalRange = NSMakeRange(0, attr.length)
        attr.setAttributes([:], range: originalRange)
        labelImei?.attributedText = attr
        labelImei?.attributedText = NSMutableAttributedString(string: "", attributes: [:])
        labelImei?.text = ""
    }
    
    func setupData(data: BASmartInventoryDetailImei, index: Int) {
        self.data = data
        let state = data.state
        
        labelSerial.text = "\(index + 1)"
        labelKind.text = data.kind
        labelDate.text = Date().millisecToDate(time: data.time ?? 0)
        
        let trueStateColor = UIColor(hexString: "F0F0F0")
        let falseStateColor = UIColor(hexString: "b82424")
        
        viewSerial.backgroundColor = state == true ? trueStateColor : falseStateColor
        labelSerial.textColor = state == true ? .black : .white
        labelImei.textColor = state == true ? .black : falseStateColor

        if !(state ?? false) {
            labelImei.attributedText = data.imei?.strikeThrough()
        } else {
            labelImei.attributedText = data.imei?.removeStrikeThrough()
        }
    }
    
}
