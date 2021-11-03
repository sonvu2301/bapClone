//
//  BASmartVehiclePreviewImageSecondViewController.swift
//  BAPMobile
//
//  Created by Emcee on 7/9/21.
//

import UIKit

class BASmartVehiclePreviewImageSecondViewController: UIViewController {

    @IBOutlet weak var viewCreator: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewTime: BASmartCustomerListDefaultCellView!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    var type = VehiclePreviewImageType.list
    var creator = ""
    var time = ""
    var descrip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupView(type: VehiclePreviewImageType) {
        
        switch type {
        case .list, .saved:
            viewCreator.setupView(title: "Người tạo",
                                  placeholder: "",
                                  isNumberOnly: false,
                                  content: creator,
                                  isAllowSelect: false,
                                  isPhone: false,
                                  isUsingLabel: false)
            
            viewTime.setupView(title: "Thời gian",
                               placeholder: "",
                               isNumberOnly: false,
                               content: time,
                               isAllowSelect: false,
                               isPhone: false,
                               isUsingLabel: false)
        case .create:
            viewCreator.setupView(title: "Người tạo",
                                  placeholder: "",
                                  isNumberOnly: false,
                                  content: UserInfo.shared.name,
                                  isAllowSelect: false,
                                  isPhone: false,
                                  isUsingLabel: false)
            
            viewTime.setupView(title: "Thời gian",
                               placeholder: "",
                               isNumberOnly: false,
                               content: Date().millisecToDateHour(time: Int(Date().timeIntervalSinceReferenceDate)),
                               isAllowSelect: false,
                               isPhone: false,
                               isUsingLabel: false)
            
        }
        
        textViewDescription.isUserInteractionEnabled = type == .list ? false : true
    }
    
}
