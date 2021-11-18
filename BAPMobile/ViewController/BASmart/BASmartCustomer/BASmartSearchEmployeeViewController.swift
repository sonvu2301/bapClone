//
//  BASmartSearchEmployeeViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/12/21.
//

import UIKit

class BASmartSearchEmployeeViewController: BaseViewController {

    @IBOutlet weak var viewSearchBound: UIView!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartUtilitySupportData]()
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: BASmartDoneCreateDelegate?
    var objectId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "TÌM KIẾM NHÂN VIÊN"
    }
    
    private func setupView() {
        viewSearchBound.setViewCircle()
        viewSearchBound.layer.borderWidth = 1
        viewSearchBound.layer.borderColor = UIColor.black.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartSearchEmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartSearchEmployeeTableViewCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        searchSeller(searchStr: "")
    }
    
    private func searchSeller(searchStr: String) {
        Network.shared.BASmartGetSeller(search: searchStr) { [weak self] data in
            self?.data = data?.data ?? [BASmartUtilitySupportData]()
            self?.tableView.reloadData()
        }
    }
    
    private func transferCustomer(seller: String) {
        Network.shared.BASmartTransferCustomer(id: objectId, seller: seller) { [weak self] data in
            if data?.error_code == 0 {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func buttonSearchTap(_ sender: Any) {
        searchSeller(searchStr: textFieldSearch.text ?? "")
    }
    
}

extension BASmartSearchEmployeeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartSearchEmployeeTableViewCell", for: indexPath) as! BASmartSearchEmployeeTableViewCell
        
        cell.setupData(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Xác nhận", message: "Chuyển", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Bỏ qua", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: { [weak self] action in
            self?.transferCustomer(seller: self?.data[indexPath.row].userName ?? "")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
