//
//  BASmartWarrantySearchVehicleViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/25/21.
//

import UIKit

class BASmartWarrantySearchVehicleViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewSearchBound: UIView!
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    
    var id = 0
    var data = [BASmartVehicle]()
    var states = [Bool]()
    var finishDelegate: BASmartDoneCreateDelegate?
    var blurDelegate: BlurViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "THÊM XE VÀO ĐƠN"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        blurDelegate?.hideBlur()
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartVehicleTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartVehicleTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        
        viewSearchBound.layer.borderWidth = 1
        viewSearchBound.layer.borderColor = UIColor.black.cgColor
        viewSearchBound.setViewCircle()
        
        buttonCancel.layer.borderColor = UIColor.lightGray.cgColor
        buttonCancel.layer.borderWidth = 1
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        getData(key: "")
    }
    
    private func getData(key: String) {
        
        let location = getCurrentLocation()
        let locationParam = BASmartLocationParam(lng: location.lng,
                                                 lat: location.lat,
                                                 opt: 0)
        let param = BASmartVehicleSearchParam(id: id,
                                              key: key,
                                              location: locationParam)
        
        Network.shared.BASmartTechnicalVehicleSearch(param: param) { [weak self] (data) in
            if data?.error != 0 && data?.error != nil {
                self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
            } else {
                self?.data = data?.data ?? [BASmartVehicle]()
                self?.states = [Bool]()
                self?.data.forEach({ (item) in
                    self?.states.append(false)
                })
                self?.tableView.reloadData()
            }
        }
    }
    
    private func vehicleAction() {
        
        var vehicles = [BASmartVehicleListAction]()
        for i in 0..<states.count {
            if states[i] {
                let vehicle = BASmartVehicleListAction(id: data[i].id,
                                                       state: true)
                vehicles.append(vehicle)
            }
        }
        
        let location = getCurrentLocation()
        let locationParam = BASmartLocationParam(lng: location.lng,
                                                 lat: location.lat,
                                                 opt: 0)
        
        let param = BASmartTechnicalVehicleActionParam(kind: BASmartVehicleActionKind.search.id,
                                                       task: id,
                                                       vehicles: vehicles,
                                                       location: locationParam)
        
        Network.shared.BASmartTechnicalVehicleAction(param: param) { [weak self] (data) in
            if data?.errorCode != 0 && data?.errorCode != nil {
                self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
            } else {
                self?.finishDelegate?.finishCreate()
                self?.blurDelegate?.hideBlur()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func buttonSearchTap(_ sender: Any) {
        getData(key: textFieldSearch.text ?? "")
    }
 
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        let alert = UIAlertController(title: "XÁC NHẬN", message: "Bạn có muốn thêm các xe đã chọn vào đơn không?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "BỎ QUA", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "XÁC NHẬN", style: .default, handler: { [weak self] (action) in
            self?.vehicleAction()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension BASmartWarrantySearchVehicleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartVehicleTableViewCell", for: indexPath) as! BASmartVehicleTableViewCell
        cell.setupData(data: data[indexPath.row],
                       isCheck: states[indexPath.row])
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor(hexString: "DCDCDC") : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        states[indexPath.row] = !states[indexPath.row]
        tableView.reloadData()
    }
}
