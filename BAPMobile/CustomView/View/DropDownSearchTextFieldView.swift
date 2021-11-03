//
//  DropDownSearchTextFieldView.swift
//  BAPMobile
//
//  Created by Emcee on 6/1/21.
//

import UIKit
import DropDown

class DropDownSearchTextFieldView: UIView, UITextFieldDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var dropDown = DropDown()
    var content = [BASmartCustomerCatalogItems]()
    var contentFiltered = [BASmartCustomerCatalogItems]()
    var id = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("DropDownSearchTextFieldView", owner: self, options: nil)
        addSubview(contentView)
        
        dropDown.anchorView = textField
        dropDown.width = textField.frame.width
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! + 10)
        
        textField.addTarget(self, action: #selector(touchTextField), for: .touchDown)
        textField.delegate = self
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    func setupView(title: String, content: [BASmartCustomerCatalogItems], id: Int, placeholder: String) {
        labelTitle.text = title
        textField.placeholder = placeholder
        dropDown.dataSource = content.map({($0.name ?? "")})
        self.content = content
        contentFiltered = content
        self.id = id
    }
    
    @objc func touchTextField() {
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.textField.text = item
            
            let id = self?.contentFiltered.filter({$0.name == item}).map({$0.id}).first
            self?.id = (id ?? 0) ?? 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText:String = textField.text!
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        contentFiltered = content.filter({$0.name?.lowercased().contains(updatedText.lowercased()) == true})
        dropDown.dataSource = contentFiltered.map({$0.name ?? ""})
        touchTextField()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        touchTextField()
    }
}
