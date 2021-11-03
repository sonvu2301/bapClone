//
//  BASmartWarrantyNoteViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/22/21.
//

import UIKit

class BASmartWarrantyNoteViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartMemo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartWarrantyMemoTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartWarrantyMemoTableViewCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.reloadData()
    }
}

extension BASmartWarrantyNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartWarrantyMemoTableViewCell", for: indexPath) as! BASmartWarrantyMemoTableViewCell
        let dataParse = data[indexPath.row]
        cell.setupData(data: dataParse)
        return cell
    }
}
