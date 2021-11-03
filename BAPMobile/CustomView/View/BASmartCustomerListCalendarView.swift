//
//  BASmartCustomerListCalendarView.swift
//  BAPMobile
//
//  Created by Emcee on 2/2/21.
//

import UIKit

class BASmartCustomerListCalendarView: UIView{

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        buttonClose.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BASmartCustomerListCalendarView", owner: self, options: nil)
        addSubview(contentView)
        let origImage = UIImage(named: "date")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        
        //set toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 35))
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        toolbar.updateFocusIfNeeded()
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            
        }
        datePicker.datePickerMode = .date
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.autocorrectionType = .no
        textField.allowsEditingTextAttributes = false
        
        icon.image = tintedImage
        icon.tintColor = UIColor().defaultColor()
        buttonClose.isHidden = true
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    func setupView(title: String, birth: String, placeHolder: String) {
        labelTitle.text = title
        textField.text = birth
        textField.placeholder = placeHolder
    }
    
    @IBAction func buttonCloseTap(_ sender: Any) {
        buttonClose.isHidden = true
        textField.text = ""
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textField.text = formatter.string(from: datePicker.date)
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.endEditing(true)
    }
    
}
