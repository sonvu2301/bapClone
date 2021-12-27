//
//  BASmartCustomerListAddressView.swift
//  BAPMobile
//
//  Created by Emcee on 12/3/21.
//

import UIKit

protocol OpenSelectMapDelegate {
    func openButtonTap()
}


class BASmartCustomerListAddressView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var buttonAddress: UIButton!
    
    var delegate: OpenSelectMapDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setupView(name: String, address: String) {
        labelName.text = name
        labelAddress.text = address
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BASmartCustomerListAddressView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    
    
    @IBAction func buttonAddressTap(_ sender: Any) {
        delegate?.openButtonTap() 
    }
    
}
