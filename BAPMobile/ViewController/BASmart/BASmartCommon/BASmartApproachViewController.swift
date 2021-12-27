//
//  BASmartApproachViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/2/21.
//

import UIKit

protocol GetSupporterNameDelegate {
    func getName(name: String)
}


class BASmartApproachViewController: BaseViewController {

    @IBOutlet weak var viewEndTime: UIView!
    @IBOutlet weak var viewName: BASmartCustomerListDefaultCellView!
    
    @IBOutlet weak var textFieldEndTime: UITextField!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelSupporter: UILabel!
    
    @IBOutlet weak var buttonAddress: UIButton!
    @IBOutlet weak var buttonSupporter: UIButton!
    
    @IBOutlet weak var buttonPurpose1: UIButton!
    @IBOutlet weak var buttonPurpose2: UIButton!
    @IBOutlet weak var buttonPurpose3: UIButton!
    @IBOutlet weak var buttonPurpose4: UIButton!
    @IBOutlet weak var buttonPurpose5: UIButton!
    @IBOutlet weak var buttonPurpose6: UIButton!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    var planData = BASmartPlanListData()
    var customerData = BASmartCustomerDetailGeneral()
    var purposeSelect = [Bool]()
    var purposeType = [PlanPurpose]()
    var purposeList = BASmartCustomerCatalogDetail.shared.purpose
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: BASmartDoneCreateDelegate?
    var isSupporterClear = true
    var isCheckingCustomer = false
    var isFromMain = false
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "VÀO ĐIỂM TIẾP XÚC"
    }
    
    private func setupView() {
        
        navigationItem.setHidesBackButton(true, animated: true)
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor.lightGray.cgColor
    
        
        if isCheckingCustomer {
            viewName.setupView(title: "Khách hàng",
                               placeholder: "",
                               isNumberOnly: false,
                               content: customerData.name,
                               isAllowSelect: false,
                               isPhone: false,
                               isUsingLabel: false)
            
            labelAddress.text = customerData.address
            
        } else {
            viewName.setupView(title: "Khách hàng",
                               placeholder: "",
                               isNumberOnly: false,
                               content: planData.name,
                               isAllowSelect: false,
                               isPhone: false,
                               isUsingLabel: false)
            
            labelAddress.text = planData.address
            textViewDescription.text = planData.description
            viewEndTime.isHidden = true
            textViewDescription.isUserInteractionEnabled = false
            buttonPurpose1.isUserInteractionEnabled = false
            buttonPurpose2.isUserInteractionEnabled = false
            buttonPurpose3.isUserInteractionEnabled = false
            buttonPurpose4.isUserInteractionEnabled = false
            buttonPurpose5.isUserInteractionEnabled = false
            buttonPurpose6.isUserInteractionEnabled = false
        }
        
        textFieldEndTime.delegate = self
        
        purposeList.forEach { [weak self] (item) in
            self?.purposeSelect.append(false)
        }

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
        
        planData.purpose?.forEach({ [weak self] (item) in
            switch item.id {
            case 1:
                self?.selectPurpose(type: 0)
            case 2:
                self?.selectPurpose(type: 1)
            case 3:
                self?.selectPurpose(type: 2)
            case 4:
                self?.selectPurpose(type: 3)
            case 5:
                self?.selectPurpose(type: 4)
            case 6:
                self?.selectPurpose(type: 5)
            default:
                break
            }
        })
        
        getCurrentLocationFirst()
    }
    
    private func planCheckinAction() {
        
        let param = BASmartDailyWorkingCheckinParam(plan: planData.planId,
                                                    address: labelAddress.text,
                                                    location: planData.location,
                                                    support: labelSupporter.text ?? "")
        
        
        Network.shared.BASmartDailyWorkingCheckin(param: param) { [weak self] (data) in
            if data?.errorCode != 0 && data?.errorCode != nil {
                self?.endCheckingError(message: data?.message ?? "")
            } else {
                self?.endChecking()
            }
        }
    }
    
    private func customerCheckingAction() {
        
        var purposes = [BASmartIdInfo]()
        purposeType.forEach { (item) in
            let purpose = BASmartIdInfo(id: item.id)
            purposes.append(purpose)
        }
        
        let data = customerData
        let param = BASmartCustomerCheckinParam(id: data.object_id,
                                                address: data.address,
                                                location: data.location,
                                                support: labelSupporter.text ?? "",
                                                purpose: purposes,
                                                end: textFieldEndTime.text?.secondFromString())
        
        Network.shared.BASmartCustomerDailyWorkingCheckin(param: param) { [weak self] (data) in
            if data?.errorCode != 0 && data?.errorCode != nil {
                self?.endCheckingError(message: data?.message ?? "")
            } else {
                self?.endChecking()
            }
        }
    }
    
    private func endCheckingError(message: String) {
        presentBasicAlert(title: message, message: "", buttonTittle: "Đồng ý")
    }
    
    private func endChecking() {
        let alert = UIAlertController(title: "Thành công", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel, handler: { [weak self] (action) in
            self?.blurDelegate?.hideBlur()
            self?.finishDelegate?.finishCreate()
            self?.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
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
    
    private func getCurrentLocationFirst() {
        let current = getCurrentLocation()
        let param = MapSelectParam(latstr: String(current.lat),
                                   lngstr: String(current.lng))
        
        Network.shared.SelectMap(param: param) { [weak self] (data) in
            self?.map = data?.first ?? MapData()
            self?.labelAddress.text = self?.map.address
        }
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
        
        datePicker.datePickerMode = .time
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        textFieldEndTime.text = formatter.string(from: datePicker.date)
        
        view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        view.endEditing(true)
    }
    
    
    @IBAction func buttonAddressTap(_ sender: Any) {
        let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func buttonSupporterTap(_ sender: Any) {
        
        if isSupporterClear {
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartSupporterListViewController") as! BASmartSupporterListViewController
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        } else {
            buttonSupporter.setImage(UIImage(named: "edit")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), for: .normal)
            labelSupporter.text = ""
            isSupporterClear = true
        }
        
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
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        if isCheckingCustomer {
            customerCheckingAction()
        } else {
            planCheckinAction()
        }
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        if isFromMain {
            navigationController?.popViewController(animated: true)
        } else {
            blurDelegate?.hideBlur()
            dismiss(animated: true, completion: nil)
        }
    }
    
}


extension BASmartApproachViewController: GetSupporterNameDelegate {
    func getName(name: String) {
        if name != "" {
            labelSupporter.text = name
            isSupporterClear = false
            buttonSupporter.setImage(UIImage(named: "ic_delete")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), for: .normal)
        }
    }
}

extension BASmartApproachViewController: MapSelectDelegate {
    func selectMap(data: [MapData]) {
        labelAddress.text = data.first?.address
        let location = BASmartLocationParam(lng: data.first?.coords?.first?.lng ?? 0,
                                            lat: data.first?.coords?.first?.lat ?? 0,
                                            opt: 1)
        self.planData.location = location
        self.customerData.location = location
    }
}

extension BASmartApproachViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldEndTime {
            touchTextfield(textField: textField, type: .time)
        }
    }
}
