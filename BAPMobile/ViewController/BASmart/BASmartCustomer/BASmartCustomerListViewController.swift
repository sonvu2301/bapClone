//
//  BASmartCustomerListViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/5/21.
//

import UIKit

enum ScrollState {
    case first, second, third
}

protocol BASmartGetPhoneNumberDelegate {
    func getPhoneNumber(objectId: Int, kindId: Int)
}

struct BASmartAddCustomertParam: Codable {
    var kind: Int
    var name: String
    var phone: String
    var contact: String
    var tax: String
    var address: String
    var location: BASmartLocationParam
    var dpl: Bool
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case kind = "kindid"
        case name = "name"
        case phone = "phone"
        case contact = "contact"
        case tax = "taxoridn"
        case address = "address"
        case location = "location"
        case dpl = "dplflag"
        case description = "description"
    }
}

class BASmartCustomerListViewController: BaseSideMenuViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonPotentialCustomer: UIButton!
    @IBOutlet weak var buttonPaidCustomer: UIButton!
    @IBOutlet weak var buttonSearchByPhone: UIButton!
    
    @IBOutlet weak var seperateLine1: UIView!
    @IBOutlet weak var seperateLine2: UIView!
    @IBOutlet weak var seperateLine3: UIView!
    
  
    var state = ScrollState.first
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "DANH SÁCH KHÁCH HÀNG"
    }
    
    private func setupView() {
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: 0)
        scrollView.delegate = self
        
        let origImage = UIImage(named: "search_book")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        buttonSearchByPhone.setImage(tintedImage, for: .normal)
        buttonSearchByPhone.tintColor = .black
        
        let vc1 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerListContentViewController") as! BASmartCustomerListContentViewController
        let vc2 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerListContentViewController") as! BASmartCustomerListContentViewController
        let vc3 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartSearchByPhoneViewController") as! BASmartSearchByPhoneViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc3.view.frame = CGRect(x: view.frame.width * 2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        vc1.kind = BASmartCustomerGroup.potential.id
        vc2.kind = BASmartCustomerGroup.old.id
        
        vc1.getCustomerList(groupId: vc1.kind)
        vc2.getCustomerList(groupId: vc2.kind)
        
        self.addChild(vc1)
        self.addChild(vc2)
        self.addChild(vc3)
        scrollView.addSubview(vc1.view)
        scrollView.addSubview(vc2.view)
        scrollView.addSubview(vc3.view)
        scrollView.isPagingEnabled = true
        
        scrollMenu(state: state)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ic_add")?.resizeImage(targetSize: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(addButtonAction))
    }
    
    private func scrollMenu(state: ScrollState) {
        self.state = state
        buttonPotentialCustomer.backgroundColor = UIColor(hexString: "C8C8C8")
        buttonPaidCustomer.backgroundColor = UIColor(hexString: "C8C8C8")
        buttonSearchByPhone.backgroundColor = UIColor(hexString: "C8C8C8")
        let image = UIImage(named: "search_book")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        buttonSearchByPhone.setImage(image, for: .normal)
        seperateLine1.isHidden = true
        seperateLine2.isHidden = true
        seperateLine3.isHidden = true
        
        switch state {
        case .first:
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
            buttonPotentialCustomer.backgroundColor = .white
            seperateLine1.isHidden = false
        case .second:
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.scrollView.setContentOffset(CGPoint(x: (self?.scrollView.bounds.size.width ?? 0), y: 0), animated: false)
            }
            buttonPaidCustomer.backgroundColor = .white
            seperateLine2.isHidden = false
        case .third:
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.scrollView.setContentOffset(CGPoint(x: (2 * (self?.scrollView.bounds.size.width ?? 0)), y: 0), animated: false)
            }
            buttonSearchByPhone.backgroundColor = .white
            let origImage = UIImage(named: "search_book")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            buttonSearchByPhone.setImage(tintedImage, for: .normal)
            buttonSearchByPhone.tintColor = UIColor().defaultColor()
            seperateLine3.isHidden = false
        }
    }
    
    private func showPhone(phones: [String]) {
        let storyBoard = UIStoryboard(name: "BASmart", bundle: nil)
        let popoverContent = storyBoard.instantiateViewController(withIdentifier: "BASmartShowPhoneNumberViewController") as! BASmartShowPhoneNumberViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 610)
        popoverContent.phones = phones
        popoverContent.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        popover?.delegate = self
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }

    @IBAction func buttonCustomerPotentialTap(_ sender: Any) {
        scrollMenu(state: .first)
    }
    
    @IBAction func buttonPaidCustomerTap(_ sender: Any) {
        scrollMenu(state: .second)
    }
    
    @IBAction func buttonSearchByPhoneTap(_ sender: Any) {
        scrollMenu(state: .third)
    }
    
    @objc func addButtonAction() {
        let storyBoard = UIStoryboard(name: "BASmart", bundle: nil)
        let popoverContent = storyBoard.instantiateViewController(withIdentifier: "BASmartCustomerCreateViewController") as! BASmartCustomerCreateViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 610)
        popoverContent.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        popover?.delegate = self
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
}

extension BASmartCustomerListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = view.frame.width
        let contentOffset = scrollView.contentOffset.x
        
        switch state {
        case .first:
            if contentOffset > (width / 2) {
                scrollMenu(state: .second)
            }
        case .second:
            if contentOffset > (2 * width - width / 2) {
                scrollMenu(state: .third)
            } else if contentOffset < (width / 2) {
                scrollMenu(state: .first)
            }
        case .third:
            if contentOffset < (2 * width - width / 2) {
                scrollMenu(state: .second)
            }
        }
    }
}

extension BASmartCustomerListViewController: BASmartGetPhoneNumberDelegate {
    func getPhoneNumber(objectId: Int, kindId: Int) {
        Network.shared.BASmartGetPhoneNumber(kindId: kindId, objectId: objectId) { [weak self] (data) in
            let phoneList = data?.map({ ($0.phone ?? "") }) ?? [String]()
            if phoneList.count > 0 {
                self?.showPhone(phones: phoneList)
            }
        }
    }
    
}
