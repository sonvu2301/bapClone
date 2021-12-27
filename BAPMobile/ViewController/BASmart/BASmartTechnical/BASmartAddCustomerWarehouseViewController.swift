//
//  BASmartAddCustomerWarehouseViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/30/21.
//

import UIKit

class BASmartAddCustomerWarehouseViewController: BaseViewController {
    
    @IBOutlet weak var seperateLine: UIView!
    
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: BASmartDoneCreateDelegate?
    var state = ScrollState.first
    var catalog = BASmartWarehouseCatalogData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4", alpha: 0.5).cgColor
        
        buttonFirst.layer.borderWidth = 1
        buttonFirst.layer.borderColor = UIColor().defaultColor().cgColor
        buttonFirst.setViewCircle()
        buttonSecond.layer.borderWidth = 1
        buttonSecond.layer.borderColor = UIColor(hexString: "C8C8C8").cgColor
        buttonSecond.setViewCircle()
        
        scrollView.contentSize = CGSize(width: view.frame.width * 2 - 80, height: 0)
        scrollView.delegate = self
        
        let vc1 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartAddCustomerWarehouseFirstFlowViewController") as! BASmartAddCustomerWarehouseFirstFlowViewController
        let vc2 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartAddCustomerWarehouseSecondFlowViewController") as! BASmartAddCustomerWarehouseSecondFlowViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width - 40, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        vc1.catalog = catalog
        vc2.catalog = catalog
        
        self.addChild(vc1)
        self.addChild(vc2)
        scrollView.addSubview(vc1.view)
        scrollView.addSubview(vc2.view)
        scrollView.isPagingEnabled = true
        
        scrollMenu(state: state)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        title = "THÊM MỚI DỮ LIỆU KHÁCH HÀNG"
    }
    
    private func scrollMenu(state: ScrollState) {
        self.state = state
        switch state {
        case .first:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            buttonFirst.backgroundColor = UIColor().defaultColor()
            buttonFirst.setTitleColor(.white, for: .normal)
            buttonSecond.backgroundColor = UIColor(hexString: "C8C8C8")
            buttonSecond.setTitleColor(UIColor(hexString: "969696"), for: .normal)
            buttonSecond.layer.borderColor = UIColor(hexString: "C8C8C8").cgColor
            seperateLine.backgroundColor = UIColor(hexString: "C8C8C8")
        case .second:
            scrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
            buttonFirst.backgroundColor = .clear
            buttonFirst.setTitleColor(UIColor().defaultColor(), for: .normal)
            buttonSecond.backgroundColor = UIColor().defaultColor()
            buttonSecond.setTitleColor(.white, for: .normal)
            buttonSecond.layer.borderColor = UIColor().defaultColor().cgColor
            seperateLine.backgroundColor = UIColor().defaultColor()
        case .third:
            break
        }
    }
    
    private func addNewCustomer() {
        let vc1 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartAddCustomerWarehouseFirstFlowViewController") as! BASmartAddCustomerWarehouseFirstFlowViewController
        let vc2 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartAddCustomerWarehouseSecondFlowViewController") as! BASmartAddCustomerWarehouseSecondFlowViewController
        
        let loc = vc1.location?.first?.coords?.first
        let locParam = BASmartLocationParam(lng: loc?.lng ?? 0, lat: loc?.lat ?? 0, opt: 0)
        
        let general = BASmartWarehouseCreateGeneral(
            kind: BASmartIdInfo(id: vc1.viewCustomerGroup.id) ,
            type: BASmartIdInfo(id: vc1.viewStatus.id),
            project: BASmartIdInfo(id: vc1.viewProject.id),
            source: BASmartSourceName(name: vc1.viewSource.labelContent.text),
            name: vc1.viewCustomerName.textView.text,
            phone: vc1.viewPhone.textView.text,
            contact: vc1.viewContact.textView.text,
            scale: BASmartIdInfo(id: vc1.viewScale.id),
            model: BASmartIdInfo(id: vc1.viewModel.id),
            address: vc1.viewAddress.labelAddress.text,
            location: locParam,
            branch: BASmartIdInfo(id: vc1.viewTaker.id)
        )
        
        let approach = BASmartWarehouseCreateApproach(
            ignore: vc2.isIgnore,
            kind: vc2.viewPKind.id,
            project: vc2.approachProjectList.map({BASmartIdInfo(id: $0.id)}),
            rate: vc2.viewRate.id,
            result: vc2.viewResult.textView.text,
            vehicleCount: Int(vc2.viewVehicleCount.textView.text ?? "0"),
            expected: Int(vc2.viewExpectedTime.datePicker.date.timeIntervalSince1970),
            scheme: vc2.textViewScheme.text,
            next: Int(vc2.viewNextTime.datePicker.date.timeIntervalSince1970)
        )
        
        Network.shared.BASmartWarehouseCreateCustomer(
            param: BASmartWarehouseCreateCustomerParam(general: general, approach: approach)) { [weak self] data in
                self?.finishDelegate?.finishCreate()
                self?.blurDelegate?.hideBlur()
                self?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func buttonFirstTap(_ sender: Any) {
        scrollMenu(state: .first)
    }
    
    @IBAction func buttonSecondTap(_ sender: Any) {
        scrollMenu(state: .second)
    }
    
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        addNewCustomer()
    }
    

}

extension BASmartAddCustomerWarehouseViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView.currentPage {
        case 1:
            scrollMenu(state: .first)
        case 2:
            scrollMenu(state: .second)
        default:
            break
        }
    }
    
}
