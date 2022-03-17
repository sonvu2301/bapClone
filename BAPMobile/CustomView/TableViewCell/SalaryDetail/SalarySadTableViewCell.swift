//
//  SalarySadTableViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 14/03/2022.
//

import UIKit

class SalarySadTableViewCell: UITableViewCell {
    @IBOutlet weak var imageMonth: UIImageView!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var sadTitle: UILabel!
    @IBOutlet weak var sadMoney: UILabel!
    @IBOutlet weak var otherTitle: UILabel!
    @IBOutlet weak var otherMoney: UILabel!
    
    @IBOutlet weak var moneyOtherTableView: UITableView!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    var dataOther = [SalarySadOtherItem()]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        moneyOtherTableView.dataSource = self
        moneyOtherTableView.delegate = self
        moneyOtherTableView.register(UINib(nibName: "SalaryDetailCellLabel", bundle: nil), forCellReuseIdentifier: "SalaryDetailCellLabel")
        
        // Configure the view for the selected state
    }
    func setupView(item: SalarySadItem){
        imageMonth.downloaded(from: item.imageSrc ?? "", contentMode: .scaleAspectFit)
        let monthStr = Date().toDate(monthIndex: item.monthIndex ?? 0).toDateFormat(format: "MM")
        lblMonth.text = monthStr
        
        sadTitle.text = "Khoản ứng lương \(item.percent ?? 0)%"
        sadMoney.text = (item.advance ?? 0).formatPrice() + " đ"
        
        otherMoney.text = (item.moneyOther ?? 0).formatPrice() + " đ"
        totalLabel.text = ((item.moneyOther ?? 0) + (item.advance ?? 0)).formatPrice() + " đ"
        
        dataOther = item.otherList ?? [SalarySadOtherItem()]
        moneyOtherTableView.reloadData()
    }

}
extension SalarySadTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  dataOther.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryDetailCellLabel", for: indexPath) as! SalaryDetailCellLabel
        cell.setupView(name: dataOther[indexPath.row].name ?? ""
                       , value: (dataOther[indexPath.row].value ?? 0).formatPrice() + " đ")
        return cell
    }
    
    
}
