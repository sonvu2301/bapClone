//
//  SelectImageCollectionViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 6/14/21.
//

import UIKit
import Kingfisher

class SelectImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonDelete: UIButton!
    
    var delegate: UpdateImageDelegate?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFill
        blurView.isHidden = true
        // Initialization code
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage()
        buttonDelete.isHidden = false
        blurView.isHidden = true
    }
    
    func setupDataWithUrl(url: String, index: Int) {
        buttonDelete.isHidden = true
        let urlImage = URL(string: url)
        imageView.kf.setImage(with: urlImage)
    }
    
    func setupDataWithSavedAttach(saved: BASmartAttachs, index: Int) {
        let image = UIImage(data: saved.image ?? Data())
        self.index = index
        imageView.image = image
        blurView.isHidden = false
    }
    
    func setupData(image: UIImage, index: Int) {
        imageView.image = image
        self.index = index
        if index == -1 {
            buttonDelete.isHidden = true
        } else {
            buttonDelete.isHidden = false
        }
    }
    
    @IBAction func buttonDeleteTap(_ sender: Any) {
        delegate?.deleteImage(index: index)
    }
    
}
