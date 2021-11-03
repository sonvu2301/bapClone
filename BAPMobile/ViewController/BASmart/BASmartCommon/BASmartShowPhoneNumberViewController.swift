//
//  BASmartShowPhoneNumberViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/18/21.
//

import UIKit

class BASmartShowPhoneNumberViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var phones = [String]()
    var delegate: BlurViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartShowPhoneNumberViewControllerTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartShowPhoneNumberViewControllerTableViewCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        
    }

}

extension BASmartShowPhoneNumberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartShowPhoneNumberViewControllerTableViewCell", for: indexPath) as! BASmartShowPhoneNumberViewControllerTableViewCell
        cell.setupData(phone: phones[indexPath.row])
        return cell
    }
    
    
}
