//
//  SalaryDetailKeepingCollectionViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 09/03/2022.
//

import UIKit

class SalaryDetailKeepingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var keepingTable: UITableView!
    
    var data = [SalaryDefaultData()]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
        
        keepingTable.dataSource = self
        keepingTable.delegate = self
        
        keepingTable.register(UINib(nibName: "SalaryDetailCellLabel", bundle: nil), forCellReuseIdentifier: "SalaryDetailCellLabel")
        
    }
    
    override func prepareForReuse() {
    }
    func setupView(list: [SalaryDefaultData]){
        self.data = list
        keepingTable.reloadData()
    }
}
extension SalaryDetailKeepingCollectionViewCell: UITableViewDelegate,
                                                 UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryDetailCellLabel", for: indexPath) as! SalaryDetailCellLabel
        cell.setupView(item: self.data[indexPath.row])
        return cell
    }
    
}
