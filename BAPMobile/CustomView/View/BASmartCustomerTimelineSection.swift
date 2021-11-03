//
//  BASmartCustomerTimelineSection.swift
//  BAPMobile
//
//  Created by Emcee on 1/29/21.
//

import UIKit

class BASmartCustomerTimelineSection: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BASmartCustomerTimelineSection", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
}
