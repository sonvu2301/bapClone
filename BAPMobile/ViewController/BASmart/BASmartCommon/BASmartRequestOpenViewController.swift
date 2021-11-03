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
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//
//        }
//
//        if (editingStyle == .insert) {
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavourite()
                                            completionHandler(true)
        }
        action.backgroundColor = UIColor(patternImage: UIImage(named: "duyet")?.resizeImage(targetSize: CGSize(width: 15, height: 15)) ?? UIImage())
        action.title = "Favorite"
//        action.backgroundColor = .systemBlue
        let x = UISwipeActionsConfiguration(actions: [action])
        return x
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavourite()
                                            completionHandler(true)
        }
        action.image = UIImage(named: "icon_camera")?.resizeImage(targetSize: CGSize(width: 15, height: 15))
        action.backgroundColor = .systemBlue
        let x = UISwipeActionsConfiguration(actions: [action])
        return x
        
    }
    
    func handleMarkAsFavourite() {
        
    }
}
