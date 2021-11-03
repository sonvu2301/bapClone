//
//  BASmartWarrantyAttachViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/22/21.
//

import UIKit
import DKImagePickerController
import Kingfisher

protocol AddAttachsDelegate {
    func addAttachs(images: [UIImage], descrip: String, savedId: Int)
    func saveAttach()
}

class BASmartWarrantyAttachViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var task = BASmartTaskData()
    var data = [BASmartFileAttach]()
    var images = [UIImage]()
    var finishDelegate: ReloadDataDelegate?
    var loadingDelegate: LoadingDelegate?
    var blurBackground: BlurBackgroundDelegate?
    var savedAttach = [BASmartAttachs]()
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setupView() {

        collectionView.register(UINib(nibName: "SelectImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.reloadData()
        
    }
    
    func getSavedAttachs(name: String) {
        savedAttach = [BASmartAttachs]()
        savedAttach = CoreDataBASmart.shared.getAttach().filter({($0.name?.contains(name) ?? false) && $0.userName == UserInfo.shared.userName})
        collectionView.reloadData()
    }
    
    private func showPreviewImages(images: [UIImage], isPreviewListedImage: PreviewImageType, objectId: Int?) {
        let storyBoard = UIStoryboard(name: "BASmartWarranty", bundle: nil)
        
        let popoverContent = (storyBoard.instantiateViewController(withIdentifier: "BASmartPreviewImageViewController") ) as! BASmartPreviewImageViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
        popoverContent.images = images
        popoverContent.dataDelegate = self
        popoverContent.blurDelegate = self
        popoverContent.taskId = task.id ?? 0
        popoverContent.objectId = objectId ?? 0
        popoverContent.finishDelegate = finishDelegate
        popoverContent.previewType = isPreviewListedImage
        popoverContent.name = name
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        blurBackground?.blurBackgroundAction(isShow: true)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func showImage(urlString: String, id: Int, type: PreviewImageType) {
        guard let url = URL.init(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url)
        images = [UIImage]()
        KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result) in
            switch result {
            case .success(let value):
                self?.images.append(value.image)
                self?.showPreviewImages(images: self?.images ?? [UIImage](), isPreviewListedImage: type, objectId: id)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}

extension BASmartWarrantyAttachViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = data.count + savedAttach.count

        return (section * 4) <= number - 4 ? 4 : number - ( (section) * 4 )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
        let index = indexPath.section * 4 + indexPath.row
        
        if index < data.count {
        let dataParse = data[index]
            cell.setupDataWithUrl(url: dataParse.small ?? "",
                                  index: indexPath.row)
        } else {
            cell.setupDataWithSavedAttach(saved: savedAttach[index - data.count],
                                          index: index)
            cell.delegate = self
        }
        
        return cell
    }
    
    private func setupPreviewImages(type: DKImagePickerControllerSourceType) {
        let pickerController = DKImagePickerController()
        pickerController.modalPresentationStyle = .fullScreen
        pickerController.sourceType = type
        images = [UIImage]()
        var count = 0
        pickerController.didSelectAssets = { [weak self] (assets: [DKAsset]) in
            assets.forEach { (item) in
                item.fetchOriginalImage { (image, nil) in
                    self?.images.append(image ?? UIImage())
                    if type == .photo {
                        count += 1
                        if count == assets.count {
                            self?.showPreviewImages(images: self?.images ?? [UIImage](), isPreviewListedImage: .selected, objectId: 0)
                        }
                    } else {
                        self?.showPreviewImages(images: self?.images ?? [UIImage](), isPreviewListedImage: .selected, objectId: 0)
                    }
                }
            }
        }
        self.present(pickerController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row + (indexPath.section * 4)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                setupPreviewImages(type: .camera)
            case 1:
                setupPreviewImages(type: .photo)
            default:
                collectionSelect(index: index)
            }
        default:
            collectionSelect(index: index)
        }
    }
    
    private func collectionSelect(index: Int) {
        if index < data.count {
            showImage(urlString: data[index].full ?? "", id: data[index].objectId ?? 0, type: .listed)
        } else {
            var images = [UIImage]()
            let id = savedAttach[index - data.count].id
            images.append(UIImage(data: savedAttach[index - data.count].image ?? Data()) ?? UIImage())
            showPreviewImages(images: images, isPreviewListedImage: .saved, objectId: Int(id))
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let number = data.count + savedAttach.count
        return number % 4 == 0 ? number / 4 : number / 4 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = Int((collectionView.frame.width - 8) / 4)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension BASmartWarrantyAttachViewController: AddAttachsDelegate {
    func addAttachs(images: [UIImage], descrip: String, savedId: Int) {
        var imgs = [UIImage]()
        images.forEach { (item) in
            imgs.append(item.resizeImageWithRate())
        }
        uploadAttachs(images: imagesToBase64(images: imgs), id: savedId)
    }
    
    func saveAttach() {
        getSavedAttachs(name: name)
    }
    
    private func uploadAttachs(images: [String], id: Int) {
        let taskParam = BASmartUploadAttachTaskInfo(task: task.id,
                                                    partner: task.kind,
                                                    number: task.taskNumber)
        
        var files = [BASmartFileAttachParam]()
        images.forEach { (item) in
            files.append(BASmartFileAttachParam(imgdata: item))
        }
        
        let param = BASmartUploadAttachParam(task: taskParam,
                                             file: files)
        
        loadingDelegate?.showLoading()
        Network.shared.BASmartUploadFileAttach(param: param) { [weak self] (data) in
            self?.finishDelegate?.reload()
            CoreDataBASmart.shared.deleteAttach(id: id)
        }
    }
}

extension BASmartWarrantyAttachViewController: BlurBackgroundDelegate {
    func blurBackgroundAction(isShow: Bool) {
        if !isShow {
            blurBackground?.blurBackgroundAction(isShow: false)
        }
    }
}

extension BASmartWarrantyAttachViewController: UpdateImageDelegate {
    func deleteImage(index: Int) {
        let id = savedAttach[index - data.count].id
        CoreDataBASmart.shared.deleteAttach(id: Int(id))
        getSavedAttachs(name: name)
    }
    
    func addImage() {
        
    }
}
