//
//  BASmartInventoryDetailViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/16/21.
//

import UIKit

class BASmartInventoryDetailViewController: BaseViewController {

    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonGetImei: UIButton!
    
    var objectId = 0
    var name = ""
    var data = BASmartInventoryDetailData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "CHI TIẾT HÀNG TỒN KHO"
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BASmartInventoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartInventoryDetailTableViewCell")
        tableView.rowHeight = 50
        
        labelName.text = name
        getData(viewAll: false)
        buttonGetImei.setViewCorner(radius: 5)
    }
    
    private func setupData() {
        buttonGetImei.isHidden = !(data.viewAll ?? false)
        tableView.reloadData()
    }
    
    private func getData(viewAll: Bool) {
        Network.shared.BASmartGetInventoryDetail(id: objectId, viewAll: viewAll) { [weak self] data in
            self?.data = data?.data ?? BASmartInventoryDetailData()
            self?.setupData()
        }
    }
    
    private func imeiState(id: Int, state: Bool) {
        
        let param = BASmartInventoryStatusParam(id: id,
                                                state: state,
                                                type: 0,
                                                reason: "")
        Network.shared.BASmartInventoriStatus(param: param) { [weak self] data in
            self?.getData(viewAll: true)
        }
    }
    
    @IBAction func buttonGetImeiTap(_ sender: Any) {
        getData(viewAll: true)
    }
    
}

extension BASmartInventoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartInventoryDetailTableViewCell", for: indexPath) as! BASmartInventoryDetailTableViewCell
        let index = indexPath.row
        let dataParse = data.imei?[index] ?? BASmartInventoryDetailImei()
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(hexString: "EDFFFF")
        }
        cell.setupData(data: dataParse, index: index)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.imei?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let state = data.imei?[indexPath.row].state
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") { [weak self] (action, view, completionHandler) in
            
            self?.imeiState(id: self?.data.imei?[indexPath.row].id ?? 0,
                            state: state ?? false)
        }
        
        action.image = state == true ? UIImage(named: "delete_cell") : UIImage(named: "add_cell")
        action.backgroundColor = state == true ? UIColor(hexString: "fe0000") : UIColor(hexString: "008000")
        let x = UISwipeActionsConfiguration(actions: [action])
        return x
    }
}
