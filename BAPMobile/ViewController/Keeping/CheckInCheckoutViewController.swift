//
//  KeepingCheckInCheckoutViewController.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 15/03/2022.
//

import UIKit
import CoreLocation
protocol IRetakeImageKeeping{
    func retakeImageDelegate()
}

class CheckInCheckoutViewController: UIViewController {
    
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var retakeImage: UIImageView!
    @IBOutlet weak var imageContent: UIImageView!
    
    @IBOutlet weak var btnKeeping: UIButton!
    @IBOutlet weak var kindKeepingView: DropdownView!
    
    
    @IBOutlet weak var actionKeepingView: UIView!
    var imgContent = UIImage()
    var reTakeImageDelete : IRetakeImageKeeping?
    var catalogData = KeepingCatalogData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TIẾN HÀNH CHẤM CÔNG"
        navigationController?.setNavigationBarHidden(true, animated: false)
        closeIcon.setImageColor(color: .white)
        
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
        retakeImage.setImageColor(color: .yellow)
        retakeImage.isUserInteractionEnabled = true
        retakeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(retakeImageFunc)))
        setupView()
        getData()
        
        kindKeepingView.layer.cornerRadius = 5
        kindKeepingView.layer.borderWidth = 1
        kindKeepingView.layer.borderColor = UIColor.lightGray.cgColor
        
        btnKeeping.layer.cornerRadius = 5
        
    }
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func retakeImageFunc(){
        self.dismiss(animated: true, completion: nil)
        reTakeImageDelete?.retakeImageDelegate()
    }
    func setupView(){
        self.imageContent.image = imgContent
    }
    func getData(){
        let location = CLLocationManager()
        
        Network.shared.getTimeKeepingCatalog(location: location.getCurrentLocation()){ [weak self] (data) in
            
            self?.catalogData = data ?? KeepingCatalogData()
            self?.bindOptView(list: self?.catalogData.actionList ?? [Catalog()])
            self?.kindKeepingView.setupView(data: data?.dskindList ?? [Catalog()])
        }
    }
    func bindOptView(list: [Catalog]){
         let radioView = RadioView()
        radioView.setupView(list: list)
        radioView.constrainFull(parentView: actionKeepingView)
        
    }
}
