//
//  BASmartVehiclePreviewImageViewController.swift
//  BAPMobile
//
//  Created by Emcee on 7/9/21.
//

import UIKit

protocol SelectTimeTypeDelegate {
    func selectType(isBefore: Bool)
}

enum VehiclePreviewImageType {
    case list, create, saved
}

class BASmartVehiclePreviewImageViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    @IBOutlet weak var seperateLine: UIView!
    
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: ReloadDataDelegate?
    var addAttachDelegate: AddAttachsDelegate?
    
    var type = VehiclePreviewImageType.list
    var state = ScrollState.first
    var images = [UIImage]()
    var isBefore = false
    var basicData = BASmartTechnicalData()
    var data = VehiclePhotoParam()
    var savedData = BASmartVehicleImages()
    var vehicle = BASmartVehicle()
    var descrip = ""
    var objectId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView(type: type)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "HÌNH ẢNH"
    }
    
    func setupView(type: VehiclePreviewImageType) {
        let width = scrollView.frame.width - 30
        scrollView.contentSize = CGSize(width: width * 2 - 10, height: 0)
        scrollView.delegate = self
        self.type = type
        
        let vc1 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartVehiclePreviewImageFirstViewController") as! BASmartVehiclePreviewImageFirstViewController
        let vc2 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartVehiclePreviewImageSecondViewController") as! BASmartVehiclePreviewImageSecondViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        vc1.images = images
        vc2.descrip = descrip
        
        vc1.selectTypeTimeDelegate = self
        
        switch type {
        case .list:
            buttonSave.isHidden = true
            vc1.code = data.task?.task ?? ""
            vc1.time = data.type ?? ""
            vc2.time = Date().millisecToDateHourSaved(time: data.editTime ?? 0)
            vc2.creator = data.editer ?? ""
        case .create:
            vc1.code = basicData.task?.taskNumber ?? ""
        case .saved:
            buttonSave.isHidden = true
            vc1.code = savedData.code ?? ""
            vc1.time = savedData.isBefore == true ? "Trước triển khai" : "Sau triển khai"
            vc2.time = Date().millisecToDateHourSaved(time: Int(savedData.id ))
            vc2.creator = savedData.creator ?? ""
        }
        
        vc1.setupView(type: type)
        vc2.setupView(type: type)
        
        self.addChild(vc1)
        self.addChild(vc2)
        
        scrollView.addSubview(vc1.view)
        scrollView.addSubview(vc2.view)
        
        buttonSave.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        buttonCancel.setViewCorner(radius: 5)
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor.black.cgColor
        
        
    }
    
    private func scrollMenu(state: ScrollState) {
        let width = scrollView.frame.width + 10
        self.state = state
        switch state {
        case .first:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case .second:
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
        case .third:
            break
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
            CoreDataBASmart.shared.insertVehicle(plate: vehicle.plate ?? "",
                                                 xn: basicData.customer?.xncode ?? "",
                                                 image: data ?? Data(),
                                                 id: Int64(id),
                                                 code: self?.basicData.task?.taskNumber ?? "",
                                                 isBefore: isBefore,
                                                 partner: self?.basicData.partner?.code ?? "")
            if count == images.count {
                self?.finishDelegate?.reload()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonSaveTap(_ sender: Any) {
        saveAttach()
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        switch type {
        case .list:
            break
        case .create:
            addAttachDelegate?.addAttachs(images: images, descrip: descrip, savedId: 0)
        case .saved:
            addAttachDelegate?.addAttachs(images: images, descrip: descrip, savedId: Int(savedData.id))
        }
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
}


extension BASmartVehiclePreviewImageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width - 30
        let contentOffset = scrollView.contentOffset.x

        switch state {
        case .first:
            if contentOffset > (width / 2) {
                scrollMenu(state: .second)
            }
        case .second:
            if contentOffset < (width / 2) {
                scrollMenu(state: .first)
            }
        case .third:
            break
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let width = scrollView.frame.width - 30
        let contentOffset = scrollView.contentOffset.x
        
        switch state {
        case .first:
            if contentOffset <= (width / 2) {
                scrollMenu(state: .first)
            }
        case .second:
            if contentOffset >= (width / 2) {
                scrollMenu(state: .second)
            }
        case .third:
            break
        }
    }
    
}

extension BASmartVehiclePreviewImageViewController: SelectTimeTypeDelegate {
    func selectType(isBefore: Bool) {
        self.isBefore = isBefore
    }
}
