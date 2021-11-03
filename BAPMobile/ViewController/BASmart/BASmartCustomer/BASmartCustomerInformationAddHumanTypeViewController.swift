//
//  BASmartCustomerInformationAddHumanTypeViewController.swift
//  BAPMobile
//
//  Created by Emcee on 10/26/21.
//

import UIKit

protocol CheckBoxSelectDelegate {
    func selectedCheckbox(isSelect: Bool, index: Int, id: Int)
}

class BASmartCustomerInformationAddHumanTypeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartCustomerCatalogItemsDetail]()
    var sectionList = [String]()
    var sectionNumber = [Int]()
    var checkList = [Bool]()
    let catalog = BASmartCustomerCatalogDetail.shared.humanProf
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(UINib(nibName: "BASmartComboFeatureTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartComboFeatureTableViewCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        catalog?.forEach { [weak self] (item) in
            self?.checkList.append(self?.data.contains(where: {$0.id == item.id}) ?? false)
        }
        
        sectionList = catalog?.map({$0.group ?? ""}) ?? [String]()
        sectionList.removeDuplicates()
        sectionList.forEach { [weak self] (item) in
            self?.sectionNumber.append(self?.catalog?.filter({($0.group ?? "") == item}).count ?? 0 )
        }
        
        
    }
    

}

extension BASmartCustomerInformationAddHumanTypeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionNumber[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartComboFeatureTableViewCell", for: indexPath) as! BASmartComboFeatureTableViewCell
        
        //Get index in flat
        
        var index = 0
        if indexPath.section > 0 {
            for i in 0..<indexPath.section {
                index += sectionNumber[i]
            }
            index += indexPath.row
        } else {
            index = indexPath.row
        }
//        cell.seperateLine.isHidden = true
        cell.isComboFeature = false
        cell.selectDelegate = self
        cell.setupCheckbox(index: index,
                           id: catalog?[index].id ?? 0,
                           isCheck: checkList[index],
                           name: catalog?[index].name ?? "")
        return cell
    }
}

extension BASmartCustomerInformationAddHumanTypeViewController: CheckBoxSelectDelegate {
    func selectedCheckbox(isSelect: Bool, index: Int, id: Int) {
        checkList[index] = isSelect
        if isSelect {
            data.append(catalog?.filter({$0.id == id}).first ?? BASmartCustomerCatalogItemsDetail())
        } else {
            data.removeAll(where: {$0.id == id})
        }
    }
}
