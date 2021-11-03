//
//  BASmartPlanSearchCustomerViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/14/21.
//

import UIKit

class BASmartPlanSearchCustomerViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    var data = [BASmartCustomerListData]()
    var delegate: BASmartSelectCustomerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        title = "TÌM KIẾM KHÁCH HÀNG"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartCustomerListContentTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerListContentTableViewCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
        
        searchView.setViewCorner(radius: searchView.frame.height / 2)
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.black.cgColor
    }
    

    @IBAction func buttonSearchTap(_ sender: Any) {
        let param = BASmartPlanSearchCustomerParam(day: Int(Date().timeIntervalSinceReferenceDate),
                                                   key: textFieldSearch.text,
                                                   location: getCurrentLocation())
        Network.shared.BASmartPlanSearchCustomer(param: param) { [weak self] (data) in
            self?.data = data ?? [BASmartCustomerListData]()
            self?.tableView.reloadData()
        }
    }

}


extension BASmartPlanSearchCustomerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerListContentTableViewCell", for: indexPath) as! BASmartCustomerListContentTableViewCell
        let dataPaste = data[indexPath.row]
        cell.setupCell(code: dataPaste.kh_code ?? "",
                       name: (dataPaste.name == "" ? " " : dataPaste.name) ?? "",
                       address: (dataPaste.address == "" ? " " : dataPaste.address) ?? "",
                       stateName: dataPaste.state_info?.name ?? "",
                       stateColor: dataPaste.state_info?.color ?? "",
                       rankName: dataPaste.rank_info?.name ?? "",
                       rankColor: dataPaste.rank_info?.color ?? "",
                       phone: dataPaste.phone ?? "",
                       rate: dataPaste.rate?.name ?? "",
                       rateColor: dataPaste.rate?.color ?? "",
                       objectId: dataPaste.object_id ?? 0,
                       kindId: BASmartKindId.customer.id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectCustomer(customer: data[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
