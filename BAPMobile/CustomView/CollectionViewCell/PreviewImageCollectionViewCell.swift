//
//  PreviewImageCollectionViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/28/21.
//

import UIKit

class PreviewImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var blurView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        
        imageView.setViewCircle()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Initialization code
    }

    override func prepareForReuse() {
        imageView.image = UIImage()
        labelCount.text = ""
        blurView.isHidden = true
    }
    
    func setupData(image: UIImage, count: Int, selected: Int) {
        imageView.image = image
        labelCount.text = String(count + 1)
        if count == selected {
            labelCount.font = UIFont.boldSystemFont(ofSize: 25)
            blurView.isHidden = true
        } else {
            labelCount.font = UIFont.systemFont(ofSize: 18)
            blurView.isHidden = false
        }
    }
    
}
