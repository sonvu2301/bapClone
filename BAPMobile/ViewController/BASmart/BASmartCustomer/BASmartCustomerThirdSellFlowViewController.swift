//
//  BASmartCustomerThirdSellFlowViewController.swift
//  BAPMobile
//
//  Created by Emcee on 4/13/21.
//

import UIKit

protocol SelectFeatureDelegate {
    func selectedFeature(index: IndexPath, id: Int, state: Bool)
}

class BASmartCustomerThirdSellFlowViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = BASmartComboSaleFeatureData()
    var listFeature = [Int]()
    var sectionName: [String] = ["Tính năng hệ thống", "Tính năng thiết bị"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(UINib(nibName: "BASmartComboFeatureTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartComboFeatureTableViewCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    func getData(model: Int) {
        Network.shared.BASmartComboSaleFeature(model: model) { [weak self] (data) in
            self?.data = data ?? BASmartComboSaleFeatureData()
            self?.listFeature = [Int]()
            self?.tableView.reloadData()
        }
    }
}

extension BASmartCustomerThirdSellFlowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return data.system?.count ?? 0
        case 1:
            return data.device?.count ?? 0
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartComboFeatureTableViewCell", for: indexPath) as! BASmartComboFeatureTableViewCell
        var cellData = BASmartComboSaleModel()
        switch indexPath.section {
        case 0:
            cellData = data.system?[indexPath.row] ?? BASmartComboSaleModel()
        case 1:
            cellData = data.device?[indexPath.row] ?? BASmartComboSaleModel()
        default:
            break
        }
        cell.setupData(isCheck: cellData.state ?? false,
                       data: cellData,
                       index: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

extension BASmartCustomerThirdSellFlowViewController: SelectFeatureDelegate {
    func selectedFeature(index: IndexPath, id: Int, state: Bool) {
        switch index.section {
        case 0:
            data.system?[index.row].state = state
        case 1:
            data.device?[index.row].state = state
        default:
            break
        }
        
        switch state {
        case true:
            listFeature.append(id)
        case false:
            listFeature = listFeature.filter({$0 != id})
        }
    }
}
