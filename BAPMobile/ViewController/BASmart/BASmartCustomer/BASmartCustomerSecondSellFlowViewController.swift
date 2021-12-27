//
//  BASmartCustomerSecondSellFlowViewController.swift
//  BAPMobile
//
//  Created by Emcee on 4/13/21.
//

import UIKit
import DropDown

protocol SelectVtypeStateDelegate {
    func selectVtype(isSelected: Bool, index: Int)
}


class BASmartCustomerSecondSellFlowViewController: BaseViewController {
    
    @IBOutlet weak var viewSystem: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewModel: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewReceiver: BASmartCustomerListDropdownView!
    
    @IBOutlet weak var seperateView: UIView!
    @IBOutlet weak var textFieldUser: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = BASmartComboSaleDetailData()
    var systemDropdownData = [BASmartComboSaleModel]()
    var modelDropdownData = [BASmartComboSaleModel]()
    var vtype = [BASmartComboSaleModel]()
    var states = [Bool]()
    let systemDropDown = DropDown()
    let modelDropDown = DropDown()
    var selectModelDelegate: SelectFeatureComboDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.register(UINib(nibName: "BASmartSelectVTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartSelectVTypeTableViewCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        seperateView.drawDottedLine(view: seperateView)
        
        viewSystem.changeSeperateLine()
        viewModel.changeSeperateLine()
        viewReceiver.changeSeperateLine()
        
        viewModel.selectComboDelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.viewSystem.setupView(title: "Hệ thống",
                                 placeholder: "Chọn hệ thống...",
                                       content: self?.data.system?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: $0.state)}) ?? [BASmartCustomerCatalogItems](),
                                 name: "",
                                 id: 0)
            
            self?.viewModel.setupView(title: "Mô hình",
                                placeholder: "Chọn mô hình...",
                                      content: self?.data.model?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: $0.state)}) ?? [BASmartCustomerCatalogItems](),
                                name: "",
                                id: 0)
            
            self?.viewReceiver.setupView(title: "Đại lý",
                                   placeholder: "Chọn đại lý...",
                                         content: self?.data.receiver?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: $0.state)}) ?? [BASmartCustomerCatalogItems](),
                                   name: "",
                                   id: 0)
            
        }
    }
    
    func appendState() {
        vtype.forEach { [weak self] (item) in
            self?.states.append(false)
        }
    }
    
}

extension BASmartCustomerSecondSellFlowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = vtype.count % 2 == 0 ? vtype.count / 2 : vtype.count / 2 + 1
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartSelectVTypeTableViewCell", for: indexPath) as! BASmartSelectVTypeTableViewCell
        let limit = (indexPath.row * 2) + 1
        let index = indexPath.row * 2
        if limit >= vtype.count {
            cell.setupData(first: vtype[index],
                           second: nil,
                           firstState: states[index],
                           secondState: false,
                           index: index)
        } else {
            cell.setupData(first: vtype[index],
                           second: vtype[index + 1],
                           firstState: states[index],
                           secondState: states[index + 1],
                           index: index)
        }
        cell.delegate = self
        
        return cell
    }
}

extension BASmartCustomerSecondSellFlowViewController: SelectVtypeStateDelegate {
    func selectVtype(isSelected: Bool, index: Int) {
        states[index] = isSelected
    }
}

extension BASmartCustomerSecondSellFlowViewController: SelectFeatureComboDelegate {
    func selectedFeature(model: Int) {
        selectModelDelegate?.selectedFeature(model: model)
    }
}
