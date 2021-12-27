//
//  BASmartCustomerListCatalogView.swift
//  BAPMobile
//
//  Created by Emcee on 12/2/21.
//

import UIKit

protocol BASmartCustomerListOpenCatalogDelegate {
    func buttonTap()
}

class BASmartCustomerListCatalogView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var buttonOpen: UIButton!
    var delegate: BASmartCustomerListOpenCatalogDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setupView(name: String, content: String) {
        labelName.text = name
        labelContent.text = content
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BASmartCustomerListCatalogView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    @IBAction func buttonOpenTap(_ sender: Any) {
        delegate?.buttonTap()
    }
}
