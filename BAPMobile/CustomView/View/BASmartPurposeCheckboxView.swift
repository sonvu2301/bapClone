//
//  BASmartPurposeCheckbox.swift
//  BAPMobile
//
//  Created by Emcee on 11/8/21.
//

import UIKit

protocol PurposeCheckboxDelegate {
    func selectedItem(items: [BASmartCustomerCatalogItems])
}

class BASmartPurposeCheckboxView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let catalog = BASmartCustomerCatalogDetail.shared.purpose
    var data = [BASmartCustomerCatalogItems]()
    var delegate: PurposeCheckboxDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BASmartPurposeCheckboxView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CheckboxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckboxTableViewCell")
        tableView.rowHeight = 30
    }

}

extension BASmartPurposeCheckboxView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxTableViewCell", for: indexPath) as! CheckboxTableViewCell
        let index = indexPath.row
        cell.delegate = self
        let isCheck = data.contains(where: {$0.id == catalog[index].id})
        
        cell.setupCell(isCheck: isCheck, item: catalog[index])
        return cell
    }
    
}

extension BASmartPurposeCheckboxView: CheckboxStateDelegate {
    func checkbox(isCheck: Bool, id: Int) {
        guard let item = catalog.filter({$0.id == id}).first else { return }
        if isCheck {
            data.append(item)
        } else {
            data.removeAll(where: {$0.id == id})
        }
    }
}
