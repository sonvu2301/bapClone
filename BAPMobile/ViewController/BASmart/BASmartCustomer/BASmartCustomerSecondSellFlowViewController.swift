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

    @IBOutlet weak var buttonDropdownSystem: UIButton!
    @IBOutlet weak var buttonDropdownFigure: UIButton!
    
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
        
        buttonDropdownSystem.setViewCorner(radius: 5)
        buttonDropdownSystem.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        buttonDropdownSystem.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        buttonDropdownFigure.setViewCorner(radius: 5)
        buttonDropdownFigure.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        buttonDropdownFigure.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
    }
    
    private func setupDropdown(dropDown: DropDown, dataSource: [BASmartComboSaleModel], button: UIButton) {
        dropDown.anchorView = button
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = dataSource.map({$0.name ?? ""})
        dropDown.direction = .any
    }
    
    func appendState() {
        vtype.forEach { [weak self] (item) in
            self?.states.append(false)
        }
    }
    
    @IBAction func buttonDropdownSystemTap(_ sender: Any) {
        setupDropdown(dropDown: systemDropDown,
                      dataSource: systemDropdownData,
                      button: buttonDropdownSystem)
        systemDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.buttonDropdownSystem.setTitle("  " + item, for: .normal)
        }
        systemDropDown.show()
    }
    
    @IBAction func buttonDropDownModelTap(_ sender: Any) {
        setupDropdown(dropDown: modelDropDown,
                      dataSource: modelDropdownData,
                      button: buttonDropdownFigure)
        modelDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.buttonDropdownFigure.setTitle("  " + item, for: .normal)
            self?.selectModelDelegate?.selectedFeature(model: self?.modelDropdownData[index].id ?? 0)
        }
        modelDropDown.show()
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
