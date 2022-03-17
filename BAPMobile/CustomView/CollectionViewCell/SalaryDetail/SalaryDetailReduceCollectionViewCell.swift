//
//  SalaryDetailReduceCollectionViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 09/03/2022.
//

import UIKit

class SalaryDetailReduceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var reduceTable: UITableView!
    var data = [SalaryDefaultData()]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
        
        reduceTable.dataSource = self
        reduceTable.delegate = self
        
        reduceTable.register(UINib(nibName: "SalaryDetailCellLabel", bundle: nil), forCellReuseIdentifier: "SalaryDetailCellLabel")
    }
    
    override func prepareForReuse() {
    }
    func setupView(list: [SalaryDefaultData]){
        self.data = list
        reduceTable.reloadData()
    }
}
extension SalaryDetailReduceCollectionViewCell:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryDetailCellLabel", for: indexPath) as! SalaryDetailCellLabel
        cell.setupView(item: self.data[indexPath.row])
        return cell
    }
}
