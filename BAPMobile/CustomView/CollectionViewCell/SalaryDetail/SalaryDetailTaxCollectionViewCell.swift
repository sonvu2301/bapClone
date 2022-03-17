//
//  SalaryDetailTaxCollectionViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 09/03/2022.
//

import UIKit

class SalaryDetailTaxCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var taxTable: UITableView!
    var data = SalaryDetailTax()
    var items = [SalaryDetailTaxItems()]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
        taxTable.dataSource = self
        taxTable.delegate = self
        taxTable.register(UINib(nibName: "SalaryDetailTaxCell", bundle: nil), forCellReuseIdentifier: "SalaryDetailTaxCell")
    }
    
    override func prepareForReuse() {
    }
    func setupView(item: SalaryDetailTax){
        
        self.data = item
        items = item.items ?? [SalaryDetailTaxItems()]
        items = items.reversed()
        taxTable.reloadData()
    }
}
extension SalaryDetailTaxCollectionViewCell:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryDetailTaxCell", for: indexPath) as! SalaryDetailTaxCell
        cell.setupView(item: items[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
        let minHeight = 20;
        let totalHeight = Int(self.frame.size.height) - 50
        let totalSalary = items.map( {$0.salary ?? 0}).reduce(0, +)
        let salaryItem = items[indexPath.row].salary ?? 0
        var height = NSDecimalNumber(decimal: (salaryItem / totalSalary) * Decimal(totalHeight)).doubleValue

        if height < Double(minHeight) {
            height = Double(minHeight)
        }
        
        return CGFloat(height)
    }
}
