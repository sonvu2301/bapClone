//
//  MenuCollectionViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 12/7/20.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        cornerView.layer.masksToBounds = true
        cornerView.layer.cornerRadius = 10
        cornerView.layer.borderColor = UIColor().defaultColor().cgColor
        cornerView.layer.borderWidth = 1.5
        dotImage.tintColor = .orange
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        imageView.image = UIImage()
    }
}
