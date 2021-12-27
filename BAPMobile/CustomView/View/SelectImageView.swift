//
//  SelectImageView.swift
//  BAPMobile
//
//  Created by Emcee on 6/14/21.
//

import UIKit
import Kingfisher

protocol UpdateImageDelegate {
    func deleteImage(index: Int)
    func addImage()
}

class SelectImageView: UIView {

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: UpdateImageDelegate?
    var imageUrls = [String]()
    var images = [UIImage]()
    var isShowOnly = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("SelectImageView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        collectionView.register(UINib(nibName: "SelectImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        self.layoutIfNeeded()
    }
    
    func resetView() {
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        self.layoutIfNeeded()
    }
    
}

extension SelectImageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = images.count + 1
        return (section * 3) <= number - 3 ? 3 : number - ( (section) * 3 )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
        let index = (indexPath.section * 3 + indexPath.row) - 1
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.setupData(image: UIImage(named: "icon_camera") ?? UIImage(), index: -1)
        } else {
            cell.setupData(image: images[index], index: index)
        }
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            delegate?.addImage()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let number = images.count + 1
        return number % 3 == 0 ? number / 3 : number / 3 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 12 ) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 4, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SelectImageView: UpdateImageDelegate {
    func addImage() {
    }
    
    func deleteImage(index: Int) {
        images.remove(at: index)
        collectionView.reloadData()
        resetView()
    }
}

