//
//  BASmartWarehouseCatalogViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/15/21.
//

import UIKit

protocol BASmartWarehouseCatalogDelegate {
    func selectItem(items: [BASmartDetailInfo])
}

class BASmartWarehouseCatalogViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var catalog = [BASmartDetailInfo]()
    var data = [BASmartDetailInfo]()
    var delegate: BASmartWarehouseCatalogDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "CHỌN DỰ ÁN TIẾP XÚC"
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CheckboxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckboxTableViewCell")
        tableView.rowHeight = 40
        
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4", alpha: 0.5).cgColor
    }

    @IBAction func buttonConfirmTap(_ sender: Any) {
        delegate?.selectItem(items: data)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension BASmartWarehouseCatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxTableViewCell", for: indexPath) as! CheckboxTableViewCell
        let index = indexPath.row
        cell.delegate = self
        let isCheck = data.contains(where: {$0.id == catalog[index].id})
        
        cell.setupCellWarehouse(isCheck: isCheck, item: catalog[index])
        return cell
        
    }
    
    
}

extension BASmartWarehouseCatalogViewController: CheckboxStateDelegate {
    func checkbox(isCheck: Bool, id: Int) {
        guard let item = catalog.filter({$0.id == id}).first else { return }
        if isCheck {
            data.append(item)
        } else {
            data.removeAll(where: {$0.id == id})
        }
    }
}
