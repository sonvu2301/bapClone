//
//  BASmartCustomerInformationAddHumanBaseViewController.swift
//  BAPMobile
//
//  Created by Emcee on 10/26/21.
//

import UIKit

class BASmartCustomerInformationAddHumanBaseViewController: BaseViewController {
   
    
    @IBOutlet weak var viewSeperateButton: UIView!
    
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    @IBOutlet weak var imageSecondConfirm: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var state = ScrollState.first
    var customerId = 0
    var objectId = 0
    var delegate: BASmartAddNewDelegate?
    var blurDelegate: BlurViewDelegate?
    var data = BASmartHumanCellSource()
    var profList = [BASmartCustomerCatalogItemsDetail]()
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "THÊM NGƯỜI ĐẠI DIỆN"
    }
    
    private func setupView() {
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4", alpha: 0.5).cgColor
        
        buttonFirst.layer.borderWidth = 1
        buttonFirst.layer.borderColor = UIColor().defaultColor().cgColor
        buttonFirst.setViewCircle()
        buttonSecond.layer.borderWidth = 1
        buttonSecond.layer.borderColor = UIColor(hexString: "C8C8C8").cgColor
        buttonSecond.setViewCircle()
        
        scrollView.contentSize = CGSize(width: view.frame.width * 2 - 80, height: 0)
        scrollView.delegate = self
        
        let vc1 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerInformationAddHumanViewController") as! BASmartCustomerInformationAddHumanViewController
        let vc2 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerInformationAddHumanTypeViewController") as! BASmartCustomerInformationAddHumanTypeViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width - 40, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        vc1.objectId = objectId
        vc1.customerId = customerId
        vc1.data = data
        vc1.isEdit = isEdit
        vc1.setupView()
        
        vc2.data = profList
        vc2.setupView()
        
        self.addChild(vc1)
        self.addChild(vc2)
        scrollView.addSubview(vc1.view)
        scrollView.addSubview(vc2.view)
        scrollView.isPagingEnabled = true
        
        scrollMenu(state: state)
    }
    
    private func scrollMenu(state: ScrollState) {
        self.state = state
        switch state {
        case .first:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            buttonFirst.backgroundColor = UIColor().defaultColor()
            buttonFirst.setTitleColor(.white, for: .normal)
            buttonSecond.backgroundColor = UIColor(hexString: "C8C8C8")
            buttonSecond.setTitleColor(UIColor(hexString: "969696"), for: .normal)
            buttonSecond.layer.borderColor = UIColor(hexString: "C8C8C8").cgColor
            viewSeperateButton.backgroundColor = UIColor(hexString: "C8C8C8")
        case .second:
            scrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
            buttonFirst.backgroundColor = .clear
            buttonFirst.setTitleColor(UIColor().defaultColor(), for: .normal)
            buttonSecond.backgroundColor = UIColor().defaultColor()
            buttonSecond.setTitleColor(.white, for: .normal)
            buttonSecond.layer.borderColor = UIColor().defaultColor().cgColor
            viewSeperateButton.backgroundColor = UIColor().defaultColor()
        case .third:
            break
        }
    }
    
    private func finishRequest() {
        let alert = UIAlertController(title: "Thành công", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
            self?.sendRequest()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func sendRequest() {
        self.delegate?.addNew()
        blurDelegate?.hideBlur()
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonFirstTap(_ sender: Any) {
        scrollMenu(state: .first)
    }
    
    @IBAction func buttonSecondTap(_ sender: Any) {
        scrollMenu(state: .second)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        
        let vc1 = self.children[0] as! BASmartCustomerInformationAddHumanViewController
        let vc2 = self.children[1] as! BASmartCustomerInformationAddHumanTypeViewController
        
        let description = vc1.textViewDescription.text == vc1.textViewPlaceholder ? "" : vc1.textViewDescription.text
        var prof = [BASmartVtype]()
        vc2.data.forEach { (item) in
            prof.append(BASmartVtype(id: item.id))
        }
        
        if isEdit {
            let param = BASmartEditHumanParam(customerId: customerId,
                                              objectId: objectId,
                                              kind: vc1.viewTarget.id,
                                              name: vc1.viewName.textView.text ?? "",
                                              phone: vc1.viewPhone.textView.text ?? "",
                                              birthDay: vc1.viewDate.textField.text ?? "",
                                              gender: vc1.viewGender.id,
                                              marital: vc1.viewMarrige.id,
                                              ethnic: vc1.viewEthnic.id,
                                              religion: vc1.viewReligion.id,
                                              position: vc1.viewPosition.id,
                                              email: vc1.viewEmail.textView.text ?? "",
                                              facebook: vc1.viewFacebook.textView.text ?? "",
                                              hobbit: description ?? "",
                                              profList: prof)
            
            Network.shared.BASmartEditHuman(param: param) { [weak self] (data) in
                if data?.state == true {
                    self?.finishRequest()
                } else {
                    self?.presentBasicAlert(title: data?.message ?? "",
                                            message: "",
                                            buttonTittle: "Đồng ý")
                }
            }
            
        }
        
        else {
            let param = BASmartAddHumanParam(customerId: customerId,
                                             kind: vc1.viewTarget.id,
                                             name: vc1.viewName.textView.text ?? "",
                                             phone: vc1.viewPhone.textView.text ?? "",
                                             birthDay: vc1.viewDate.textField.text ?? "",
                                             gender: vc1.viewGender.id,
                                             marital: vc1.viewMarrige.id,
                                             ethnic: vc1.viewEthnic.id,
                                             religion: vc1.viewReligion.id,
                                             position: vc1.viewPosition.id,
                                             email: vc1.viewEmail.textView.text ?? "",
                                             facebook: vc1.viewFacebook.textView.text ?? "",
                                             hobbit: description ?? "",
                                             profList: prof)
            
            Network.shared.BASmartAddHuman(param: param) { [weak self] (data) in
                if data?.state == true {
                    self?.finishRequest()
                } else {
                    self?.presentBasicAlert(title: data?.message ?? "",
                                            message: "",
                                            buttonTittle: "Đồng ý")
                }
            }
        }
    }
    
}

extension BASmartCustomerInformationAddHumanBaseViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}
