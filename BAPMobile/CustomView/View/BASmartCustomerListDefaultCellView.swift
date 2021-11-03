//
//  BASmartCustomerListDefaultCellView.swift
//  BAPMobile
//
//  Created by Emcee on 1/14/21.
//

import UIKit

class BASmartCustomerListDefaultCellView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    var isPhone = false
    
    var listId = [BASmartIdInfo]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BASmartCustomerListDefaultCellView", owner: self, options: nil)
        addSubview(contentView)
        textView.autocorrectionType = .no
        textView.delegate = self
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    func setupView(title: String, placeholder: String, isNumberOnly: Bool, content: String?, isAllowSelect: Bool, isPhone: Bool, isUsingLabel: Bool) {
        labelTitle.text = title
        textView.placeholder = placeholder
        if isNumberOnly {
            textView.keyboardType = .numberPad
        }
        
        if content != "" {
            textView.text = content
        }
        
        if isUsingLabel {
            labelContent.isHidden = false
            textView.isHidden = true
        }
        
        self.isPhone = isPhone
        textView.isUserInteractionEnabled = isAllowSelect
    }
    
    func getText() -> String {
        return textView.text ?? ""
    }
    
}

extension BASmartCustomerListDefaultCellView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isPhone {
            
            let currentText:String = textField.text!
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if updatedText.count != 10 || updatedText.first != "0" {
                textField.textColor = .red
            } else {
                textField.textColor = .black
            }
            
        }
        return true
    }
}
