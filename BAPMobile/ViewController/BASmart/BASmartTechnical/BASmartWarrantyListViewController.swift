//
//  BASmartWarrantyListViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/21/21.
//

import UIKit

class BASmartWarrantyListViewController: BaseSideMenuViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var buttonFooter: UIButton!
    
    var data = [BASmartTechnicalData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "DANH SÁCH ĐƠN KỸ THUẬT TRIỂN KHAI"
        
        DispatchQueue.main.async { [weak self] in
            self?.getData()
            self?.footerView.isHidden = CoreDataBASmart.shared.getAttach().count > 0 ? false : true
        }
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartWarrantyListTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartWarrantyListTableViewCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 285
        tableView.rowHeight = UITableView.automaticDimension
        getLocationPermission()
        
        buttonFooter.setViewCorner(radius: 5)
    }
    
    private func getData() {
        
        let location = getCurrentLocation()
        let param = BASmartLocationParam(lng: location.lng,
                                         lat: location.lat,
                                         opt: 0)
        Network.shared.BASmartTechnicalListTask(param: param) { [weak self] (data) in
            self?.data = data?.data ?? [BASmartTechnicalData]()
            if data?.errorcode == 0 {
                self?.data = data?.data ?? [BASmartTechnicalData]()
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func buttonFooterTap(_ sender: Any) {
        let vc = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartWarrantySavedImagesViewController") as! BASmartWarrantySavedImagesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension BASmartWarrantyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartWarrantyListTableViewCell", for: indexPath) as! BASmartWarrantyListTableViewCell
        let dataParse = data[indexPath.row]
        cell.setupData(data: dataParse)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartWarrantyRequestViewController") as! BASmartWarrantyRequestViewController
        vc.basicData = data[indexPath.row]
        vc.getData(id: data[indexPath.row].task?.id ?? 0)
        vc.reloadDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BASmartWarrantyListViewController: ReloadDataDelegate {
    func reload() {
        getData()
    }
}
