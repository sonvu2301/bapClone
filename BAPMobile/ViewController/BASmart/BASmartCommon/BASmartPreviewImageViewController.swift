//
//  BASmartPreviewImageViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/28/21.
//

import UIKit
import CoreData

enum PreviewImageType {
    case saved, listed, selected
}

class BASmartPreviewImageViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    @IBOutlet weak var seperateLine: UIView!
    
    var blurDelegate: BlurBackgroundDelegate?
    var dataDelegate: AddAttachsDelegate?
    var finishDelegate: ReloadDataDelegate?
    var blurBackgroundDelegate: BlurViewDelegate?
    var images = [UIImage]()
    var name = ""
    var selected = 0
    var taskId = 0
    var objectId = 0
    var previewType = PreviewImageType.saved
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Hình ảnh"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        blurDelegate?.blurBackgroundAction(isShow: false)
        blurBackgroundDelegate?.hideBlur()
    }
    
    private func setupView() {
        collectionView.register(UINib(nibName: "PreviewImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PreviewImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        
        imageView.image = images.first
        
        buttonCancel.layer.borderColor = UIColor.lightGray.cgColor
        buttonCancel.layer.borderWidth = 1
        
        buttonCancel.setViewCorner(radius: 5)
        buttonSave.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        seperateLine.drawDottedLine(view: seperateLine)
        
        switch previewType {
        case .saved:
            buttonSave.isHidden = true
            buttonConfirm.setTitle("XÁC NHẬN", for: .normal)
            buttonConfirm.backgroundColor = UIColor().defaultColor()
        case .listed:
            buttonSave.isHidden = true
            buttonConfirm.setTitle("HỦY", for: .normal)
            buttonConfirm.backgroundColor = .red
        case .selected:
            break
        }
        
        if images.count == 1 {
            collectionView.isHidden = true
        }
        
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        imageView.layer.cornerRadius = 11.0
        imageView.clipsToBounds = false
        
    }
    
    
    private func removeAttach() {
        let param = BASmartDeleteAttachParam(task: taskId,
                                             objectId: objectId)
        
        Network.shared.BASmartDeleteFileAttach(param: param) { [weak self] (data) in
            if data?.errorCode != 0 && data?.errorCode != nil {
                self?.presentBasicAlert(title: data?.message ?? "",
                                        message: "",
                                        buttonTittle: "Đồng ý")
            } else {
                self?.finishDelegate?.reload()
                self?.blurDelegate?.blurBackgroundAction(isShow: false)
                self?.blurBackgroundDelegate?.hideBlur()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func saveAttach() {
        var imgs = [UIImage]()
        images.forEach { (item) in
            imgs.append(item.resizeImageWithRate())
        }
        
        let imageData = imgs.map({$0.pngData()})
        var count = 0
        imageData.forEach { [weak self] (data) in
            count += 1
            let id = Int(Date.timeIntervalSinceReferenceDate) + count
            CoreDataBASmart.shared.insertAttach(name: self?.name ?? "",
                                                image: data ?? Data(),
                                                id: Int64(id))
            if count == images.count {
                self?.dataDelegate?.saveAttach()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.blurBackgroundAction(isShow: false)
        blurBackgroundDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonSaveTap(_ sender: Any) {
        saveAttach()
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        //Show listed image
        switch previewType {
        case .saved:
            dataDelegate?.addAttachs(images: images, descrip: "", savedId: objectId)
            blurDelegate?.blurBackgroundAction(isShow: false)
            blurBackgroundDelegate?.hideBlur()
            dismiss(animated: true, completion: nil)
            
        case .selected:
            dataDelegate?.addAttachs(images: images, descrip: "", savedId: 0)
            blurDelegate?.blurBackgroundAction(isShow: false)
            blurBackgroundDelegate?.hideBlur()
            dismiss(animated: true, completion: nil)
            
        case .listed:
            let alert = UIAlertController(title: "XÁC NHẬN", message: "Bạn có chắc chắn muốn hủy đính kèm này không?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "XÁC NHẬN", style: .default, handler: { [weak self] (action) in
                self?.removeAttach()
            }))
            alert.addAction(UIAlertAction(title: "BỎ QUA", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension BASmartPreviewImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension BASmartPreviewImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
