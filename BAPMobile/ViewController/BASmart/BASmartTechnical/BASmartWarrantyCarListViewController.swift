//
//  BASmartWarrantyCarListViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/22/21.
//

import UIKit

class BASmartWarrantyCarListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var id = 0
    var data = [BASmartVehicle]()
    var basicData = BASmartTechnicalData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartTechnicalCarListTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartTechnicalCarListTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.reloadData()
    }
    
    func getData() {
        Network.shared.BASmartTechnicalVehicleList(id: id) { [weak self] (data) in
            self?.data = data?.data ?? [BASmartVehicle]()
            self?.tableView.reloadData()
        }
    }
    
    private func vehicleAction(vehicle: BASmartVehicleListAction) {
        var vehicles = [BASmartVehicleListAction]()
        vehicles.append(vehicle)
        
        let location = getCurrentLocation()
        let locationParam = BASmartLocationParam(lng: location.lng,
                                                 lat: location.lat,
                                                 opt: 0)
        
        let param = BASmartTechnicalVehicleActionParam(kind: BASmartVehicleActionKind.note.id,
                                                       task: id,
                                                       vehicles: vehicles,
                                                       location: locationParam)
        
        Network.shared.BASmartTechnicalVehicleAction(param: param) { [weak self] (data) in
            if data?.error_code != 0 && data?.error_code != nil {
                self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
            } else {
                self?.getData()
            }
        }
    }
    
}

extension BASmartWarrantyCarListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartTechnicalCarListTableViewCell", for: indexPath) as! BASmartTechnicalCarListTableViewCell
        let dataParse = data[indexPath.row]
        cell.setupData(data: dataParse)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteTitle = NSLocalizedString("X", comment: "Delete action")
          let deleteAction = UITableViewRowAction(style: .destructive,
            title: deleteTitle) { [weak self] (action, indexPath) in
            let vehicle = BASmartVehicleListAction(id: self?.data[indexPath.row].id,
                                                   state: false)
            self?.vehicleAction(vehicle: vehicle)
          }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerListGalleryViewController") as! BASmartCustomerListGalleryViewController
        vc.objectId = data[indexPath.row].id ?? 0
        vc.type = .warranty
        vc.basicData = basicData
        vc.vehicle = data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
