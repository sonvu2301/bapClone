//
//  BASmartMainSmallCustomView.swift
//  BAPMobile
//
//  Created by Emcee on 12/29/20.
//

import UIKit

class BASmartMainSmallCustomView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTimeNumber: UILabel!
    @IBOutlet weak var labelTimeNumberName: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BASmartMainSmallCustomView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
    func setupView(name: String, timeNumber: String, timeNumberName: String, totalNumber: String) {
        labelName.text = name
        labelTimeNumber.text = timeNumber
        labelTimeNumberName.text = timeNumberName
        labelTotal.text = totalNumber
    }
}

