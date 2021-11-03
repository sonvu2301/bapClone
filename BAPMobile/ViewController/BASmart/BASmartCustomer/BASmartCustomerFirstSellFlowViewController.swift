//
//  BASmartCustomerFirstSellFlowViewController.swift
//  BAPMobile
//
//  Created by Emcee on 4/13/21.
//

import UIKit
import DropDown


protocol ChangeCountTotalMoneyDelegate {
    func changeCount(price: Int, isPlus: Bool, index: Int)
    func changePrice(price: Int, index: Int)
}

protocol UpdateItemsSellOptionDelegate {
    func updateOption(selectedItems: [BASmartComboSaleCustomerCommon])
}

class BASmartCustomerFirstSellFlowViewController: BaseViewController {

    @IBOutlet weak var buttonSelectProcduct: UIButton!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var buttonCheckboxChange: UIButton!
    @IBOutlet weak var buttonCheckboxVAT: UIButton!
    @IBOutlet weak var buttonCheckboxCoeffcient: UIButton!
    @IBOutlet weak var buttonCoefficient: UIButton!
    
    @IBOutlet weak var textFieldChange: UITextField!
    
    @IBOutlet weak var labelNameProduct: UILabel!
    @IBOutlet weak var labelNumberCount: UILabel!
    @IBOutlet weak var labelTotalMoney: UILabel!
    @IBOutlet weak var labelVATMoney: UILabel!
    @IBOutlet weak var labelSumMoney: UILabel!
    @IBOutlet weak var labelFooterNote: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    let dropDown = DropDown()
    var data = BASmartComboSaleDetailData()
    var tableData = [BASmartComboSaleCustomerCommon]()
    var tableOptionData = [BASmartComboSaleCustomerCommon]()
    var numbers = [Int]()
    var count = 1
    var totalPrice = 0
    var checkboxChange = false
    var checkboxVAT = false
    var checkboxCoefficient = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        buttonPlus.setViewCircle()
        buttonMinus.setViewCircle()
        labelTotalMoney.text = String(totalPrice.formattedWithSeparator) + " đ"
        
