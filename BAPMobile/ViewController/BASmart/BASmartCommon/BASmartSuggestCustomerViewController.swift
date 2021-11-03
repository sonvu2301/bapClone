//
//  BASmartSuggestCustomerViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/4/21.
//

import UIKit

class BASmartSuggestCustomerViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: BASmartDoneCreateDelegate?
    var data = [BASmartCustomerListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartSuggestCustomerCheckinTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartSuggestCustomerCheckinTableViewCell")
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        searchView.layer.borderWidth = 2
        searchView.layer.borderColor = UIColor.black.cgColor
        searchView.setViewCircle()
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

extension BASmartSuggestCustomerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count > 0 {
            clearView.isHidden = true
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartSuggestCustomerCheckinTableViewCell", for: indexPath) as! BASmartSuggestCustomerCheckinTableViewCell
        let dataParse = data[indexPath.row]
        cell.setupDate(code: dataParse.kh_code ?? "",
                       name: dataParse.name ?? "",
                       address: dataParse.address ?? "",
                       phone: dataParse.phone ?? "",
                       bcolor: dataParse.partner?.bcolor ?? "",
                       fcolor: dataParse.partner?.fcolor ?? "",
                       partner: dataParse.partner?.ticon ?? "")
        
        cell.contentView.backgroundColor = indexPath.row % 2 == 1 ? UIColor(hexString: "E6E6E6") : .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartApproachViewController") as! BASmartApproachViewController
        
        let location = getCurrentLocation()
        let locationParam = BASmartLocationParam(lng: location.lng, lat: location.lat, opt: 1)
        let dataParse = data[indexPath.row]
        vc.blurDelegate = blurDelegate
        vc.finishDelegate = finishDelegate
        vc.isFromMain = true
        vc.isCheckingCustomer = true
        vc.customerData = BASmartCustomerDetailGeneral(address: dataParse.address,
                                                       contact: nil,
                                                       description: nil,
                                                       email: nil,
                                                       facebook: nil,
                                                       foundation: nil,
                                                       group_id: dataParse.group_id,
                                                       kh_code: dataParse.kh_code,
                                                       kind_info: nil,
                                                       location: locationParam,
                                                       model_list: nil,
                                                       name: dataParse.name,
                                                       object_id: dataParse.object_id,
                                                       phone: dataParse.phone,
                                                       region_info: nil,
                                                       scale_info: nil,
                                                       source_info: nil,
                                                       taxoridn: nil,
                                                       type_info: nil,
                                                       website: nil,
                                                       xn_code: dataParse.xn_code)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
