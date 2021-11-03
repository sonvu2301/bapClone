//
//  BASmartCusomterSellOptionViewController.swift
//  BAPMobile
//
//  Created by Emcee on 4/28/21.
//

import UIKit

protocol SelectCustomerSellOptionDelegate {
    func selectRow(item: BASmartComboSaleCustomerCommon, isSelect: Bool)
}

class BASmartCustomerSellOptionViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var seperateLine: UIView!
    
    var data = [BASmartComboSaleCustomerCommon]()
    var selectedItem = [BASmartComboSaleCustomerCommon]()
    var delegate: UpdateItemsSellOptionDelegate?
    var blurDelegate: BlurViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        
        title = "TÙY CHỌN HÀNG HÓA"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartCustomerSellOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerSellOptionTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        tableView.allowsSelection = false
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4").cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        seperateLine.drawDottedLine(view: seperateLine)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height: CGFloat = 80
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
    }
    
    private func endSelection() {
        delegate?.updateOption(selectedItems: selectedItem)
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        endSelection()
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        endSelection()
    }
    
}

extension BASmartCustomerSellOptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerSellOptionTableViewCell", for: indexPath) as! BASmartCustomerSellOptionTableViewCell
        let cellData = data[indexPath.row]
        cell.setupData(name: cellData.name ?? "",
                       price: String((cellData.price ?? 0).formattedWithSeparator),
                       item: cellData)
        cell.delegate = self
        
        return cell
    }
}

extension BASmartCustomerSellOptionViewController: SelectCustomerSellOptionDelegate {
    func selectRow(item: BASmartComboSaleCustomerCommon, isSelect: Bool) {
        if isSelect {
            selectedItem.append(item)
        } else {
            selectedItem = selectedItem.filter({$0.object != item.object})
        }
    }
}
