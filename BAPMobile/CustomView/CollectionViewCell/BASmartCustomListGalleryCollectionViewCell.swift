//
//  BASmartCustomListGalleryCollectionViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/22/21.
//

import UIKit
import Kingfisher

class BASmartCustomListGalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var viewSaved: UIView!
    
    var deleteImageDelegate: DeleteSavedImageDelegate?
    var imageVehicle = BASmartVehicleImages()
    var imageAttach = BASmartAttachs()
    var isVehicle = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
    }

    override func prepareForReuse() {
        image.image = UIImage()
        viewSaved.isHidden = true
        contentView.removeBlurLoader()
    }
    
    
    func setupDataSaved(imageVehicle: BASmartVehicleImages, imageAttach: BASmartAttachs, isVehicle: Bool, hideViewSave: Bool) {
        self.isVehicle = isVehicle
        viewSaved.isHidden = hideViewSave
        if isVehicle {
            self.image.image = UIImage(data: imageVehicle.image ?? Data())?.cropToSquare()
            self.imageVehicle = imageVehicle
        } else {
            self.image.image = UIImage(data: imageAttach.image ?? Data())?.cropToSquare()
            self.imageAttach = imageAttach
        }
    }
    
    func setupData(smallLink: String, bigLink: String, size: CGFloat) {
        guard let url = URL.init(string: smallLink) else { return }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result) in
            switch result {
            case .success(let value):
                self?.image.image = value.image.cropToSquare()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func setupShowLoader(isLoading: Bool) {
        if isLoading {
            contentView.showBlurLoader()
        }
    }
    
    @IBAction func buttonDeleteTap(_ sender: Any) {
        let id = isVehicle == true ? imageVehicle.id : imageAttach.id
        deleteImageDelegate?.delete(id: Int(id), isVehicle: isVehicle)
    }
    
    
}
