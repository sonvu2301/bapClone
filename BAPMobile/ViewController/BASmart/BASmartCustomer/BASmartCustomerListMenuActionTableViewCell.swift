//
//  BASmartCustomerListMenuActionTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/21/21.
//

import UIKit
import Kingfisher
class BASmartCustomerListMenuActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        iconImage.image = UIImage()
    }
    
    func setupData(urlImage: String, title: String) {
        titleLabel.text = title
        guard let url = URL.init(string: urlImage) else { return }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result) in
            switch result {
            case .success(let value):
                self?.iconImage.image = value.image
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}
