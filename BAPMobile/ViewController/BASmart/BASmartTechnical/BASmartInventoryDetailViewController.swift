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
    var idChance = 0
    var name = ""
    var viewAll = false
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
        getData(viewAll: viewAll)
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
    

    
    @IBAction func buttonGetImeiTap(_ sender: Any) {
        getData(viewAll: true)
        viewAll = true
    }
    
}

extension BASmartInventoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartInventoryDetailTableViewCell", for: indexPath) as! BASmartInventoryDetailTableViewCell
        let index = indexPath.row
        let dataParse = data.imei?[index] ?? BASmartInventoryDetailImei()
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(hexString: "EDFFFF")
        } else {
            cell.contentView.backgroundColor = .white
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
        idChance = data.imei?[indexPath.row].id ?? 0
        let action = UIContextualAction(style: .normal,
                                        title: "") { [weak self] (action, view, completionHandler) in
            switch state {
            case true:
                self?.openAlertDelete(imei: self?.data.imei?[indexPath.row].imei ?? "")
            case false:
                self?.openAlertConfirm(imei: self?.data.imei?[indexPath.row].imei ?? "")
            default:
                break
            }
        }
        
        action.image = state == true ? UIImage(named: "delete_cell") : UIImage(named: "add_cell")
        action.backgroundColor = state == true ? UIColor(hexString: "fe0000") : UIColor(hexString: "008000")
        let x = UISwipeActionsConfiguration(actions: [action])
        return x
    }
    
    private func openAlertConfirm(imei: String) {
        let alert = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "AlertConfirmViewController") as! AlertConfirmViewController
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.contentString = "Bạn có chắc chắn muốn lấy lại \nIMEI \(imei) đã đánh dấu triển khai không?"
        self.present(alert, animated: true, completion: nil)
        alert.delegate = self
    }
    
    private func openAlertDelete(imei: String) {
        let alert = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "AlertDenyViewController") as! AlertDenyViewController
        alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        alert.contentString = "Bạn có chắc chắn muốn đánh dấu \nIMEI \(imei) không?"
        self.present(alert, animated: true, completion: nil)
        alert.delegate = self
    }
}

extension BASmartInventoryDetailViewController: AlertActionDelegate {
    func confirm(kind: Int, message: String) {
        imeiState(id: idChance, state: true, reason: message, type: kind)
    }
    
    func delete(kind: Int, message: String) {
        imeiState(id: idChance, state: false, reason: message, type: kind)
    }
    
    private func imeiState(id: Int, state: Bool, reason: String, type: Int) {
        let param = BASmartInventoryStatusParam(id: id,
                                                state: state,
                                                type: type,
                                                reason: reason)
        Network.shared.BASmartInventoriStatus(param: param) { [weak self] data in
            self?.getData(viewAll: self?.viewAll ?? false)
        }
    }
}
