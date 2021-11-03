//
//  BASmartVehiclePreviewImageFirstViewController.swift
//  BAPMobile
//
//  Created by Emcee on 7/9/21.
//

import UIKit
import DropDown

enum TypeOfTime {
    case before, after
    
    var name: String {
        switch self {
        case .before:
            return "Trước triển khai"
        case .after:
            return "Sau triển khai"
        }
    }
}

class BASmartVehiclePreviewImageFirstViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewTimeInfo: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCodeInfo: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewTimeSelect: UIView!
    @IBOutlet weak var viewCodeSelect: UIView!
    @IBOutlet weak var viewBoundCode: UIView!
    
    @IBOutlet weak var buttonBefore: UIButton!
    @IBOutlet weak var buttonAfter: UIButton!
    @IBOutlet weak var buttonCode: UIButton!
    @IBOutlet weak var buttonIsSelectCode: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let dropDown = DropDown()
    
    var type = VehiclePreviewImageType.list
    var selectTypeTimeDelegate: SelectTimeTypeDelegate?
    var images = [UIImage]()
    var code = ""
    var time = ""
    var selected = 0
    
    var isSelectedCode = true
    var isBefore = false
    
    let imageUncheck = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
    let imageCheckDot = UIImage(named: "dot_blue")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
    let imageCheck = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupView(type: VehiclePreviewImageType) {
        
        collectionView.register(UINib(nibName: "PreviewImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PreviewImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        
        if images.count > 0 {
            imageView.image = images[0]
        }
        
        if images.count < 2 {
            collectionView.isHidden = true
        }
        
        
        
        switch type {
        case .list:
            viewTimeSelect.isHidden = true
            viewCodeSelect.isHidden = true
            viewTimeInfo.setupView(title: "Thời điểm",
                                   placeholder: "",
                                   isNumberOnly: false,
                                   content: time,
                                   isAllowSelect: false,
                                   isPhone: false,
                                   isUsingLabel: false)
            
            viewCodeInfo.setupView(title: "Mã phiếu",
                                   placeholder: "",
                                   isNumberOnly: false,
                                   content: code,
                                   isAllowSelect: false,
                                   isPhone: false,
                                   isUsingLabel: false)
        case .create, .saved:
            viewTimeInfo.isHidden = true
            viewCodeInfo.isHidden = true
            viewBoundCode.layer.borderWidth = 1
            viewBoundCode.layer.borderColor = UIColor.black.cgColor
            viewBoundCode.setViewCorner(radius: 5)
            buttonAfter.setImage(imageCheckDot, for: .normal)
            buttonBefore.setImage(imageUncheck, for: .normal)
            buttonIsSelectCode.setImage(imageCheck, for: .normal)
            
            buttonCode.setTitle(code, for: .normal)
            dropDown.dataSource = [code]
            dropDown.anchorView = buttonCode
            dropDown.width = buttonCode.frame.width - 30
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            
            if time == TypeOfTime.before.name {
                buttonAfter.setImage(imageUncheck, for: .normal)
                buttonBefore.setImage(imageCheckDot, for: .normal)
            }
        }
    }
    
    private func selectedTime(isBefore: Bool) {
        switch isBefore {
        case true:
            buttonAfter.setImage(imageUncheck, for: .normal)
            buttonBefore.setImage(imageCheckDot, for: .normal)
        case false:
            buttonAfter.setImage(imageCheckDot, for: .normal)
            buttonBefore.setImage(imageUncheck, for: .normal)
        }
        
        self.isBefore = isBefore
    }
    
    @IBAction func buttonBeforeTap(_ sender: Any) {
        selectedTime(isBefore: true)
        selectTypeTimeDelegate?.selectType(isBefore: true)
    }
    
    @IBAction func buttonAfterTap(_ sender: Any) {
        selectedTime(isBefore: false)
        selectTypeTimeDelegate?.selectType(isBefore: false)
    }
    
    @IBAction func buttonCodeTap(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.buttonCode.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func buttonIsSelectCodeTap(_ sender: Any) {
        isSelectedCode = !isSelectedCode
        let image = isSelectedCode ? imageCheck : imageUncheck
        buttonIsSelectCode.setImage(image, for: .normal)
        buttonCode.isUserInteractionEnabled = isSelectedCode
    }
    
}

extension BASmartVehiclePreviewImageFirstViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewImageCollectionViewCell", for: indexPath) as! PreviewImageCollectionViewCell
        let index = indexPath.row
        
        cell.setupData(image: images[index], count: index, selected: selected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        selected = index
        imageView.image = images[index]
        scrollView.zoomScale = 1
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.height
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

