//
//  BASmartCheckOutWorkingViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/16/21.
//

import UIKit

protocol GetReasonListDelegate {
    func selectList(type: SelectMultiCatalogType, data: [BASmartIdInfo], name: String)
    func showRate(isShow: Bool)
}

class BASmartCheckOutWorkingViewController: BaseViewController {

    @IBOutlet weak var viewEvaluate: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewResult: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewVehicleCount: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewOffer: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewStage: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewSale: BASmartCustomerListDropdownView!
    
    
    @IBOutlet weak var viewProject: UIView!
    @IBOutlet weak var viewInstallDay: UIView!
    @IBOutlet weak var viewReason: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewVehicle: BASmartCustomerListDropdownView!
    
    @IBOutlet weak var buttonPurpose1: UIButton!
    @IBOutlet weak var buttonPurpose2: UIButton!
    @IBOutlet weak var buttonPurpose3: UIButton!
    @IBOutlet weak var buttonPurpose4: UIButton!
    @IBOutlet weak var buttonPurpose5: UIButton!
    @IBOutlet weak var buttonPurpose6: UIButton!
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonInstallDay: UIButton!
    @IBOutlet weak var buttonDate: UIButton!
    @IBOutlet weak var buttonDeleteInstallDay: UIButton!
    @IBOutlet weak var buttonDeleteDate: UIButton!
    @IBOutlet weak var buttonReason: UIButton!
    
    @IBOutlet weak var textFieldInstallDay: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var labelReason: UILabel!
    @IBOutlet weak var labelProject: UILabel!
    
