//
//  BASmartCustomerListDropdownView.swift
//  BAPMobile
//
//  Created by Emcee on 2/2/21.
//

import UIKit
import DropDown

class BASmartCustomerListDropdownView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonDropdown: UIButton!
    
    let dropDown = DropDown()
    var content = [BASmartCustomerCatalogItems]()
    var showReasonDelegate: RateDelegate?
    var rateCondition = [String]()
    var listId = [BASmartIdInfo]()
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
        Bundle.main.loadNibNamed("BASmartCustomerListDropdownView", owner: self, options: nil)
        addSubview(contentView)
        dropDown.anchorView = buttonDropdown
        dropDown.width = buttonDropdown.frame.width - 30
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    func setupView(title: String, placeholder: String, content: [BASmartCustomerCatalogItems], name: String, id: Int) {
        labelTitle.text = title
        dropDown.dataSource = content.map({($0.name ?? "")})
        self.content = content
        buttonDropdown.setTitle(placeholder, for: .normal)
        
        //Add all item that rate > 0
        rateCondition = self.content.filter{($0.ri != nil && $0.ri ?? 0 > 0)}.map({$0.name ?? ""})
        
        if name != "" {
            buttonDropdown.setTitle(name, for: .normal)
            buttonDropdown.setTitleColor(.black, for: .normal)
        }
        
        self.id = id
    }
    
    func setupButton(title: String) {
        buttonDropdown.setTitle(title, for: .normal)
        buttonDropdown.setTitleColor(.black, for: .normal)
        let id = content.filter({$0.name == title}).map({$0.id}).first
        self.id = (id ?? 0) ?? 0
    }
    
    @IBAction func buttonDropDownTap(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.buttonDropdown.setTitle(item, for: .normal)
            self?.buttonDropdown.setTitleColor(.black, for: .normal)
            let condition = self?.rateCondition.filter({$0 == item}).count == 0 ? true : false
            self?.showReasonDelegate?.showReason(isShow: condition)
            let id = self?.content.filter({$0.name == item}).map({$0.id}).first
            self?.id = (id ?? 0) ?? 0
            self?.listId = [BASmartIdInfo]()
            self?.listId.append(BASmartIdInfo(id: self?.id)) 
        }
    }
}
