//
//  BASmartCustomerCreateViewController.swift
//  BAPMobile
//
//  Created by Emcee on 2/24/21.
//

import UIKit
import CoreLocation

class BASmartCustomerCreateViewController: UIViewController {

    @IBOutlet weak var viewCustomerKind: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewName: BASmartCustomerListTextviewCellView!
    @IBOutlet weak var viewPhone: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewContact: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewPersonalId: BASmartCustomerListDefaultCellView!
    
    @IBOutlet weak var textViewAddress: UITextView!
    @IBOutlet weak var textFieldDescription: UITextView!
    
    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var location: BASmartLocationParam?
    var delegate: BlurViewDelegate?
    var descriptionPlaceholder = "Nhập thông tin ghi chú khách hàng..."
    var addressPlaceholder = "Nhập địa chỉ"
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "THÊM MỚI KHÁCH HÀNG"
    }
    
    private func setupView() {
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().defaultColor()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.backgroundColor = UIColor().defaultColor()
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4", alpha: 0.5).cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        let catalog = BASmartCustomerCatalogDetail.shared
        
        viewCustomerKind.setupView(title: "Nhóm KH",
                                   placeholder: "Chọn nhóm KH",
                                   content: catalog.customerKind,
                                   name: "",
                                   id: 0)
        
        viewPhone.setupView(title: "Điện thoại",
                            placeholder: "Nhập số điện thoại",
                            isNumberOnly: true,
                            content: "",
                            isAllowSelect: true,
                            isPhone: true,
                            isUsingLabel: false)
        
        viewPhone.textView.keyboardType = .numberPad
        viewPhone.textView.delegate = self

        viewName.setupView(name: "Tên KH",
                           placeHolder: "Nhập tên KH",
                           content: "")
        
        viewContact.setupView(title: "Liên hệ",
                              placeholder: "Nhập thông tin người liên hệ",
                              isNumberOnly: false,
                              content: "",
                              isAllowSelect: true,
                              isPhone: false,
                              isUsingLabel: false)
        
        viewPersonalId.setupView(title: "MST/CMT",
                                 placeholder: "Nhập MST/CMT",
                                 isNumberOnly: false,
                                 content: "",
                                 isAllowSelect: true,
                                 isPhone: false,
                                 isUsingLabel: false)
        
        
        textFieldDescription.text = descriptionPlaceholder
        textFieldDescription.textColor = UIColor.lightGray
        textFieldDescription.selectedTextRange = textFieldDescription.textRange(from: textFieldDescription.beginningOfDocument, to: textFieldDescription.beginningOfDocument)
        textFieldDescription.delegate = self
        
        textViewAddress.text = addressPlaceholder
        textViewAddress.textColor = UIColor.lightGray
        textViewAddress.selectedTextRange = textViewAddress.textRange(from: textViewAddress.beginningOfDocument, to: textViewAddress.beginningOfDocument)
        textViewAddress.delegate = self
        textViewAddress.isUserInteractionEnabled = false
        
        getLocationPermission()
        
        getCurrentPlace()
    }
    
    private func getCurrentPlace() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            let param = MapSelectParam(latstr: String(self?.location?.lat ?? 0),
                                       lngstr: String(self?.location?.lng ?? 0))
            Network.shared.SelectMap(param: param) { [weak self] (data) in
                self?.textViewAddress.text = data?.first?.address
                self?.textViewAddress.textColor = .black
            }
        }
    }
    
    private func getLocationPermission() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func buttonMapTap(_ sender: Any) {
        let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        delegate?.hideBlur()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        
        let customerDescription = (textFieldDescription.text == descriptionPlaceholder ? "" : textFieldDescription.text) ?? ""
        
        let param = BASmartAddCustomertParam(kind: viewCustomerKind.id,
                                             name: viewName.textView.text == viewName.textViewPlaceholder ? "" : viewName.textView.text,
                                             phone: viewPhone.textView.text ?? "",
                                             contact: viewContact.textView.text ?? "",
                                             tax: viewPersonalId.textView.text ?? "",
                                             address: textViewAddress.text,
                                             location: location ?? BASmartLocationParam(lng: 1, lat: 1, opt: 0),
                                             dpl: false,
                                             description: customerDescription)
        
        
        Network.shared.BASmartAddCustomer(param: param) { [weak self] (data) in
            if data?.state == true {
                self?.finishRequest()
            } else {
                self?.presentBasicAlert(title: data?.message ?? "",
                                        message: "",
                                        buttonTittle: "Đồng ý")
            }
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
        delegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
}


extension BASmartCustomerCreateViewController: MapSelectDelegate {
    func selectMap(data: [MapData]) {
        textViewAddress.text = data.first?.address
        textViewAddress.textColor = UIColor.black
        location = BASmartLocationParam(lng: data.first?.coords?.first?.lng ?? 0,
                                        lat: data.first?.coords?.first?.lat ?? 0,
                                        opt: 0 )
    }
}


extension BASmartCustomerCreateViewController: UITextViewDelegate, UITextFieldDelegate {
 
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            if textView == textViewAddress {
                textView.text = addressPlaceholder
            } else {
                textView.text = descriptionPlaceholder
            }
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText:String = textField.text!
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.count != 10 || updatedText.first != "0" {
            textField.textColor = .red
        } else {
            textField.textColor = .black
        }
        
        return true
    }
}

extension BASmartCustomerCreateViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let current = BASmartLocationParam(lng: locValue.longitude,
                                           lat: locValue.latitude,
                                           opt: 0)
        self.location = current
    }
}
