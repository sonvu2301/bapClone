//
//  ContactViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/14/20.
//

import UIKit

enum ContactPlace {
    case hanoi, haiphong, miennam, mientrung
    
    var code: String {
        switch self {
        case .hanoi:
            return "[HN]"
        case .haiphong:
            return "[HP]"
        case .miennam:
            return "[MN]"
        case .mientrung:
            return "[MT]"
        }
    }
}

class ContactViewController: BaseViewController {
    
    @IBOutlet weak var place1Button: UIButton!
    @IBOutlet weak var place2Button: UIButton!
    @IBOutlet weak var place3Button: UIButton!
    @IBOutlet weak var place4Button: UIButton!
    
    @IBOutlet weak var place1Underline: UIView!
    @IBOutlet weak var place2Underline: UIView!
    @IBOutlet weak var place3Underline: UIView!
    @IBOutlet weak var place4Underline: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var data = [GeneralContactListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Danh bạ nhân viên"
    }
    
    private func setupView() {
        //Setup Child View Controller
        scrollView.contentSize = CGSize(width: view.frame.width * 4, height: 0)
        scrollView.isScrollEnabled = false
        scrollView.isPagingEnabled = true
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        let vc4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc3.view.frame = CGRect(x: view.frame.width * 2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc4.view.frame = CGRect(x: view.frame.width * 3, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        vc1.data = data.filter({$0.branch?.code == ContactPlace.hanoi.code}).first ?? GeneralContactListData()
        vc2.data = data.filter({$0.branch?.code == ContactPlace.haiphong.code}).first ?? GeneralContactListData()
        vc3.data = data.filter({$0.branch?.code == ContactPlace.miennam.code}).first ?? GeneralContactListData()
        vc4.data = data.filter({$0.branch?.code == ContactPlace.mientrung.code}).first ?? GeneralContactListData()
        
        vc1.setupView()
        vc2.setupView()
        vc3.setupView()
        vc4.setupView()
        
        //Setup Button
        DispatchQueue.main.async { [weak self] in
            self?.place1Button.titleLabel?.textColor = UIColor().defaultColor()
            self?.place2Button.titleLabel?.textColor = .gray
            self?.place3Button.titleLabel?.textColor = .gray
            self?.place4Button.titleLabel?.textColor = .gray
            self?.place1Underline.backgroundColor = UIColor().defaultColor()
            self?.place2Underline.backgroundColor = .white
            self?.place3Underline.backgroundColor = .white
            self?.place4Underline.backgroundColor = .white
        }
    }
    
    private func getData() {
        Network.shared.GetContactInfo { [weak self] (data) in
            self?.data = data ?? [GeneralContactListData]()
            self?.setupView()
        }
    }
    
    @IBAction func place1ButtonTap(_ sender: Any) {
        placeTap(place: .hanoi)
    }
    
    @IBAction func place2ButtonTap(_ sender: Any) {
        placeTap(place: .haiphong)
    }
    
    @IBAction func place3ButtonTap(_ sender: Any) {
        placeTap(place: .miennam)
    }
    
    @IBAction func place4ButtonTap(_ sender: Any) {
        placeTap(place: .mientrung)
    }
    
    private func placeTap(place: ContactPlace) {
        let width = view.frame.width
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
                self?.place1Button.titleLabel?.textColor = .gray
                self?.place2Button.titleLabel?.textColor = .gray
                self?.place3Button.titleLabel?.textColor = .gray
                self?.place4Button.titleLabel?.textColor = .gray
                self?.place1Underline.backgroundColor = .white
                self?.place2Underline.backgroundColor = .white
                self?.place3Underline.backgroundColor = .white
                self?.place4Underline.backgroundColor = .white
                
                switch place {
                case .hanoi:
                    self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self?.place1Button.titleLabel?.textColor = UIColor().defaultColor()
                    self?.place1Underline.backgroundColor = UIColor().defaultColor()
                case .haiphong:
                    self?.scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
                    self?.place2Button.titleLabel?.textColor = UIColor().defaultColor()
                    self?.place2Underline.backgroundColor = UIColor().defaultColor()
                case .miennam:
                    self?.scrollView.setContentOffset(CGPoint(x: width * 2, y: 0), animated: true)
                    self?.place3Button.titleLabel?.textColor = UIColor().defaultColor()
                    self?.place3Underline.backgroundColor = UIColor().defaultColor()
                case .mientrung:
                    self?.scrollView.setContentOffset(CGPoint(x: width * 3, y: 0), animated: true)
                    self?.place4Button.titleLabel?.textColor = UIColor().defaultColor()
                    self?.place4Underline.backgroundColor = UIColor().defaultColor()
                }
            }, completion: nil)
        }
    }
    
    @objc func callButtonTap(sender: UIButton) {
        print(sender.tag)
        if let url = URL(string: "tel://090909090909"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
