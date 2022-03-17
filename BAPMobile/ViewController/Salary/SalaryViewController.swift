//
//  SalaryViewController.swift
//  BAPMobile
//
//  Created by Emcee on 9/13/21.
//

import UIKit




class SalaryViewController: BaseViewController {
 
    @IBOutlet weak var dateView: DateHorizontal!
    @IBOutlet weak var tableView: UITableView!
    var data = SalaryModelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "BẢNG TÍNH LƯƠNG THÁNG"
    }
    
    
    private func setupView() {
        dateView.delegate = self
        dateView.setType(type: .year)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SalaryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "SalaryInfoTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 180
    }
    private func getData(year: Int) {
        Network.shared.GetSalaryInfo(year: year) { [weak self] (data) in
            self?.data = data ?? SalaryModelData()
            self?.tableView.reloadData()
        }
    }
    
}

extension SalaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryInfoTableViewCell", for: indexPath) as! SalaryInfoTableViewCell
        cell.setupData(data: data.items?[indexPath.row] ?? SalaryModelItem())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SalaryDetailViewController") as! SalaryDetailViewController
        vc.data = data.items?[indexPath.row] ?? SalaryModelItem()
        vc.hideBottom()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension SalaryViewController: IDateDelegate{  
    func selectDateDelegate(date: Date) {
        self.getData(year: date.getComponents().year ?? 0)
    }
}


 
