//
//  SalaryDetailTotalMoneyCollectionViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 09/03/2022.
//

import UIKit
// Tổng thu
class SalaryDetailTotalMoneyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var totalCollectTable: UITableView!
    var data = [SalaryDefaultData()]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
        
        totalCollectTable.dataSource = self
        totalCollectTable.delegate = self
        
        totalCollectTable.register(UINib(nibName: "SalaryDetailCellLabel", bundle: nil), forCellReuseIdentifier: "SalaryDetailCellLabel")
        
    }
    
    override func prepareForReuse() {
    }
    func setupView(list: [SalaryDefaultData]){
        self.data = list
        totalCollectTable.reloadData()
    }
}
extension SalaryDetailTotalMoneyCollectionViewCell:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryDetailCellLabel", for: indexPath) as! SalaryDetailCellLabel
        cell.setupView(item: data[indexPath.row])
        return cell
    }
}
