//
//  BASmartSellCollectionViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/4/21.
//

import UIKit
import Kingfisher

class BASmartSellCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
    }
    
    override func prepareForReuse() {
        image.image = UIImage()
    }
    
    
    func setupData(imageUrl: String, isSquare: Bool) {
        guard let url = URL.init(string: imageUrl) else { return }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result) in
            switch result {
            case .success(let value):
                if isSquare {
                    self?.image.image = value.image.cropToSquare()
                } else {
                    self?.image.image = value.image
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

}
