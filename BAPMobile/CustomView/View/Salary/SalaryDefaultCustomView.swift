//
//  SalaryDefaultCustomView.swift
//  BAPMobile
//
//  Created by Emcee on 9/16/21.
//

import UIKit

class SalaryDefaultCustomView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var iconView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("SalaryDefaultCustomView", owner: self, options: nil)
        addSubview(contentView)
        iconView.setViewCircle()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }

}
