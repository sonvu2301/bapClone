//
//  BASmartTechnicalCarListTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/22/21.
//

import UIKit
import Kingfisher

class BASmartTechnicalCarListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBound: UIView!
    @IBOutlet weak var viewId: UIView!
    @IBOutlet weak var seperateView: UIView!
    
    @IBOutlet weak var imageId: UIImageView!
    
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelDeviceName: UILabel!
    @IBOutlet weak var labelImei: UILabel!
    
    var data = BASmartVehicle()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBound.layer.borderWidth = 1
        viewBound.layer.borderColor = UIColor.black.cgColor
        viewBound.setViewCorner(radius: 5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(data: BASmartVehicle) {
        
        viewId.backgroundColor = UIColor(hexString: data.display?.bcolor ?? "")
        labelId.text = data.plate
        labelId.textColor = UIColor(hexString: data.display?.fcolor ?? "")
        labelDeviceName.text = data.dev
        labelImei.text = String(data.imei ?? 0)
        
        self.data = data
        //Setup image
        guard let url = URL.init(string: data.display?.icon ?? "") else { return }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result) in
            switch result {
            case .success(let value):
                let image = value.image.withRenderingMode(.alwaysTemplate)
                self?.imageId.image = image
                self?.imageId.tintColor = UIColor(hexString: data.display?.fcolor ?? "")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}
