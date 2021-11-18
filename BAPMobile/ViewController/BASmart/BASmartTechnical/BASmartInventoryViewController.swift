//
//  BASmartInventoryViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/16/21.
//

import UIKit
import DropDown

enum InventoryType {
    case all, imei, noimei
    
    var name: String {
        switch self {
        case .all:
            return "Tìm tất cả"
        case .imei:
            return "Hàng IMEI"
        case .noimei:
            return "Không IMEI"
        }
    }
}

class BASmartInventoryViewController: BaseSideMenuViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var viewBoundSearch: UIView!
    
    var type = InventoryType.all
    
    var data = BASmartInventoryListData()
    var filterData = [BASmartInventoryCommodity]()
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "DỮ LIỆU HÀNG TỒN KHO"
    }

    private func setupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BASmartInventoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartInventoryListTableViewCell")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        viewBoundSearch.setViewCorner(radius: 15)
        viewBoundSearch.layer.borderColor = UIColor.black.cgColor
        viewBoundSearch.layer.borderWidth = 1
        dropDown.anchorView = dropDownButton
        dropDown.width = dropDownButton.frame.width
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = [InventoryType.all.name,
                               InventoryType.imei.name,
                               InventoryType.noimei.name]
        
        searchTextField.delegate = self
        
        let date = Int(Date().timeIntervalSince1970)
        getData(date: date)
    }
    
    private func getData(date: Int) {
        Network.shared.BASmartGetInventoryList(date: date) { [weak self] data in
            if data?.errorCode == 0 || data?.errorCode == nil {
                self?.data = data?.data ?? BASmartInventoryListData()
                self?.filterData = self?.data.commodity ?? [BASmartInventoryCommodity]()
                self?.labelName.text = "\(self?.data.stock?.code ?? "") - \(self?.data.stock?.name ?? "")"
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func buttonDropdownTap(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDownButton.setTitle(item, for: .normal)
            self?.dropDownButton.setTitleColor(.black, for: .normal)
            
            switch index {
            case 0:
                self?.filterData = self?.data.commodity ?? [BASmartInventoryCommodity]()
                self?.type = .all
            case 1:
                self?.filterData = self?.data.commodity?.filter({$0.imei == true}) ?? [BASmartInventoryCommodity]()
                self?.type = .imei
            case 2:
                self?.filterData = self?.data.commodity?.filter({$0.imei == false}) ?? [BASmartInventoryCommodity]()
                self?.type = .noimei
            default:
                break
            }
            
            self?.searchTextField.text = ""
            self?.tableView.reloadData()
        }
    }
    
}

extension BASmartInventoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartInventoryListTableViewCell", for: indexPath) as! BASmartInventoryListTableViewCell
        
        let dataParse = filterData[indexPath.row]
        cell.setupData(cellData: dataParse)
        if indexPath.row % 2 == 0 {
            cell.boundView.backgroundColor = UIColor(hexString: "EDFFFF")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = filterData[indexPath.row]
        if cellData.imei ?? false {
//            let vc = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartInventoryDetailViewController") as! BASmartInventoryDetailViewController
//            vc.objectId = cellData.objectId ?? 0
            
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension BASmartInventoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text?.lowercased()
        if (text?.count ?? 0) > 0 {
            switch type {
            case .all:
                filterData = data.commodity?.filter({$0.name?.lowercased().contains(text ?? "") == true}) ?? [BASmartInventoryCommodity]()
            case .imei:
                filterData = data.commodity?.filter({
                    $0.name?.lowercased().contains(text ?? "") == true &&
                    $0.imei == true
                }) ?? [BASmartInventoryCommodity]()
            case .noimei:
                filterData = data.commodity?.filter({
                    $0.name?.lowercased().contains(text ?? "") == true &&
                    $0.imei == false
                }) ?? [BASmartInventoryCommodity]()
            }
        } else {
            switch type {
            case .all:
                filterData = data.commodity ?? [BASmartInventoryCommodity]()
            case .imei:
                filterData = data.commodity?.filter({$0.imei == true}) ?? [BASmartInventoryCommodity]()
            case .noimei:
                filterData = data.commodity?.filter({$0.imei == false}) ?? [BASmartInventoryCommodity]()
            }
        }
        tableView.reloadData()
    }
}