    let datePicker = UIDatePicker()
    var selectedTextfield = UITextField()
    var purposeSelect = [Bool]()
    var purposeType = [PlanPurpose]()
    var purposeList = BASmartCustomerCatalogDetail.shared.purpose
    var reasons = [BASmartIdInfo]()
    var projects = [BASmartIdInfo]()
    var blurDelegate: BlurViewDelegate?
    var finishDelegate: BASmartDoneCreateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCatalog()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "RA ĐIỂM TIẾP XÚC"
    }
    
    private func setupView() {
        
        let catalog = BASmartCustomerCatalogDetail.shared
        

        
        viewEvaluate.setupView(title: "Đánh giá",
                               placeholder: "Đánh giá kết quả tiếp xúc",
                               content: catalog.rate,
                               name: "",
                               id: 0)
        
        viewResult.setupView(title: "Kết quả",
                             placeholder: "Nhập kết quả tiếp xúc khách hàng",
                             isNumberOnly: false,
                             content: "",
                             isAllowSelect: true,
                             isPhone: false,
                             isUsingLabel: false)
        
        viewVehicleCount.setupView(title: "Số xe",
                                   placeholder: "Nhập số lượng xe dự kiến",
                                   isNumberOnly: true,
                                   content: "",
                                   isAllowSelect: true,
                                   isPhone: false,
                                   isUsingLabel: false)
        
        viewOffer.setupView(title: "Đề xuất",
                            placeholder: "Nhập đề xuất phương án với khách hàng",
                            isNumberOnly: false,
                            content: "",
                            isAllowSelect: true,
                            isPhone: false,
                            isUsingLabel: false)
        
        viewVehicle.setupView(title: "Ph.Tiện",
                              placeholder: "Chọn phương tiện",
                              content: catalog.transport,
                              name: "",
                              id: 0)
        
        viewStage.setupView(title: "Bộ phận",
                            placeholder: "Chọn bộ phận",
                            content: catalog.department,
                            name: "",
                            id: 0)
        
        viewSale.setupView(title: "Chốt sale",
                           placeholder: "Chọn chốt sale",
                           content: catalog.ability,
                           name: "",
                           id: 0)
        
        viewEvaluate.showReasonDelegate = self
        let tapReason = UITapGestureRecognizer(target: self, action: #selector(openReason))
        let tapProject = UITapGestureRecognizer(target: self, action: #selector(openProject))
        labelReason.isUserInteractionEnabled = true
        labelReason.addGestureRecognizer(tapReason)
        labelProject.isUserInteractionEnabled = true
        labelProject.addGestureRecognizer(tapProject)
        viewReason.isHidden = true
        
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor.lightGray.cgColor
        
        purposeList = BASmartCustomerCatalogDetail.shared.purpose
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
        
        buttonDeleteDate.isHidden = true
        buttonDeleteInstallDay.isHidden = true
        
        textFieldDate.delegate = self
        textFieldInstallDay.delegate = self
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
    
    
    private func checkout() {
        
        var purposes = [BASmartIdInfo]()
        purposeType.forEach { (item) in
            purposes.append(BASmartIdInfo(id: item.id))
        }
        
        let location = getCurrentLocation()
        let locationParam = BASmartLocationParam(lng: location.lng, lat: location.lat, opt: 1)
        
        var param = BASmartDailyWorkingCheckoutParam()
        
        if viewReason.isHidden {
        param = BASmartDailyWorkingCheckoutParam(rate: viewEvaluate.id,
                                                     result: viewResult.getText(),
                                                     purpose: purposes,
                                                     vehicleCount: Int(viewVehicleCount.getText()),
                                                     expectTime: textFieldInstallDay.text?.stringToIntDate(),
                                                     scheme: viewOffer.getText(),
                                                     nextTime: textFieldDate.text?.stringToIntDate(),
                                                     transport: viewVehicle.id,
                                                     location: locationParam,
                                                     project: projects,
                                                     department: viewStage.id,
                                                     ability: viewSale.id)
            
        } else {
            param = BASmartDailyWorkingCheckoutParam(rate: viewEvaluate.id,
                                                         result: viewResult.getText(),
                                                         purpose: purposes,
                                                         vehicleCount: Int(viewVehicleCount.getText()),
                                                         expectTime: textFieldInstallDay.text?.stringToIntDate(),
                                                         scheme: viewOffer.getText(),
                                                         nextTime: textFieldDate.text?.stringToIntDate(),
                                                         transport: viewVehicle.id,
                                                         location: locationParam,
                                                         reason: reasons,
                                                         project: projects,
                                                         department: viewStage.id,
                                                         ability: viewSale.id)
        }
        
        Network.shared.BASmartDailyWorkingCheckout(param: param) { [weak self] (data) in
            if data?.errorCode != 0 && data?.errorCode != nil {
                self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
            } else {
                let alert = UIAlertController(title: "Thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel, handler: { [weak self] (action) in
                    self?.blurDelegate?.hideBlur()
                    self?.finishDelegate?.finishCreate()
                    self?.dismiss(animated: true, completion: nil)
                }))
                
                self?.present(alert, animated: true, completion: nil)
            }
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
        selectedTextfield = textField
        
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func openMultiSelectCatalog(type: SelectMultiCatalogType, dataSelect: [BASmartIdInfo]) {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartReasonViewController") as! BASmartReasonViewController
        vc.delegate = self
        vc.dataSelect = dataSelect
        vc.type = type
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        selectedTextfield.text = formatter.string(from: datePicker.date)
        if selectedTextfield == textFieldDate {
            buttonDeleteDate.isHidden = false
        } else if selectedTextfield == textFieldInstallDay {
            buttonDeleteInstallDay.isHidden = false
        }
        view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        view.endEditing(true)
    }
    
    @objc func openReason() {
        openMultiSelectCatalog(type: .reason, dataSelect: reasons)
    }
    
    @objc func openProject() {
        openMultiSelectCatalog(type: .project, dataSelect: projects)
    }
    
    @IBAction func buttonInstallDayTap(_ sender: Any) {
        textFieldInstallDay.becomeFirstResponder()
        touchTextfield(textField: textFieldInstallDay, type: .date)
    }
    
    @IBAction func buttonDateTap(_ sender: Any) {
        textFieldDate.becomeFirstResponder()
        touchTextfield(textField: textFieldDate, type: .date)
    }
    
    @IBAction func buttonDeleteDateTap(_ sender: Any) {
        textFieldDate.text = ""
        buttonDeleteDate.isHidden = true
    }
    
    @IBAction func buttonDeleteInstallDayTap(_ sender: Any) {
        textFieldInstallDay.text = ""
        buttonDeleteInstallDay.isHidden = true
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
        checkout()
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonReasonTap(_ sender: Any) {
        openReason()
    }
    
    @IBAction func buttonSelectProjectTap(_ sender: Any) {
        openProject()
    }
}


extension BASmartCheckOutWorkingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        touchTextfield(textField: textField, type: .date)
    }
}

extension BASmartCheckOutWorkingViewController: RateDelegate {
    func showReason(isShow: Bool) {
        viewReason.isHidden = isShow
    }
}

extension BASmartCheckOutWorkingViewController: GetReasonListDelegate {
    func showRate(isShow: Bool) {
        
    }
    
    func selectList(type: SelectMultiCatalogType, data: [BASmartIdInfo], name: String) {
        switch type {
        case .reason:
            labelReason.text = name
            reasons = data
        case .project:
            labelProject.text = name
            projects = data
        case .purpose:
            break
        }
    }
}
