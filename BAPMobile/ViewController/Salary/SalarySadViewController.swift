//
//  SalarySadViewController.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 14/03/2022.
//

import UIKit

class SalarySadViewController: BaseViewController {
    @IBOutlet weak var yearView: DateHorizontal!
    @IBOutlet weak var tableSalary: UITableView!
    @IBOutlet weak var imageBackground: UIImageView!
    
    var dataModel = SalarySadData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TẠM ỨNG LƯƠNG THÁNG"
        setupView()
        // Do any additional setup after loading the view.
    }
    private func setupView(){
        yearView.setType(type: .year)
        yearView.delegate = self
        tableSalary.dataSource = self
        tableSalary.delegate = self
        tableSalary.register(UINib(nibName: "SalarySadTableViewCell", bundle: nil), forCellReuseIdentifier: "SalarySadTableViewCell")
        getData(yearIndex: Date().getComponents().year ?? 0)
    }
    private func getData(yearIndex: Int){
        Network.shared.GetSalarySad(yearIndex: yearIndex) { [weak self] (data) in
            self?.dataModel = data?.data ?? SalarySadData()
            self?.imageBackground.downloaded(from: self?.dataModel.bgimage ?? "", contentMode: .scaleAspectFit)
            
            self?.tableSalary.reloadData()
        }
    }

}

extension SalarySadViewController: IDateDelegate{
    func selectDateDelegate(date: Date) {
        getData(yearIndex: date.getComponents().year ?? 0)
    }
}
extension SalarySadViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalarySadTableViewCell", for: indexPath) as! SalarySadTableViewCell
        cell.setupView(item: dataModel.items?[indexPath.row] ?? SalarySadItem())
        return cell
    }
    
    
}
