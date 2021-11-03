//
//  VehicleSearchViewController.swift
//  BAPMobile
//
//  Created by Emcee on 8/13/21.
//

import UIKit

class VehicleSearchViewController: BaseViewController {

    @IBOutlet weak var viewSearchBound: UIView!
    @IBOutlet weak var viewCode: UIView!
    @IBOutlet weak var viewVehicleNumber: UIView!
    
    @IBOutlet weak var textFieldCode: UITextField!
    @IBOutlet weak var textFieldVehicleNumber: UITextField!
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartVehicleSearchData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "TÌM KIẾM THÔNG TIN XE"
    }
    
    private func setupView() {
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        let borderColor = UIColor(hexString: "DCDCDC").cgColor
        viewCode.setViewCorner(radius: 5)
        viewVehicleNumber.setViewCorner(radius: 5)
        viewCode.layer.borderWidth = 1
        viewCode.layer.borderColor = borderColor
        viewVehicleNumber.layer.borderWidth = 1
        viewVehicleNumber.layer.borderColor = borderColor
    }
    
    private func searchVehicle() {
        let param = BASmartVehiclePhotoSearchParam(xn: Int(textFieldCode.text ?? "0"), plate: textFieldVehicleNumber.text)
        Network.shared.VehicleSearch(param: param) { [weak self] (data) in
            if data?.error == 0 || data?.error == nil {
                self?.data = data?.data?.vehicle ?? [BASmartVehicleSearchData]()
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func buttonSearchTap(_ sender: Any) {
        searchVehicle()
    }
    
}

extension VehicleSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
