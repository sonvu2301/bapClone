//
//  BASmartCustomerInformationApproachViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/12/21.
//

import UIKit

class BASmartCustomerInformationApproachViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data = [BASmartCustomerDetailApproachList]()
    var menuAction = [BASmartDetailMenuDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BASmartCustomerInformationApproachTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerInformationApproachTableViewCell")
    }
}

extension BASmartCustomerInformationApproachViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerInformationApproachTableViewCell", for: indexPath) as! BASmartCustomerInformationApproachTableViewCell
        let dataPaste = data[indexPath.row]
        cell.setupData(data: dataPaste)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 720
    }
    
}
