//
//  CustomerCarListViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/18/20.
//

import UIKit

class CustomerCarListViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topView: CustomerListTableViewCell!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var labelXNcode: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonCallIcon: UIButton!
    @IBOutlet weak var buttonCallNumber: UIButton!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var bailoutButton: UIButton!
    

    var data = [CustomerCarData]()
    var dataFiltered = [CustomerCarData]()
    var checkBox = [Bool]()
    var vehicleIds = [Int]()
    var isCheckboxAll = false
    var object_id = 0
    var phone = ""
    var xn = ""
    var name = ""
    var address = ""
    
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getData()
    }
    
    func presetupView(xn: String, name: String, address: String, phone: String, object_id: Int) {
        self.xn = xn
        self.name = name
        self.address = address
        self.phone = phone
        self.object_id = object_id
    }
    
    private func setupView() {
        
        self.title = "Danh Sách Xe"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomerCarListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomerCarListTableViewCell")
        
        searchBar.delegate = self
        labelXNcode.text = xn
        labelName.text = name
        labelAddress.text = address
        buttonCallNumber.setTitle(phone, for: .normal)
        bailoutButton.layer.masksToBounds = false
        bailoutButton.layer.cornerRadius = bailoutButton.frame.size.height / 2
    }
    
    private func getData() {
        view.showBlurLoader()
        Network.shared.getCustomerListCar(obj_id: object_id) { [weak self] (data) in
            self?.data = data?.data ?? [CustomerCarData]()
            self?.data.forEach({ [weak self] (item) in
                self?.checkBox.append(false)
            })
            self?.tableView.reloadData()
            self?.view.removeBlurLoader()
        }
    }
    
    @IBAction func buttonCallIconTap(_ sender: Any) {
        callNumber()
    }
    
    @IBAction func buttonCallNumberTap(_ sender: Any) {
        callNumber()
    }
    
    @IBAction func checkboxAllButtonTap(_ sender: Any) {
        //Check box all state
        isCheckboxAll = !isCheckboxAll
        vehicleIds = [Int]()
        let image = isCheckboxAll == true ? UIImage(named: "ic_check") : UIImage(named: "ic_uncheck")
        checkboxButton.setImage(image, for: .normal)
        for i in 0..<checkBox.count {
            checkBox[i] = isCheckboxAll
        }
        
        if isCheckboxAll {
            vehicleIds = data.filter({($0.grflag ?? false)}).map({($0.vehicleid ?? 0)})
        }
        
        tableView.reloadData()
    }
    
    @IBAction func bailoutButtonTap(_ sender: Any) {
        //Check is vehicleid is empty
        if vehicleIds.isEmpty {
            self.presentBasicAlert(title: "Bạn cần chọn xe bảo lãnh", message: "", buttonTittle: "Đồng ý")
        } else {
            let day = Int(textField.text ?? "") ?? 0
            //Check is valid day from text field
            if day > 0 {
                Network.shared.createVGSTask(day: Int(textField.text ?? "") ?? 0, vehicleIds: vehicleIds) { [weak self] (isDone) in
                    if isDone?.errorCode == 0 {
                        self?.getData()
                        self?.vehicleIds = [Int]()
                    }
                }
            } else {
                self.presentBasicAlert(title: "", message: "Bạn cần nhập ngày bảo lãnh", buttonTittle: "Đồng ý")
            }
        }
    }
    
    private func callNumber() {
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.open(number)
    }
}

extension CustomerCarListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = isSearchBarEmpty == true ? data.count : dataFiltered.count
        return number
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCarListTableViewCell", for: indexPath) as! CustomerCarListTableViewCell
        let dataParse = isSearchBarEmpty == true ? data[indexPath.row] : dataFiltered[indexPath.row]
        cell.setupData(vehicle: dataParse.vehicleplate ?? "",
                       gps_time: Date().millisecToDate(time: dataParse.gpstime ?? 0),
                       lock_state: "Khóa Phí",
                       extend_time: Date().millisecToDate(time: dataParse.exttime ?? 0),
                       total_day: String(dataParse.totalday ?? 0),
                       mc_flag: dataParse.mcflag ?? false,
                       bt_flag: dataParse.btflag ?? false,
                       sc_flag: dataParse.scflag ?? false,
                       grf_flag: dataParse.grflag ?? false)
        cell.buttonCheckbox.tag = indexPath.row
        let checkboxState = checkBox[indexPath.row] == true ? UIImage(named: "ic_check") : UIImage(named: "ic_uncheck")
        cell.buttonCheckbox.setImage(checkboxState, for: .normal)
        cell.buttonCheckbox.addTarget(self, action: #selector(checkboxTap), for: .touchUpInside)
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor(hexString: "E6E6E6") : .white
        return cell
    }
    
    @objc func checkboxTap(sender: UIButton) {
        checkBox[sender.tag] = !checkBox[sender.tag]
        let image = checkBox[sender.tag] == true ? UIImage(named: "ic_check") : UIImage(named: "ic_uncheck")
        sender.setImage(image, for: .normal)
        
        if checkBox[sender.tag] {
            vehicleIds.append(data[sender.tag].vehicleid ?? 0)
        } else {
            vehicleIds = vehicleIds.filter({$0 != data[sender.tag].vehicleid})
        }
    }
}


extension CustomerCarListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataFiltered = data.filter({$0.vehicleplate?.lowercased().contains(searchText.lowercased()) == true})
        
        tableView.reloadData()
    }
}
