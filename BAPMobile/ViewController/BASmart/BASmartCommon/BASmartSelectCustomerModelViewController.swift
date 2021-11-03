//
//  BASmartSelectCustomerModelViewController.swift
//  BAPMobile
//
//  Created by Emcee on 10/19/21.
//

import UIKit

protocol BASmartCustomerChangeModelDelegate {
    func changeQuantity(isPlus: Bool, id: Int)
    func selectModel(isSelect: Bool, id: Int)
}

class BASmartSelectCustomerModelViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var data = [BASmartCustomerModel]()
    var delegate: BASmartSelectCustomerModelDelegate?
    let catalog = BASmartCustomerCatalogDetail.shared.model
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "CHỌN MÔ HÌNH"
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartSelectCustomerModelTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartSelectCustomerModelTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.allowsSelection = false
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor.black.cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.layer.borderWidth = 1
        buttonConfirm.layer.borderColor = UIColor().defaultColor().cgColor
        buttonConfirm.setViewCorner(radius: 5)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        delegate?.selectedModels(models: data)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension BASmartSelectCustomerModelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartSelectCustomerModelTableViewCell", for: indexPath) as! BASmartSelectCustomerModelTableViewCell
        cell.delegate = self
        let cellData = data.filter({$0.id == catalog[indexPath.row].id})
        if cellData.count > 0 {
            cell.setupQuantity(data: cellData.first ?? BASmartCustomerModel())
        } else {
            cell.isSelectCell = false
        }
        cell.setupData(name: catalog[indexPath.row])
        return cell
    }
}

extension BASmartSelectCustomerModelViewController: BASmartCustomerChangeModelDelegate {
    func changeQuantity(isPlus: Bool, id: Int) {
        let index = data.firstIndex(where: {$0.id == id}) ?? 0
        if isPlus {
            data[index].ri! += 1
        } else {
            if (data[index].ri ?? 1) > 1 {
                data[index].ri! -= 1
            }
        }
    }
    
    func selectModel(isSelect: Bool, id: Int) {
        if isSelect {
            data.append(BASmartCustomerModel(id: id, ri: 1))
        } else {
            guard let index = data.firstIndex(where: {$0.id == id}) else { return }
            data.remove(at: index)
        }
    }
}
