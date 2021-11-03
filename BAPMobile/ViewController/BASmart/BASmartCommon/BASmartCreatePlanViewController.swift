//
//  BASmartCreatePlanViewController.swift
//  BAPMobile
//
//  Created by Emcee on 3/29/21.
//

import UIKit
import CoreLocation

enum DateType {
    case date, time
}

enum PlanPurpose {
    case takeCare, welcome, transport, userManual, support, recoverDebt
    var id: Int {
        switch self {
        case .takeCare:
            return 1
        case .welcome:
            return 2
        case .transport:
            return 3
        case .userManual:
            return 4
        case .support:
            return 5
        case .recoverDebt:
            return 6
        }
    }
}

protocol BASmartSelectCustomerDelegate {
    func selectCustomer(customer: BASmartCustomerListData)
}

class BASmartCreatePlanViewController: UIViewController {

    @IBOutlet weak var buttonDate: UIButton!
    @IBOutlet weak var buttonRemoveDate: UIButton!
    @IBOutlet weak var buttonSelectCustomer: UIButton!
    @IBOutlet weak var buttonSelectMap: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var buttonPurpose1: UIButton!
    @IBOutlet weak var buttonPurpose2: UIButton!
    @IBOutlet weak var buttonPurpose3: UIButton!
    @IBOutlet weak var buttonPurpose4: UIButton!
    @IBOutlet weak var buttonPurpose5: UIButton!
    @IBOutlet weak var buttonPurpose6: UIButton!
    
    @IBOutlet weak var textfieldDate: UITextField!
    @IBOutlet weak var textfieldStart: UITextField!
    @IBOutlet weak var textfieldEnd: UITextField!
    
    @IBOutlet weak var labelCustomer: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var textfieldDescription: UITextView!
    
    //For Edit
    var data = BASmartPlanListData()
    var isEdit = false
    var day = ""
    
