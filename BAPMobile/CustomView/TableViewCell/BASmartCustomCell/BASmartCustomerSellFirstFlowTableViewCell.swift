//
//  BASmartCustomerSellFirstFlowTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 4/14/21.
//

import UIKit

class BASmartCustomerSellFirstFlowTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDong: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var seperateView: UIView!
    
    @IBOutlet weak var textViewPrice: UITextField!
    @IBOutlet weak var textViewStartDate: UITextField!
    @IBOutlet weak var textViewMonth: UITextField!
    
    @IBOutlet weak var viewRequire: UIView!
    
    var datePicker :UIDatePicker!
    
    var number = 1
    var price = 0
    var totalPrice = 0
    var index = 0
    var data = BASmartComboSaleCustomerCommon()
    var delegate: ChangeCountTotalMoneyDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonMinus.setViewCircle()
        buttonPlus.setViewCircle()
        textViewPrice.delegate = self
        textViewMonth.delegate = self
        textViewStartDate.delegate = self
        textViewPrice.keyboardType = .numberPad
        textViewMonth.keyboardType = .numberPad
        setupPickdate()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(data: BASmartComboSaleCustomerCommon, name: String, price: Int, count: Int, isEven: Bool) {
        labelName.text = name
        textViewPrice.text = String(price.formattedWithSeparator)
        number = count
        labelCount.text = String(count)
        if isEven {
            contentView.backgroundColor = UIColor(hexString: "DCDCDC")
        }
        self.price = price
        self.data = data
        
        viewRequire.isHidden = !(data.req ?? true)
        textViewPrice.isUserInteractionEnabled = !(data.fix ?? true)
        textViewPrice.textColor = data.fix == true ? .black : .orange
        labelDong.textColor = data.fix == true ? .black : .orange
        seperateView.isHidden = data.fix ?? false
        textViewMonth.text = String(data.month ?? 0)
        textViewStartDate.text = Date().millisecToDate(time: data.date ?? 0)
    }
    
    private func setupPickdate() {
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: 500, height: 200))
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        textViewStartDate.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 500, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        textViewStartDate.inputAccessoryView = toolBar
        textViewStartDate.autocorrectionType = .no
        textViewStartDate.allowsEditingTextAttributes = false
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    @objc func datePickerDone() {
        textViewStartDate.resignFirstResponder()
    }
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textViewStartDate.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func buttonPlusTap(_ sender: Any) {
        number += 1
        labelCount.text = String(number)
        
        delegate?.changeCount(price: price, isPlus: true, index: index)
    }
    
    @IBAction func buttonMinusTap(_ sender: Any) {
        if number > 1 {
            number -= 1
            delegate?.changeCount(price: price, isPlus: false, index: index)
        }
        labelCount.text = String(number)
    }
    
    override func prepareForReuse() {
        labelName.text = ""
        textViewPrice.text = ""
        labelCount.text = "1"
        textViewMonth.text = ""
        textViewStartDate.text = ""
        contentView.backgroundColor = .white
    }
}

extension BASmartCustomerSellFirstFlowTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
        if textField == textViewPrice {
            updatedString = updatedString?.replacingOccurrences(of: ".", with: "")
            price = Int(updatedString ?? "") ?? 0
            textField.text = price.formattedWithSeparator
            
            delegate?.changePrice(price: price, index: index)
            return false
        } else if textField == textViewMonth {
            let month = Int(updatedString ?? "0") ?? 0
            if month > 60 {
                textViewMonth.text = "60"
            } else {
                textViewMonth.text = String(month)
            }
            
            return false
        } else {
            return true
        }
        
    }
}
