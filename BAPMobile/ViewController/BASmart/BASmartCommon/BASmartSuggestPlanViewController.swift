//
//  BASmartSuggestPlanViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/4/21.
//

import UIKit
import CoreLocation

class BASmartSuggestPlanViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearView: UIView!
    
    var data = [BASmartPlanListCheckinData]()
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: BASmartDoneCreateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getData()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartBasicPlanTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartBasicPlanTableViewCell")
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func getData() {
        
        //Get Location
        let location = getCurrentLocation()
        let param = MapCheckingParam(location: location)
        
        Network.shared.BASmartPlanCheckinList(param: param) { [weak self] (data) in
            self?.data = data ?? [BASmartPlanListCheckinData]()
            self?.tableView.reloadData()
        }
    }
    
}

extension BASmartSuggestPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count > 0 {
            clearView.isHidden = true
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartBasicPlanTableViewCell", for: indexPath) as! BASmartBasicPlanTableViewCell
        let dataParse = data[indexPath.row]
        cell.setupData(name: dataParse.name ?? "",
                       start: Date().millisecToHourMinute(time: dataParse.start ?? 0),
                       end: Date().millisecToHourMinute(time: dataParse.end ?? 0),
                       address: dataParse.address ?? "")
        
        cell.contentView.backgroundColor = indexPath.row % 2 == 1 ? UIColor(hexString: "E6E6E6") : .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartApproachViewController") as! BASmartApproachViewController
        
        let location = getCurrentLocation()
        let locationParam = BASmartLocationParam(lng: location.lng, lat: location.lat, opt: 1)
        let dataParse = data[indexPath.row]
        let checkinData = BASmartPlanListData(planId: dataParse.planId,
                                              partner: dataParse.partner,
                                              kindInfo: nil,
                                              name: dataParse.name,
                                              start: dataParse.start,
                                              end: dataParse.end,
                                              address: dataParse.address,
                                              phone: nil,
                                              location: locationParam,
                                              purpose: dataParse.purpose,
                                              creatorInfo: nil,
                                              description: dataParse.description,
                                              menuAction: nil,
                                              stateInfo: nil)
        vc.planData = checkinData
        vc.isCheckingCustomer = false
        vc.blurDelegate = blurDelegate
        vc.finishDelegate = finishDelegate
        vc.isFromMain = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
