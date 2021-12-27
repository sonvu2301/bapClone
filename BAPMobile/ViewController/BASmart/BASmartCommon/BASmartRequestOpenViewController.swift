//
//  BASmartRequestOpenViewController.swift
//  BAPMobile
//
//  Created by Emcee on 3/22/21.
//

import UIKit

class BASmartRequestOpenViewController: BaseSideMenuViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartReopenRequestData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "YÊU CẦU MỞ LẠI"
    }

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "BASmartRequestOpenTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartRequestOpenTableViewCell")
    }
    
    private func getData() {
        Network.shared.BASmartReopenRequestList { [weak self] (data) in
            self?.data = data ?? [BASmartReopenRequestData]()
            self?.tableView.reloadData()
        }
    }
}

extension BASmartRequestOpenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartRequestOpenTableViewCell", for: indexPath) as! BASmartRequestOpenTableViewCell
        let dataParse = data[indexPath.row]
        cell.setupData(icon: dataParse.userInfo?.avatar ?? "",
                       name: (dataParse.userInfo?.fullName ?? "") + " " + (dataParse.userInfo?.userName ?? ""),
                       content: dataParse.reason ?? "",
                       time: dataParse.reqTime ?? 0,
                       color: dataParse.color ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") { [weak self] (action, view, completionHandler) in
            self?.handleMarkAsFavourite(state: false, id: self?.data[indexPath.row].requestId ?? 0)
            completionHandler(true)
        }
        action.image = UIImage(named: "reject")
        action.backgroundColor = UIColor(hexString: "e53a30")
        let x = UISwipeActionsConfiguration(actions: [action])
        return x
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") { [weak self] (action, view, completionHandler) in
            self?.handleMarkAsFavourite(state: true, id: self?.data[indexPath.row].requestId ?? 0)
            completionHandler(true)
        }
        action.image = UIImage(named: "confirm")
        action.backgroundColor = UIColor(hexString: "62d995")
        let x = UISwipeActionsConfiguration(actions: [action])
        return x
        
    }
    
    private func handleMarkAsFavourite(state: Bool, id: Int) {
        
        let loc = self.getCurrentLocation()
        let location = BASmartLocationParam(lng: loc.lng,
                                            lat: loc.lat,
                                            opt: 0)
        
        let param = BASmartRequestReopenConfirmParam(id: id,
                                                     location: location,
                                                     state: state)
        
        
        Network.shared.BASmartRequestReopenConfirm(param: param, id: 1) { [weak self] (data) in
            if data?.errorCode == 0 {
                let alert = UIAlertController(title: "Thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel))
                
                self?.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}
