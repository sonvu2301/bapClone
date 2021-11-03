//
//  BASmartCustomerListGalleryViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/22/21.
//

import UIKit
import DKImagePickerController
import Kingfisher

enum PhotoListType {
    case warranty, customer
}

protocol ShowLoadingDelegate {
    func show()
    func hide()
}

protocol DeleteSavedImageDelegate {
    func delete(id: Int, isVehicle: Bool)
}

class BASmartCustomerListGalleryViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var buttonFilterAlbum: UIButton!
    @IBOutlet weak var buttonFilterTime: UIButton!
    
    var type = PhotoListType.customer
    var basicData = BASmartTechnicalData()
    var objectId = 0
    var customerData = [BASmartCustomerGalleryData]()
    var warrantyData = [VehiclePhotoParam]()
    var sectionHeaderTitle = [String]()
    var numberOfItem = [Int]()
    var images = [UIImage]()
    var imagesSaved = [BASmartVehicleImages]()
    var vehicle = BASmartVehicle()
    var isSaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BASmartCustomListGalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BASmartCustomListGalleryCollectionViewCell")
        
        title = "THƯ VIỆN HÌNH ẢNH"
        
        switch type {
        case .warranty:
            let menuBarButton = UIBarButtonItem(image: UIImage(named: "ic_note")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(uploadSavedImages))
            navigationItem.rightBarButtonItem = menuBarButton
        case .customer:
            let menuBarButton = UIBarButtonItem(image: UIImage(named: "filter_icon_header")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(openMenuTabBar))
            navigationItem.rightBarButtonItem = menuBarButton
        }
        
        
        buttonFilterTime.setImage(UIImage(named: "date")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), for: .normal)
        buttonFilterAlbum.setImage(UIImage(named: "group_by_album")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), for: .normal)
        filterView.setViewCorner(radius: 10)
        filterView.isHidden = true
    
        
        getData()
    }
    
    private func getData() {
        view.showBlurLoader()
        numberOfItem = [Int]()
        sectionHeaderTitle = [String]()
        switch type {
        case .warranty:
            getPhotoWarranty()
        case .customer:
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideFilterView))
            view.addGestureRecognizer(tap)
            getPhotoCustomer(kindView: 1)
        }
    }

    private func getPhotoCustomer(kindView: Int) {
        Network.shared.BASmartGetCustomerGallery(objectId: objectId, kindView: kindView) { [weak self] (data) in
            self?.customerData = data ?? [BASmartCustomerGalleryData]()
            var sectionCondition = ""
            
            //Add array of section name
            data?.forEach({ (item) in
                if item.group != sectionCondition {
                    sectionCondition = item.group ?? ""
                    self?.sectionHeaderTitle.append(sectionCondition)
                }
            })
            
            //Add number of item in section
            self?.sectionHeaderTitle.forEach({ (item) in
                self?.numberOfItem.append(data?.filter({$0.group == item}).count ?? 0)
            })
            
            self?.view.removeBlurLoader()
            self?.collectionView.reloadData()
        }
    }
    
    private func getPhotoWarranty() {
        let param = VehiclePhotoListParam(kindId: VehiclePhotolistFrom.warranty.kindId,
                                          objectId: objectId)
        
        Network.shared.VehiclePhotoList(param: param) { [weak self] (data) in
            if data?.error != 0 && data?.error != nil {
                self?.presentBasicAlert(title: String(data?.error ?? -1), message: "", buttonTittle: "Đồng ý")
            } else {
                self?.warrantyData = data?.data?.photo ?? [VehiclePhotoParam]()
                self?.getSavedVehiclePhoto()
                var sectionCondition = ""
                
                //Add array of section name
                self?.warrantyData.forEach({ (item) in
                    if item.group != sectionCondition {
                        sectionCondition = item.group ?? ""
                        self?.sectionHeaderTitle.append(sectionCondition)
                    }
                })
                
                //Add number of item in section
                self?.sectionHeaderTitle.forEach({ (item) in
                    self?.numberOfItem.append(self?.warrantyData.filter({$0.group == item}).count ?? 0)
                })
                
                //Check is any image saved
                if self?.imagesSaved.count ?? 0 > 0 {
                    self?.sectionHeaderTitle.insert("Ảnh lưu tạm (cần đồng bộ)", at: 0)
                    self?.numberOfItem.insert(self?.imagesSaved.count ?? 0, at: 0)
                }
                
                self?.view.removeBlurLoader()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                    
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    private func getSavedVehiclePhoto() {
        imagesSaved = CoreDataBASmart.shared.getVehicle().filter({$0.userName == UserInfo.shared.userName &&
            $0.xn == Int64(basicData.customer?.xncode ?? "") &&
            $0.plate == (vehicle.plate ?? "")
        })
        collectionView.reloadData()
    }
    
    @objc func openMenuTabBar(isHidden: Bool) {
        filterView.isHidden = isHidden
    }
    
    @objc func hideFilterView() {
        filterView.isHidden = true
    }
    
    @objc func uploadSavedImages() {
        
        let imgs = imagesSaved.map({(UIImage(data: $0.image ?? Data()))!})
        isSaved = true
        addAttachs(images: imgs, descrip: "", savedId: 0)
        imagesSaved.forEach { (item) in
            let id = item.id
            CoreDataBASmart.shared.deleteVehicle(id: Int(id))
        }
    }
    
    @IBAction func buttonFilterAlbumTap(_ sender: Any) {
        sectionHeaderTitle = [String]()
        numberOfItem = [Int]()
        getPhotoCustomer(kindView: 1)
        hideFilterView()
    }
    
    @IBAction func buttonFilterTimeTap(_ sender: Any) {
        sectionHeaderTitle = [String]()
        numberOfItem = [Int]()
        getPhotoCustomer(kindView: 2)
        hideFilterView()
    }
}

extension BASmartCustomerListGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BASmartCustomListGalleryCollectionViewCell", for: indexPath) as! BASmartCustomListGalleryCollectionViewCell
        
        //Count the index
        var index = indexPath.row
        if indexPath.section > 0 {
            for i in 0..<indexPath.section {
                index += numberOfItem[i]
            }
        }
        
        //Append data as the type
        switch type {
        case .warranty:
            if index < imagesSaved.count {
                cell.setupDataSaved(imageVehicle: imagesSaved[index], imageAttach: BASmartAttachs(), isVehicle: true, hideViewSave: false)
                cell.deleteImageDelegate = self
            } else {
                //if got save image, recount the index
                if imagesSaved.count > 0 {
                    index = index - imagesSaved.count
                }
                let dataPaste = warrantyData[index]
                cell.setupData(smallLink: dataPaste.linkSmall ?? "",
                               bigLink: dataPaste.linkFull ?? "",
                               size: view.frame.size.width / 3)
            }
            
        case .customer:
            let dataPaste = customerData[index]
            cell.setupData(smallLink: dataPaste.link_small ?? "",
                           bigLink: dataPaste.link_small ?? "",
                           size: view.frame.size.width / 3)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.frame.size.width / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .warranty:
            if warrantyData.count == 0 {
                return 0
            } else {
                return numberOfItem[section]
            }
        case .customer:
            if customerData.count == 0 {
                return 0
            } else {
                return numberOfItem[section]
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionHeaderTitle.count
    }
    
    private func showPreviewImages(images: [UIImage], type: VehiclePreviewImageType, index: Int, isSaved: Bool) {
        let storyBoard = UIStoryboard(name: "BASmartWarranty", bundle: nil)
        
        let popoverContent = (storyBoard.instantiateViewController(withIdentifier: "BASmartVehiclePreviewImageViewController") ) as! BASmartVehiclePreviewImageViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
        popoverContent.type = type
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.images = images
        popoverContent.basicData = basicData
        if isSaved {
            popoverContent.savedData = imagesSaved[index + imagesSaved.count]
        } else {
            popoverContent.data = warrantyData[index]
            
        }
        popoverContent.vehicle = vehicle
        popoverContent.objectId = objectId
        popoverContent.addAttachDelegate = self
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    private func setupPreviewImages(type: DKImagePickerControllerSourceType, index: Int) {
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
                            self?.showPreviewImages(images: self?.images ?? [UIImage](), type: .create, index: index, isSaved: false)
                        }
                    } else {
                        self?.showPreviewImages(images: self?.images ?? [UIImage](), type: .create, index: index, isSaved: false)
                    }
                }
            }
        }
        self.present(pickerController, animated: true)
    }
    
    private func downloadImage(urlString: String, index: Int) {
        guard let url = URL.init(string: urlString) else { return }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource) { [weak self] (result) in
            switch result {
            case .success(let value):
                self?.showPreviewImages(images: [value.image], type: .list, index: index, isSaved: false)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        //if device doesnt have image saved
        if imagesSaved.count <= 0 {
            let index = indexPath.row + (indexPath.section * 3)
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    setupPreviewImages(type: .camera, index: index)
                case 1:
                    setupPreviewImages(type: .photo, index: index)
                default:
                    downloadImage(urlString: warrantyData[index].linkFull ?? "", index: index)
                }
            default:
                downloadImage(urlString: warrantyData[index].linkFull ?? "", index: index)
            }
        }
        //if device have image saved
        else {
            let index = indexPath.row + (indexPath.section * 3) - imagesSaved.count
            switch indexPath.section {
            case 0:
                var imgs = [UIImage]()
                imgs.append(UIImage(data: imagesSaved[index + imagesSaved.count].image ?? Data()) ?? UIImage())
                showPreviewImages(images: imgs, type: .saved, index: index, isSaved: true)
            case 1:
                switch indexPath.row {
                case 0:
                    setupPreviewImages(type: .camera, index: index)
                case 1:
                    setupPreviewImages(type: .photo, index: index)
                default:
                    downloadImage(urlString: warrantyData[index].linkFull ?? "", index: index)
                }
            default:
                downloadImage(urlString: warrantyData[index].linkFull ?? "", index: index)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BASmartCustomListGalleryCollectionReusableView", for: indexPath) as? BASmartCustomListGalleryCollectionReusableView {
            sectionHeader.titleLabel.text = sectionHeaderTitle[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}

extension BASmartCustomerListGalleryViewController: AddAttachsDelegate {
    func addAttachs(images: [UIImage], descrip: String, savedId: Int) {
        view.showBlurLoader()
        var count = 0
        images.forEach { [weak self] (image) in
            count += 1
            let isLast = count == images.count ? true : false
            let img = image.resizeImageWithRate()
            self?.uploadPhotoVehicle(imageString: img.toBase64() ?? "", isLast: isLast, descrip: descrip, savedId: savedId)
        }
    }
    
    private func uploadPhotoVehicle(imageString: String, isLast: Bool, descrip: String, savedId: Int) {

        let taskParam = VehicleTaskParam(partner: basicData.partner?.code ?? "",
                                         task: basicData.task?.taskNumber ?? "")
        
        let param = VehicleUploadImageParam(kindId: VehiclePhotolistFrom.warranty.kindId,
                                            objectId: objectId,
                                            type: 1,
                                            task: taskParam,
                                            quote: descrip,
                                            image: imageString)
        
        Network.shared.VehicleAddPhoto(param: param) { [weak self] (data) in
            if isLast {
                if savedId != 0 {
                    CoreDataBASmart.shared.deleteVehicle(id: savedId)                    
                }
                self?.view.removeBlurLoader()
                self?.hideBlurBackground()
                self?.getData()
            }
        }
    }
    
    func saveAttach() {
        
    }
}

extension BASmartCustomerListGalleryViewController: ReloadDataDelegate {
    func reload() {
        getData()
    }
}

extension BASmartCustomerListGalleryViewController: ShowLoadingDelegate {
    func show() {
        view.showBlurLoader()
    }
    
    func hide() {
        view.removeBlurLoader()
    }
}

extension BASmartCustomerListGalleryViewController: DeleteSavedImageDelegate {
    func delete(id: Int, isVehicle: Bool) {
        let alert = UIAlertController(title: "XÓA ẢNH", message: "Bạn có chắc muốn xóa ảnh đã lưu?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
            if isVehicle {
                CoreDataBASmart.shared.deleteVehicle(id: id)
            } else {
                CoreDataBASmart.shared.deleteAttach(id: id)
            }
            self?.getData()
        }))
        alert.addAction(UIAlertAction(title: "Từ chối", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