    //Common
    let datePicker = UIDatePicker()
    var purposeList = BASmartCustomerCatalogDetail.shared.purpose
    var purposeType = [PlanPurpose]()
    var purposeSelect = [Bool]()
    var selectedTextfield = UITextField()
    var location: [MapData]?
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: BASmartDoneCreateDelegate?
    var customer = BASmartCustomerListData()
    let locationManager = CLLocationManager()
    var current = MapLocation(lng: 0, lat: 0)
    var textViewPlaceholder = "Nhập thông tin kế hoạch"
    var name = ""
    var customerId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "THÔNG TIN KẾ HOẠCH"
    }
    
    
    private func setupView() {
        setupPurposeButton()
        textfieldStart.delegate = self
        textfieldEnd.delegate = self
        textfieldDate.delegate = self
        textfieldDate.text = Date().millisecToDate(time: Int(Date().timeIntervalSince1970))
        textfieldStart.text = Date().getHourMinute(time: Int(Date().timeIntervalSince1970) + 180 )
        
        
        //Add array of select purpose
        purposeList.forEach { [weak self] (item) in
            self?.purposeSelect.append(false)
        }
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().defaultColor()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4", alpha: 0.5).cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMap))
                            
        labelAddress.isUserInteractionEnabled = true
        labelAddress.addGestureRecognizer(tap)
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        
        
        if isEdit {
            title = "CHÍNH SỬA KẾ HOẠCH"
            name = data.name ?? ""
            textfieldDate.text = day
            textfieldStart.text = Date().millisecToHourMinute(time: data.start ?? 0)
            textfieldEnd.text = Date().millisecToHourMinute(time: data.end ?? 0)
            labelCustomer.text = data.name
            labelAddress.text = data.address
            labelAddress.textColor = .black
            labelCustomer.textColor = .black
            if data.description != "" {
                textfieldDescription.text = data.description
            } else {
                textfieldDescription.text = textViewPlaceholder
                textfieldDescription.textColor = UIColor.lightGray
            }
            
            let coord = MapLocation(lng: data.location?.lng ?? 0,
                                    lat: data.location?.lat ?? 0)
            let coords = [coord]
            let loc = MapData(address: data.address ?? "",
                              coords: coords,
                              kind: "",
                              name: "",
                              search: "",
                              shape_id: 0)
            location = [loc]
            customerId = data.planId ?? 0
            data.purpose?.forEach({ [weak self] (item) in
                switch item.id {
                case PlanPurpose.takeCare.id:
                    self?.selectPurpose(type: 0)
                case PlanPurpose.welcome.id:
                    self?.selectPurpose(type: 1)
                case PlanPurpose.transport.id:
                    self?.selectPurpose(type: 2)
                case PlanPurpose.userManual.id:
                    self?.selectPurpose(type: 3)
                case PlanPurpose.support.id:
                    self?.selectPurpose(type: 4)
                case PlanPurpose.recoverDebt.id:
                    self?.selectPurpose(type: 5)
                default:
                    break
                }
            })
        } else {
            textfieldDescription.text = textViewPlaceholder
            textfieldDescription.textColor = UIColor.lightGray
            if name != "" {
                labelCustomer.text = name
                labelCustomer.textColor = .black
                buttonSelectCustomer.isHidden = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.getCurrentPlace()
            }
        }
        
        textfieldDescription.selectedTextRange = textfieldDescription.textRange(from: textfieldDescription.beginningOfDocument, to: textfieldDescription.beginningOfDocument)
        textfieldDescription.delegate = self
    }
    
    
    private func setupPurposeButton() {
        let image = UIImage(named: "ic_uncheck")?.withRenderingMode(.alwaysTemplate).resizeImage(targetSize: CGSize(width: 20, height: 20))
        buttonPurpose1.setImage(image, for: .normal)
        buttonPurpose2.setImage(image, for: .normal)
        buttonPurpose3.setImage(image, for: .normal)
        buttonPurpose4.setImage(image, for: .normal)
        buttonPurpose5.setImage(image, for: .normal)
        buttonPurpose6.setImage(image, for: .normal)
        buttonPurpose1.tintColor = UIColor.black
        buttonPurpose2.tintColor = UIColor.black
        buttonPurpose3.tintColor = UIColor.black
        buttonPurpose4.tintColor = UIColor.black
        buttonPurpose5.tintColor = UIColor.black
        buttonPurpose6.tintColor = UIColor.black
    }
    
    
    private func planAction() {
        var sourceId = name == "" ? String(BASmartPlanKind.plan.id) : String(BASmartPlanKind.customer.id)
        sourceId = isEdit == true ? "" : sourceId
        let coord = location?.first?.coords?.first
        let locationParam = BASmartLocationParam(lng: coord?.lng ?? 0,
                                        lat: coord?.lat ?? 0,
                                        opt: 1)
        
        var purposeIds = [BASmartIdInfo]()
        purposeType.forEach { (item) in
            let purpose = BASmartIdInfo(id: item.id)
            purposeIds.append(purpose)
        }
        
        customerId = self.name == "" ? customer.object_id ?? 0 : customerId
        let description = textfieldDescription.text == textViewPlaceholder ? "" : textfieldDescription.text
        
        //Edit plan
        if isEdit {
            let param = BASmartUpdatePlanParam(objectId: customerId,
                                           day: textfieldDate.text?.stringToIntDate(),
                                           start: textfieldStart.text?.secondFromString(),
                                           end: textfieldEnd.text?.secondFromString(),
                                           address: location?.first?.address,
                                           location: locationParam,
                                           purpose: purposeIds,
                                           description: description)
            
            Network.shared.BASmartUpdatePlan(param: param) { [weak self] (data) in
                if data?.error_code == 0 {
                    self?.showSuccessAlert()
                    self?.finishDelegate?.finishCreate()
                } else {
                    self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
                }
            }
        }
        //Create plan
        else {
            let param = BASmartCreatePlanParam(sourceId: sourceId,
                                               objectId: customerId,
                                               day: textfieldDate.text?.stringToIntDate(),
                                               start: textfieldStart.text?.secondFromString(),
                                               end: textfieldEnd.text?.secondFromString(),
                                               address: location?.first?.address,
                                               location: locationParam,
                                               purpose: purposeIds,
                                               description: description)
            
            Network.shared.BASmartCreatePlan(param: param) { [weak self] (data) in
                if data?.error_code == 0 {
                    self?.showSuccessAlert()
                    self?.finishDelegate?.finishCreate()
                } else {
                    self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
                }
            }
        }
    }
    
    private func selectPurpose(type: Int) {
        
        let selectImage = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let unselectImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let image = purposeSelect[type] == true ? unselectImage : selectImage
        let color = purposeSelect[type] == true ? .black : UIColor().defaultColor()
        
        switch type {
        case 0:
            selectCheckbox(button: buttonPurpose1, image: image ?? UIImage(), color: color)
            selectPurpose(type: .takeCare, isAppend: !purposeSelect[type])
        case 1:
            selectCheckbox(button: buttonPurpose2, image: image ?? UIImage(), color: color)
            selectPurpose(type: .welcome, isAppend: !purposeSelect[type])
        case 2:
            selectCheckbox(button: buttonPurpose3, image: image ?? UIImage(), color: color)
            selectPurpose(type: .transport, isAppend: !purposeSelect[type])
        case 3:
            selectCheckbox(button: buttonPurpose4, image: image ?? UIImage(), color: color)
            selectPurpose(type: .userManual, isAppend: !purposeSelect[type])
        case 4:
            selectCheckbox(button: buttonPurpose5, image: image ?? UIImage(), color: color)
            selectPurpose(type: .support, isAppend: !purposeSelect[type])
        case 5:
            selectCheckbox(button: buttonPurpose6, image: image ?? UIImage(), color: color)
            selectPurpose(type: .recoverDebt, isAppend: !purposeSelect[type])
        default:
            break
        }
        
        purposeSelect[type] = !purposeSelect[type]
    }
    
    private func selectCheckbox(button: UIButton, image: UIImage, color: UIColor) {
        button.setImage(image, for: .normal)
        button.tintColor = color
    }
    
    private func selectPurpose(type: PlanPurpose, isAppend: Bool) {
        if isAppend == true {
            purposeType.append(type)
        } else {
            purposeType = purposeType.filter({$0 != type})
        }
    }
    
    private func getCurrentPlace() {
        let param = MapSelectParam(latstr: String(current.lat),
                                   lngstr: String(current.lng))
        
        Network.shared.SelectMap(param: param) { [weak self] (data) in
            self?.labelAddress.text = data?.first?.address
            self?.labelAddress.textColor = .black
            self?.location = data
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Thành công", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
            self?.blurDelegate?.hideBlur()
            self?.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    @objc func openMap() {
        let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        if selectedTextfield != textfieldDate {
            formatter.dateFormat = "HH:mm"
            selectedTextfield.text = formatter.string(from: datePicker.date)
        } else {
            formatter.dateFormat = "dd/MM/yyyy"
            selectedTextfield.text = formatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        view.endEditing(true)
    }
    
    private func touchTextfield(textField: UITextField, type: DateType) {
        var toolbar = UIToolbar()
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 35))
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        toolbar.updateFocusIfNeeded()
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.autocorrectionType = .no
        textField.allowsEditingTextAttributes = false
        selectedTextfield = textField
        
        switch type {
        case .date:
            datePicker.datePickerMode = .date
        case .time:
            datePicker.datePickerMode = .time
        }
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func buttonPickDateTap(_ sender: Any) {
        textfieldDate.becomeFirstResponder()
        touchTextfield(textField: textfieldDate, type: .date)
    }
    
    @IBAction func buttonCancelDateTap(_ sender: Any) {
        textfieldDate.text = ""
    }
    
    @IBAction func buttonSelectCustomerTap(_ sender: Any) {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartPlanSearchCustomerViewController") as! BASmartPlanSearchCustomerViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonOpenMapTap(_ sender: Any) {
        openMap()
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        planAction()
    }
    
    @IBAction func buttonPurpose1Tap(_ sender: Any) {
        selectPurpose(type: 0)
    }
    
    @IBAction func buttonPurpose2Tap(_ sender: Any) {
        selectPurpose(type: 1)
    }
    
    @IBAction func buttonPurpose3Tap(_ sender: Any) {
        selectPurpose(type: 2)
    }
    
    @IBAction func buttonPurpose4Tap(_ sender: Any) {
        selectPurpose(type: 3)
    }
    
    @IBAction func buttonPurpose5Tap(_ sender: Any) {
        selectPurpose(type: 4)
    }
    
    @IBAction func buttonPurpose6Tap(_ sender: Any) {
        selectPurpose(type: 5)
    }
    
}

extension BASmartCreatePlanViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != textfieldDate {
            touchTextfield(textField: textField, type: .time)
        } else {
            touchTextfield(textField: textField, type: .date)
        }
    }
}


extension BASmartCreatePlanViewController: MapSelectDelegate {
    func selectMap(data: [MapData]) {
        labelAddress.textColor = .black
        labelAddress.text = data.first?.address
        location = data
    }
}


extension BASmartCreatePlanViewController: BASmartSelectCustomerDelegate {
    func selectCustomer(customer: BASmartCustomerListData) {
        self.customer = customer
        labelCustomer.textColor = .black
        labelCustomer.text = self.customer.name
    }
}


extension BASmartCreatePlanViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = textViewPlaceholder
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
}

extension BASmartCreatePlanViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        current.lat = locValue.latitude
        current.lng = locValue.longitude
    }
}
