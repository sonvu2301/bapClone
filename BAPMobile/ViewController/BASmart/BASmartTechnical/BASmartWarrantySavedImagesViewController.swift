//
//  BASmartWarrantySavedImagesViewController.swift
//  BAPMobile
//
//  Created by Emcee on 7/27/21.
//

import UIKit

class BASmartWarrantySavedImagesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataTechnical = [BASmartTechnicalData]()
    var attachs = [BASmartAttachs]()
    var vehicles = [BASmartVehicleImages]()
    var attachsHeader = [String]()
    var vehiclesHeader = [String]()
    var numberOfItem = [Int]()
    var loadingCell = [Bool]()
    var isDeleteAll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "THƯ VIỆN HÌNH ẢNH"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isDeleteAll {
            attachs.forEach { (item) in
                CoreDataBASmart.shared.deleteAttach(id: Int(item.id))
            }
            vehicles.forEach { (item) in
                CoreDataBASmart.shared.deleteVehicle(id: Int(item.id))
            }
        }
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BASmartCustomListGalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BASmartCustomListGalleryCollectionViewCell")
        
        attachs = CoreDataBASmart.shared.getAttach()
        attachsHeader = attachs.map({$0.name ?? ""})
        attachsHeader.removeDuplicates()
        vehicles = CoreDataBASmart.shared.getVehicle()
        vehiclesHeader = vehicles.map({("XN: \($0.xn), BKS: \($0.plate ?? "")")})
        vehiclesHeader.removeDuplicates()
        
        attachsHeader.forEach({ [weak self] (item) in
            numberOfItem.append(self?.attachs.filter({$0.name == item}).count ?? 0)
        })
        
        vehiclesHeader.forEach({ [weak self] (item) in
            numberOfItem.append(self?.vehicles.filter({item.contains(String($0.xn)) && item.contains($0.plate ?? "")}).count ?? 0)
        })
        
        //Append item loading cell
        attachs.forEach { [weak self] (item) in
            self?.loadingCell.append(false)
        }
        
        vehicles.forEach { [weak self ](item) in
            self?.loadingCell.append(false)
        }
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "ic_note")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(uploadSavedImages))
        navigationItem.rightBarButtonItem = menuBarButton
        
        getTechnicalData()
        
        collectionView.reloadData()
    }
    
    private func getSavedData() {
        
        numberOfItem = [Int]()
        
        attachs = CoreDataBASmart.shared.getAttach()
        attachsHeader = attachs.map({$0.name ?? ""})
        attachsHeader.removeDuplicates()
        vehicles = CoreDataBASmart.shared.getVehicle()
        vehiclesHeader = vehicles.map({("XN: \($0.xn), BKS: \($0.plate ?? "")")})
        vehiclesHeader.removeDuplicates()
        
        attachsHeader.forEach({ [weak self] (item) in
            numberOfItem.append(self?.attachs.filter({$0.name == item}).count ?? 0)
        })
        
        vehiclesHeader.forEach({ [weak self] (item) in
            numberOfItem.append(self?.vehicles.filter({item.contains(String($0.xn)) && item.contains($0.plate ?? "")}).count ?? 0)
        })
    }
    
    private func getTechnicalData() {
        let location = getCurrentLocation()
        let param = BASmartLocationParam(lng: location.lng,
                                         lat: location.lat,
                                         opt: 0)
        Network.shared.BASmartTechnicalListTask(param: param) { [weak self] (data) in
            self?.dataTechnical = data?.data ?? [BASmartTechnicalData]()
        }
    }
    
    private func uploadVehicleImage(item: BASmartVehicleImages) {
        
    }
    
    @objc func uploadSavedImages() {
        
        isDeleteAll = true
        
        if loadingCell.count > 0 {
            for i in 0..<loadingCell.count {
                loadingCell[i] = true
            }
        }
        collectionView.reloadData()
        
        //Upload attach
        attachs.forEach { [weak self] (item) in
            let task = self?.dataTechnical.filter({(item.name?.contains($0.task?.taskNumber ?? "") ?? true)}).first
            let image = UIImage(data: item.image ?? Data())?.resizeImageWithRate()
            let imageStr = image?.toBase64()
            
            let taskParam = BASmartUploadAttachTaskInfo(task: task?.task?.id,
                                                        partner: task?.task?.kind,
                                                        number: task?.task?.taskNumber)
            var files = [BASmartFileAttachParam]()
            files.append(BASmartFileAttachParam(imgdata: imageStr))
            
            let param = BASmartUploadAttachParam(task: taskParam,
                                                 file: files)

            let index = attachs.firstIndex(of: item)
            
            Network.shared.BASmartUploadFileAttach(param: param) { [weak self] (data) in
                if data?.error_code == 0 {
                    self?.loadingCell[index ?? 0] = false
                    self?.collectionView.reloadData()
                }
            }
        }
        
        //Create semaphore
        let queue = DispatchQueue(label: "uploadImage")
        let semaphore = DispatchSemaphore(value: 1)
        
        //Upload vehicle
        queue.async { [weak self] in
            self?.vehicles.forEach { (item) in
                semaphore.wait()
                //Prepare param
                let image = UIImage(data: item.image ?? Data())
                let imageStr = image?.toBase64()
                let paramSearch = BASmartVehiclePhotoSearchParam(xn: Int(item.xn), plate: item.plate)
                
                Network.shared.VehicleSearch(param: paramSearch) { (data) in
                    //Prepare param
                    let id = data?.data?.vehicle?.first?.objectId ?? 0
                    let index = (self?.attachs.count ?? 0) + (self?.vehicles.firstIndex(of: item) ?? 0)
                    let taskParam = VehicleTaskParam(partner: item.partner,
                                                     task: item.code)
                    
                    let paramUpload = VehicleUploadImageParam(kindId: VehiclePhotolistFrom.search.kindId,
                                                              objectId: id,
                                                              type: 1,
                                                              task: taskParam,
                                                              quote: "",
                                                              image: imageStr)
                    
                    Network.shared.VehicleAddPhoto(param: paramUpload) { [weak self] (data) in
                        if data?.error_code == 0 {
                            self?.loadingCell[index] = false
                            self?.collectionView.reloadData()
                            semaphore.signal()
                        }
                    }
                }
            }
        }
    }
}


