//
//  BASmartAddCustomerWarehouseFirstFlowViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/30/21.
//

import UIKit

class BASmartAddCustomerWarehouseFirstFlowViewController: BaseViewController {

    @IBOutlet weak var viewProject: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewCustomerGroup: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewCustomerName: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewPhone: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewContact: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewSource: BASmartCustomerListCatalogView!
    @IBOutlet weak var viewStatus: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewScale: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewModel: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewAddress: BASmartCustomerListAddressView!
    @IBOutlet weak var viewTaker: BASmartCustomerListDropdownView!
    
    
    var catalog = BASmartWarehouseCatalogData()
    var location: [MapData]?
    var sources = [BASmartIdInfo]()
    var seller = BASmartUtilitySupportData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.setupView()
        }
    }
    
    private func setupView() {
        viewProject.setupView(title: "Dự án",
                              placeholder: "Chọn dự án...",
                              content: catalog.project?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: false)}) ?? [BASmartCustomerCatalogItems](),
                              name: "",
                              id: 0)
        
        viewCustomerGroup.setupView(title: "Nhóm KH",
                              placeholder: "Chọn nhóm khách hàng...",
                              content: catalog.ckind?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: false)}) ?? [BASmartCustomerCatalogItems](),
                              name: "",
                              id: 0)
        
        viewCustomerName.setupView(title: "Tên KH",
                                   placeholder: "Nhập tên KH...",
                                   isNumberOnly: false,
                                   content: "",
                                   isAllowSelect: true,
                                   isPhone: false,
                                   isUsingLabel: false)

        viewPhone.setupView(title: "SĐT",
                                   placeholder: "Nhập số điện thoại...",
                                   isNumberOnly: true,
                                   content: "",
                                   isAllowSelect: true,
                                   isPhone: true,
                                   isUsingLabel: false)
        
        viewContact.setupView(title: "Liên hệ",
                                   placeholder: "Nhập thông tin liên hệ...",
                                   isNumberOnly: false,
                                   content: "",
                                   isAllowSelect: true,
                                   isPhone: false,
                                   isUsingLabel: false)
        
        viewSource.setupView(name: "Nguồn", content: "")
        viewSource.delegate = self
        
        viewStatus.setupView(title: "Tình trạng",
                              placeholder: "Chọn tình trạng...",
                              content: catalog.type?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: false)}) ?? [BASmartCustomerCatalogItems](),
                              name: "",
                              id: 0)
        
        viewScale.setupView(title: "Quy mô",
                              placeholder: "Chọn quy mô...",
                              content: catalog.scale?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: false)}) ?? [BASmartCustomerCatalogItems](),
                              name: "",
                              id: 0)
        
        viewModel.setupView(title: "Mô hình",
                              placeholder: "Chọn mô hình...",
                              content: catalog.model?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: false)}) ?? [BASmartCustomerCatalogItems](),
                              name: "",
                              id: 0)
        
        viewAddress.delegate = self
        viewAddress.labelAddress.text = map.address
        getCurrentLocationFirst()
        
        viewTaker.setupView(title: "Bên nhận",
                              placeholder: "Chọn bên nhận dữ liệu...",
                              content: catalog.branch?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: false)}) ?? [BASmartCustomerCatalogItems](),
                              name: "",
                              id: 0)
        viewAddress.labelAddress.text = map.address
    }
    
    private func getCurrentLocationFirst() {
        let current = getCurrentLocation()
        let param = MapSelectParam(latstr: String(current.lat),
                                   lngstr: String(current.lng))
        
        Network.shared.SelectMap(param: param) { [weak self] (data) in
            self?.map = data?.first ?? MapData()
            self?.viewAddress.labelAddress.text = self?.map.address
        }
    }
    
    
}

extension BASmartAddCustomerWarehouseFirstFlowViewController: BASmartCustomerListOpenCatalogDelegate {
    
    func buttonTap() {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartSearchEmployeeViewController") as! BASmartSearchEmployeeViewController
        vc.isAddCustomer = true
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension BASmartAddCustomerWarehouseFirstFlowViewController: OpenSelectMapDelegate {
    func openButtonTap() {
        let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BASmartAddCustomerWarehouseFirstFlowViewController: MapSelectDelegate {
    func selectMap(data: [MapData]) {
        location = data
        viewAddress.labelAddress.text = data.first?.address
    }
}

extension BASmartAddCustomerWarehouseFirstFlowViewController: GetReasonListDelegate {
    func selectList(type: SelectMultiCatalogType, data: [BASmartIdInfo], name: String) {
//        self.sources = data
        
    }
    
    func showRate(isShow: Bool) {
        
    }
}

extension BASmartAddCustomerWarehouseFirstFlowViewController: BASmartSellerPickDelegate {
    func selectEmployee(data: BASmartUtilitySupportData) {
        seller = data
        viewSource.labelContent.text = "\(seller.fullName ?? "") (\(seller.userName ?? ""))"
    }
    
    
}
