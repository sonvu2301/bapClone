//
//  AlertConfirmViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/25/21.
//

import UIKit

protocol AlertActionDelegate {
    func confirm(kind: Int, message: String)
    func delete(kind: Int, message: String)
}

class AlertConfirmViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var imageIcon: UIImageView!
    
    var delegate: AlertActionDelegate?
    var contentString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.setViewCorner(radius: 5)
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "BEBEBE").cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        imageIcon.image = imageIcon.image?.withRenderingMode(.alwaysTemplate)
        imageIcon.tintColor = UIColor.green
        
        labelContent.text = contentString
        
    }
    
    @IBAction func buttonRemoveTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        delegate?.confirm(kind: 0, message: "")
        self.dismiss(animated: true, completion: nil)
    }
    
}