extension BASmartWarrantySavedImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return attachsHeader.count + vehiclesHeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItem[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BASmartCustomListGalleryCollectionViewCell", for: indexPath) as! BASmartCustomListGalleryCollectionViewCell
        cell.deleteImageDelegate = self
        
        //Count the index
        var index = indexPath.row
        if indexPath.section > 0 {
            for i in 0..<indexPath.section {
                index += numberOfItem[i]
            }
        }
        cell.setupShowLoader(isLoading: loadingCell[index])
        
        if index < attachs.count {
            cell.setupDataSaved(imageVehicle: BASmartVehicleImages(), imageAttach: attachs[index], isVehicle: false, hideViewSave: isDeleteAll)
            
        } else {
            index = index - attachs.count
            cell.setupDataSaved(imageVehicle: vehicles[index], imageAttach: BASmartAttachs(), isVehicle: true, hideViewSave: isDeleteAll)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BASmartCustomListGalleryCollectionReusableView", for: indexPath) as? BASmartCustomListGalleryCollectionReusableView {
            if indexPath.section < attachsHeader.count {
                sectionHeader.titleLabelAll.text = attachsHeader[indexPath.section]
            } else {
                sectionHeader.titleLabelAll.text = vehiclesHeader[indexPath.section - attachsHeader.count]
            }
            return sectionHeader
        }
        return UICollectionReusableView()
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
    
}


extension BASmartWarrantySavedImagesViewController: DeleteSavedImageDelegate {
    func delete(id: Int, isVehicle: Bool) {
        let alert = UIAlertController(title: "XÓA ẢNH", message: "Bạn có chắc muốn xóa ảnh đã lưu?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
            if isVehicle {
                CoreDataBASmart.shared.deleteVehicle(id: id)
            } else {
                CoreDataBASmart.shared.deleteAttach(id: id)
            }
            self?.getSavedData()
            self?.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Từ chối", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