        dropDown.anchorView = buttonCoefficient
        dropDown.dataSource = ["0.50","1.00","1.75","2.00"]
        dropDown.direction = .any
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.buttonCoefficient.setTitle(item, for: .normal)
        }
        
        tableView.register(UINib(nibName: "BASmartCustomerSellFirstFlowTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerSellFirstFlowTableViewCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        textFieldChange.isUserInteractionEnabled = false
        textFieldChange.keyboardType = .numberPad
        
        let origImage = UIImage(named: "menu")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        buttonSelectProcduct.setImage(tintedImage, for: .normal)
        buttonSelectProcduct.tintColor = UIColor().defaultColor()
        
        changeCheckbox(button: buttonCheckboxCoeffcient, state: checkboxCoefficient)
        
        showKeyboard()
        changePrice()
    }
        
    private func changeCheckbox(button: UIButton, state: Bool) {
        let checkImage = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        let uncheckImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        let image = state == true ? checkImage : uncheckImage
        button.setImage(image, for: .normal)
    }
    
    private func changePrice() {
        totalPrice = 0
        tableData.forEach { [weak self] (item) in
            self?.totalPrice += (item.count ?? 1) * (item.price ?? 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            
            self?.labelTotalMoney.text = String((self?.totalPrice ?? 0).formattedWithSeparator) + " đ"
            if self?.checkboxVAT == true {
                let vatPrice = (self?.totalPrice ?? 1) / 10
                self?.labelVATMoney.text = String(vatPrice.formattedWithSeparator) + " đ"
                self?.labelSumMoney.text = String((vatPrice + (self?.totalPrice ?? 0)).formattedWithSeparator) + " đ"
            } else {
                self?.labelSumMoney.text = String((self?.totalPrice ?? 0).formattedWithSeparator) + " đ"
            }
        })
    }
    
    func setNumbers() {
        for i in 0..<tableData.count {
            tableData[i].count = 1
        }
        changePrice()
    }
    
    func buttonCountTap() {
        labelNumberCount.text = String(count)
        for i in 0..<tableData.count {
            tableData[i].count = count
        }
        changePrice()
        tableData = tableData.sorted(by: { ($0.order ?? 0) < ($1.order ?? 0) })
        tableView.reloadData()
    }
    
    @IBAction func buttonSelectProductTap(_ sender: Any) {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCustomerSellOptionViewController") ?? UIViewController()) as! BASmartCustomerSellOptionViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 550)
        popoverContent.delegate = self
        popoverContent.blurDelegate = self
        popoverContent.data = tableOptionData
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 200, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buttonPlusTap(_ sender: Any) {
        count += 1
        buttonCountTap()
    }
    
    @IBAction func buttonMinusTap(_ sender: Any) {
        if count > 1 {
            count -= 1
        }
        buttonCountTap()
    }
    
    @IBAction func buttonCheckboxChangeTap(_ sender: Any) {
        checkboxChange = !checkboxChange
        changeCheckbox(button: buttonCheckboxChange, state: checkboxChange)
        textFieldChange.text = checkboxChange == true ? "1" : "0"
        textFieldChange.isUserInteractionEnabled = checkboxChange
    }
    
    @IBAction func buttonCheckboxVATTap(_ sender: Any) {
        checkboxVAT = !checkboxVAT
        changeCheckbox(button: buttonCheckboxVAT, state: checkboxVAT)
        switch checkboxVAT {
        case true:
            let VATmoney = totalPrice / 10
            labelVATMoney.text = String(VATmoney.formattedWithSeparator) + " đ"
            labelSumMoney.text = String((totalPrice + VATmoney).formattedWithSeparator) + " đ"
        case false:
            labelVATMoney.text = " đ"
            labelSumMoney.text = String(totalPrice.formattedWithSeparator) + " đ"
        }
    }
    
    @IBAction func buttonCheckboxCoeffientTap(_ sender: Any) {
        checkboxCoefficient = !checkboxCoefficient
        changeCheckbox(button: buttonCheckboxCoeffcient, state: checkboxCoefficient)
    }
    
    @IBAction func buttonCoefficientTap(_ sender: Any) {
        dropDown.show()
    }
    
}

extension BASmartCustomerFirstSellFlowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerSellFirstFlowTableViewCell", for: indexPath) as! BASmartCustomerSellFirstFlowTableViewCell
        let cellData = tableData[indexPath.row]
        cell.setupView(data: cellData,
                       name: cellData.name ?? "",
                       price: cellData.price ?? 0,
                       count: cellData.count ?? 1,
                       isEven: indexPath.row % 2 == 0 ? true : false)
        cell.delegate = self
        cell.index = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") { [weak self] (action, view, completionHandler) in
                                            self?.deleteRowAction(index: indexPath)
                                            completionHandler(true)
        }
        let delete = UIImage(named: "delete")?.resizeImage(targetSize: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        action.image = delete
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    private func deleteRowAction(index: IndexPath) {
        tableOptionData.append(tableData[index.row])
        tableData.remove(at: index.row)
        tableData = tableData.sorted(by: { ($0.order ?? 0) < ($1.order ?? 0) })
        tableView.reloadData()
        changePrice()
    }
}


extension BASmartCustomerFirstSellFlowViewController: ChangeCountTotalMoneyDelegate {
    func changePrice(price: Int, index: Int) {
        tableData[index].price = price
        changePrice()
    }
    
    func changeCount(price: Int, isPlus: Bool, index: Int) {
        totalPrice = isPlus == true ? totalPrice + price : totalPrice - price
        let vatPrice = totalPrice / 10
        let sumPrice = checkboxVAT == true ? (totalPrice / 100 * 110) : totalPrice
        tableData[index].count = isPlus == true ? (tableData[index].count ?? 1) + 1 : (tableData[index].count ?? 1) - 1
        labelTotalMoney.text = String(totalPrice.formattedWithSeparator) + " đ"
        labelSumMoney.text = String(sumPrice.formattedWithSeparator) + " đ"
        labelVATMoney.text = checkboxVAT == true ? String(vatPrice.formattedWithSeparator) + " đ" : " đ"
    }
}

extension BASmartCustomerFirstSellFlowViewController: UpdateItemsSellOptionDelegate {
    func updateOption(selectedItems: [BASmartComboSaleCustomerCommon]) {
        selectedItems.forEach { [weak self] (item) in
            self?.tableData.append(item)
            self?.tableData[count - 1].count = 1
            self?.tableData = self?.tableData.sorted(by: { ($0.order ?? 0) < ($1.order ?? 0) }) ?? [BASmartComboSaleCustomerCommon]()
            self?.tableOptionData = self?.tableOptionData.filter({$0.object != item.object}) ?? [BASmartComboSaleCustomerCommon]()
        }
        tableView.reloadData()
        
        changePrice()
    }
    
}
