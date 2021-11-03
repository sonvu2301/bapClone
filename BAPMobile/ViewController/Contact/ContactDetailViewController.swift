//
//  ContactDetailViewController.swift
//  BAPMobile
//
//  Created by Emcee on 8/27/21.
//

import UIKit

class ContactDetailViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data = GeneralContactListData()
    var sectionList = [String]()
    var numberOfItems = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        
        //Setup table section
        sectionList = data.items?.map({($0.department ?? "")}) ?? [String]()
        sectionList.forEach { (item) in
            let number = data.items?.filter({$0.department == item}).count
            numberOfItems.append(number ?? 0)
        }
        
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
    }
}

extension ContactDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        
        //setup index
        var index = 0
        if indexPath.section > 0 {
            for i in 0..<indexPath.section {
                index += numberOfItems[i]
            }
        }
        index += indexPath.row
        
        let dataParse = data.items?[index]
        cell.setupData(data: dataParse ?? ContactItem())
        return cell
    }
    
    
}
