//
//  BASmartCustomerListEditDetailViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/21/21.
//

import UIKit

protocol BASmartSelectCustomerModelDelegate {
    func selectedModels(models: [BASmartCustomerModel])
}

enum ButtonState {
    case first, second
}

class BASmartCustomerListEditDetailViewController: BaseViewController {

    @IBOutlet weak var viewCustomerCode: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerName: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerPhone: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerContact: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerIDNumber: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerSource: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerEmail: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerFacebook: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerWebsite: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewCustomerCount: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewCustomerKind: BASmartCustomerListDropdownView!
    
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var textViewDate: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonDate: UIButton!
    @IBOutlet weak var buttonMap: UIButton!
    
    @IBOutlet weak var buttonType1: UIButton!
    @IBOutlet weak var buttonType2: UIButton!
    
    var typeState = ButtonState.first
    var type = 0
    
    var mapData = MapData()
    var data = BASmartCustomerDetailGeneral()
    var blurDelegate: BlurViewDelegate?
    var updateDelegate: BASmartDoneUpdateDelegate?
    var customerModel = [BASmartCustomerModel]()
    let datePicker = UIDatePicker()
    
    let selectedImage = UIImage(named: "dot_blue")?.resizeImage(targetSize: CGSize(width: 20, height: 20)) ?? UIImage()
    let unselectedImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20)) ?? UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "CH???NH S???A TH??NG TIN CHUNG"
    }
    
    
    func setupView() {
        
        viewCustomerCode.setupView(title: "M?? KH",
                                   placeholder: "Nh???p m?? kh??ch h??ng",
                                   isNumberOnly: false,
                                   content: data.kh_code ?? "",
                                   isAllowSelect: true,
                                   isPhone: false,
                                   isUsingLabel: false)
        
        viewCustomerName.setupView(title: "T??n KH",
                                   placeholder: "Nh???p t??n kh??ch h??ng",
                                   isNumberOnly: false,
                                   content: data.name ?? "",
                                   isAllowSelect: true,
                                   isPhone: false,
                                   isUsingLabel: false)
        
        viewCustomerPhone.setupView(title: "S??T",
                                    placeholder: "Nh???p s??? ??i???n tho???i",
                                    isNumberOnly: true,
                                    content: data.phone ?? "",
                                    isAllowSelect: true,
                                    isPhone: true,
                                    isUsingLabel: false)
        
        viewCustomerContact.setupView(title: "Li??n h???",
                                      placeholder: "Nh???p li??n h???",
                                      isNumberOnly: false,
                                      content: data.contact ?? "",
                                      isAllowSelect: true,
                                      isPhone: false,
                                      isUsingLabel: false)
        
        viewCustomerIDNumber.setupView(title: "MST/CMT",
                                       placeholder: "Nh???p MST/CMT",
                                       isNumberOnly: false,
                                       content: data.taxoridn ?? "",
                                       isAllowSelect: true,
                                       isPhone: false,
                                       isUsingLabel: false)
        
        viewCustomerSource.setupView(title: "Ngu???n KH",
                                     placeholder: "Nh???p ngu???n kh??ch h??ng",
                                     isNumberOnly: false,
                                     content: data.source_info?.name ?? "",
                                     isAllowSelect: true,
                                     isPhone: false,
                                     isUsingLabel: false)
        
        viewCustomerEmail.setupView(title: "Email",
                                    placeholder: "Nh???p email kh??ch h??ng",
                                    isNumberOnly: false,
                                    content: data.email ?? "",
                                    isAllowSelect: true,
                                    isPhone: false,
                                    isUsingLabel: false)
        
        viewCustomerFacebook.setupView(title: "Facebook",
                                       placeholder: "Nh???p facebook kh??ch h??ng",
                                       isNumberOnly: false,
                                       content: data.facebook ?? "",
                                       isAllowSelect: true,
                                       isPhone: false,
                                       isUsingLabel: false)
        
        viewCustomerWebsite.setupView(title: "Website",
                                      placeholder: "Nh???p website kh??ch h??ng",
                                      isNumberOnly: false,
                                      content: data.website ?? "",
                                      isAllowSelect: true,
                                      isPhone: false,
                                      isUsingLabel: false)
        
        let catalog = BASmartCustomerCatalogDetail.shared
        
        viewCustomerCount.setupView(title: "Quy m??",
                                    placeholder: data.scale_info?.name ?? "",
                                    content: catalog.scale,
                                    name: data.scale_info?.name ?? "",
                                    id: data.scale_info?.id ?? 0)
        viewCustomerKind.setupView(title: "Nh??m KH",
                                   placeholder: data.kind_info?.name ?? "",
                                   content: catalog.customerKind,
                                   name: data.kind_info?.name ?? "",
                                   id: data.kind_info?.id ?? 0)

        
        data.model_list?.forEach({ [weak self] (item) in
            let model = BASmartCustomerModel(id: item.id, ri: item.ri)
            self?.customerModel.append(model)
        })
        
        var models = ""
        data.model_list?.forEach({ (item) in
            models += "\(item.name ?? "")(\(item.ri ?? 0)), "
        })
        
        if models.count > 0 {
            models = String(models.dropLast())
            models = String(models.dropLast())
        }
        
        labelType.text = models
        
        viewCustomerCode.textView.isUserInteractionEnabled = false
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor().defaultColor().cgColor
        view.setCornerRadiusPopover()
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "DCDCDC").cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        if data.address != "" {
            labelAddress.text = data.address
            labelAddress.textColor = .black
        }
        
        switch data.type_info?.id {
        case BASmartCustomerType.competitor.id:
            typeButtonState(state: .first)
            type = BASmartCustomerType.competitor.id
        case BASmartCustomerType.not_yet.id:
            typeButtonState(state: .second)
            type = BASmartCustomerType.not_yet.id
        default:
            break
        }
        
        textViewDescription.text = data.description
        textViewDate.text = data.foundation
        
    }
    
    private func typeButtonState(state: ButtonState) {
        buttonType1.setImage(unselectedImage, for: .normal)
        buttonType2.setImage(unselectedImage, for: .normal)
        
        switch state {
        case .first:
            buttonType1.setImage(selectedImage, for: .normal)
            type = BASmartCustomerType.competitor.id
        case .second:
            buttonType2.setImage(selectedImage, for: .normal)
            type = BASmartCustomerType.not_yet.id
        }
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textViewDate.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        view.endEditing(true)
    }
    
    private func touchTextfield() {
        var toolbar = UIToolbar()
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 35))
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        toolbar.updateFocusIfNeeded()
        textViewDate.inputAccessoryView = toolbar
        textViewDate.inputView = datePicker
        textViewDate.autocorrectionType = .no
        textViewDate.allowsEditingTextAttributes = false
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func buttonTypeFirstTap(_ sender: Any) {
        typeButtonState(state: .first)
    }
    
    @IBAction func buttonTypeSecondTap(_ sender: Any) {
        typeButtonState(state: .second)
    }
    
    @IBAction func buttonDateTap(_ sender: Any) {
        touchTextfield()
    }
    
    @IBAction func buttonSelectTypeTap(_ sender: Any) {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartSelectCustomerModelViewController") as! BASmartSelectCustomerModelViewController
        vc.delegate = self
        vc.data = customerModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonMapTap(_ sender: Any) {
        let vc = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        
        var location: BASmartLocationParam?
        
        if mapData.address != nil {
            location = BASmartLocationParam(lng: mapData.coords?.first?.lng ?? 0,
                                                lat: mapData.coords?.first?.lat ?? 0,
                                                opt: 0)
        } else {
            location = BASmartLocationParam(lng: data.location?.lng ?? 0,
                                                lat: data.location?.lat ?? 0,
                                                opt: 0)
        }
             
        let param = BASmartCustomerUpdateParam(address: labelAddress.text,
                                               contact: viewCustomerContact.getText(),
                                               description: textViewDescription.text,
                                               email: viewCustomerEmail.getText(),
                                               facebook: viewCustomerFacebook.getText(),
                                               foundation: textViewDate.text,
                                               kind_info: viewCustomerKind.id,
                                               location: location,
                                               modelList: customerModel,
                                               name: viewCustomerName.getText(),
                                               object_id: data.object_id,
                                               phone: viewCustomerPhone.getText(),
//                                               scale_info: viewCustomerCount.id,
                                               taxoridn: viewCustomerIDNumber.getText(),
                                               type_info: type,
                                               website: viewCustomerWebsite.getText())
        
        
        Network.shared.BASmartUpdateCustomer(param: param) { [weak self] (data) in
            if data?.errorCode != 0 {
                self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "?????ng ??")
            } else {
                let alert = UIAlertController(title: "Th??nh c??ng", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "?????ng ??", style: .cancel, handler: { [weak self] (action) in
                    self?.blurDelegate?.hideBlur()
                    self?.updateDelegate?.finishUpdate()
                    self?.dismiss(animated: true, completion: nil)
                }))
                
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension BASmartCustomerListEditDetailViewController: MapSelectDelegate {
    func selectMap(data: [MapData]) {
        labelAddress.text = data.first?.address
        labelAddress.textColor = .black
        mapData = data.first ?? MapData()
    }
}

extension BASmartCustomerListEditDetailViewController: BASmartSelectCustomerModelDelegate {
    func selectedModels(models: [BASmartCustomerModel]) {
        customerModel = models
        
        let catalog = BASmartCustomerCatalogDetail.shared.model
        var modelLabelName = ""
        models.forEach { (item) in
            let name = catalog.filter({$0.id == item.id}).compactMap({$0.name}).first
            modelLabelName += "\(name ?? "")(\(item.ri ?? 0)),"
        }
        if modelLabelName.count > 0 {
            modelLabelName = String(modelLabelName.dropLast())
        }
        
        labelType.text = modelLabelName
    }
}
