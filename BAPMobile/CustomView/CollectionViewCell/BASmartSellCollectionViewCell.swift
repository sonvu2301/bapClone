//
//  BASmartSellCollectionViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/4/21.
//

import UIKit

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

}
