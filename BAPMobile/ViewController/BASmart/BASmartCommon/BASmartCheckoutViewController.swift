//
//  BASmartCheckoutViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/19/21.
//

import UIKit

class BASmartCheckoutViewController: UIViewController {

    @IBOutlet weak var buttoncancel: UIButton!
    @IBOutlet weak var buttonAccept: UIButton!
    
    var location = MapLocation(lng: 0, lat: 0)
    var delegate: BlurViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        buttoncancel.setViewCorner(radius: 5)
        buttonAccept.setViewCorner(radius: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.hideBlur()
    }
    
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        delegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonAcceptTap(_ sender: Any) {
        Network.shared.BASmartCheckout(lat: location.lat, long: location.lng, opt: 1) { [weak self] (data) in
            if data?.error_code != 0 {
                self?.presentBasicAlert(title: "", message: data?.data ?? "", buttonTittle: "Đồng ý")
            } else {
                let alert = UIAlertController(title: "Thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
                    self?.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseBASmart"), object: nil)
                
                }))
                self?.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}

