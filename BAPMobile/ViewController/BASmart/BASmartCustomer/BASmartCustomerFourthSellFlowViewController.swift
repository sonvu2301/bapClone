//
//  BASmartCustomerFourthSellFlowViewController.swift
//  BAPMobile
//
//  Created by Emcee on 4/13/21.
//

import UIKit
import DKImagePickerController

enum ReceiverType {
    case cash, transfer
    
    var id: Int {
        switch self {
        case .cash:
            return 1
        case .transfer:
            return 2
        }
    }
}


class BASmartCustomerFourthSellFlowViewController: BaseViewController {

    @IBOutlet weak var viewSelectImage: SelectImageView!
    
    @IBOutlet weak var viewCustomerID: UIView!
    @IBOutlet weak var seperateLine1: UIView!
    @IBOutlet weak var seperateLine2: UIView!
    @IBOutlet weak var seperateLine3: UIView!
    @IBOutlet weak var seperateLine4: UIView!
    @IBOutlet weak var seperateLine5: UIView!
    @IBOutlet weak var seperateLine6: UIView!
    @IBOutlet weak var seperateLine7: UIView!
    @IBOutlet weak var seperateLine8: UIView!
    @IBOutlet weak var seperateLine9: UIView!
    @IBOutlet weak var seperateLine10: UIView!
    @IBOutlet weak var seperateLine11: UIView!
    @IBOutlet weak var seperateLine12: UIView!
    @IBOutlet weak var seperateLine13: UIView!
    
    @IBOutlet weak var buttonCash: UIButton!
    @IBOutlet weak var buttonTransfer: UIButton!
    @IBOutlet weak var buttonFirstReceive: UIButton!
    @IBOutlet weak var buttonSecondReceive: UIButton!
    @IBOutlet weak var buttonFirstAct: UIButton!
    @IBOutlet weak var buttonSecondAct: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonMap: UIButton!
    
    @IBOutlet weak var textFieldActor: UITextField!
    @IBOutlet weak var textFieldActorNumber: UITextField!
    @IBOutlet weak var textFieldReporter: UITextField!
    @IBOutlet weak var textFieldReporterNumber: UITextField!
    @IBOutlet weak var textFieldActTime: UITextField!
    @IBOutlet weak var textFieldActDate: UITextField!
    @IBOutlet weak var textFieldDescription: UITextView!
    @IBOutlet weak var textFieldUserId: UITextField!
    @IBOutlet weak var textFieldExpiredDate: UITextField!
    
    @IBOutlet weak var labelLocation: UILabel!
    
    var selectedTextfield = UITextField()
    let datePicker = UIDatePicker()
    var selectedImage = UIImage()
    var unselectedImage = UIImage()
    var location: [MapData]?
    var delegate: CreateOrderDelegate?
    var paymentId = ReceiverType.cash
    var receiverId = 1
    var deployId = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        
        //draw dot seperate view
        let seperateLines: [UIView] = [seperateLine1,
                                       seperateLine2,
                                       seperateLine3,
                                       seperateLine4,
                                       seperateLine5,
                                       seperateLine6,
                                       seperateLine7,
                                       seperateLine8,
                                       seperateLine9,
                                       seperateLine10,
                                       seperateLine11,
                                       seperateLine12,
                                       seperateLine13]
        
        seperateLines.forEach { (item) in
            item.drawDottedLine(view: item)
        }
        
        
        selectedImage = UIImage(named: "dot_blue")?.resizeImage(targetSize: CGSize(width: 20, height: 20)) ?? UIImage()
        unselectedImage = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20)) ?? UIImage()
        
        buttonCash.setImage(selectedImage, for: .normal)
        buttonTransfer.setImage(unselectedImage, for: .normal)
        buttonFirstReceive.setImage(unselectedImage, for: .normal)
        buttonSecondReceive.setImage(selectedImage, for: .normal)
        buttonFirstAct.setImage(selectedImage, for: .normal)
        buttonSecondAct.setImage(unselectedImage, for: .normal)
        buttonConfirm.setViewCorner(radius: 10)
        
        textFieldActTime.delegate = self
        textFieldActDate.delegate = self
        textFieldExpiredDate.delegate = self
        
        textFieldExpiredDate.text = Date().millisecToDate(time: Int(Date().timeIntervalSince1970))  
        textFieldActTime.text = Date().getHourMinute(time: Int(Date().timeIntervalSince1970))
        
        viewCustomerID.isHidden = true
        
        viewSelectImage.delegate = self
        
        labelLocation.text = map.name
        getAddressName()
        showKeyboard()
    }
    
    private func payButtonTap(isCash: Bool) {
        if isCash {
            buttonCash.setImage(selectedImage, for: .normal)
            buttonTransfer.setImage(unselectedImage, for: .normal)
            buttonFirstReceive.setImage(unselectedImage, for: .normal)
            buttonFirstReceive.setTitle("  Kinh doanh", for: .normal)
            buttonSecondReceive.isHidden = false
            buttonSecondReceive.setImage(selectedImage, for: .normal)
            paymentId = .cash
            receiverId = 0
        } else {
            buttonCash.setImage(unselectedImage, for: .normal)
            buttonTransfer.setImage(selectedImage, for: .normal)
            buttonSecondReceive.isHidden = true
            buttonSecondReceive.setImage(unselectedImage, for: .normal)
            buttonFirstReceive.setImage(selectedImage, for: .normal)
            buttonFirstReceive.setTitle("  Chuyển khoản", for: .normal)
            paymentId = .transfer
            receiverId = 2
        }
    }
    
    private func actingButtonTap(isBA: Bool) {
        if isBA {
            buttonFirstAct.setImage(selectedImage, for: .normal)
            buttonSecondAct.setImage(unselectedImage, for: .normal)
            deployId = 1
        } else {
            buttonFirstAct.setImage(unselectedImage, for: .normal)
            buttonSecondAct.setImage(selectedImage, for: .normal)
            deployId = 2
        }
    }
    
    private func receiverButtonTap(isFirstReceiver: Bool) {
        if isFirstReceiver {
            buttonFirstReceive.setImage(selectedImage, for: .normal)
            buttonSecondReceive.setImage(unselectedImage, for: .normal)
            receiverId = 1
        } else {
            buttonFirstReceive.setImage(unselectedImage, for: .normal)
            buttonSecondReceive.setImage(selectedImage, for: .normal)
            receiverId = 2
        }
    }
    
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        if selectedTextfield == textFieldActTime {
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
    
    private func getAddressName() {
        let current = getCurrentLocation()
        let param = MapSelectParam(latstr: String(current.lat),
                                   lngstr: String(current.lng))
        
        Network.shared.SelectMap(param: param) { [weak self] (data) in
            self?.map = data?.first ?? MapData()
            self?.labelLocation.text = data?.first?.address
        }
    }
    
    @IBAction func buttonDeleteDateTap(_ sender: Any) {
        textFieldActDate.text = ""
    }
    
    @IBAction func buttonSelectDateTap(_ sender: Any) {
        textFieldActDate.becomeFirstResponder()
    }
    
    @IBAction func buttonCashTap(_ sender: Any) {
        payButtonTap(isCash: true)
    }
    
    @IBAction func buttonTransferTap(_ sender: Any) {
        payButtonTap(isCash: false)
    }
    
    @IBAction func buttonFirstActTap(_ sender: Any) {
        receiverButtonTap(isFirstReceiver: true)
    }
    
    @IBAction func buttonSecondActTap(_ sender: Any) {
        receiverButtonTap(isFirstReceiver: false)
    }
    
    @IBAction func buttonFirstActorTap(_ sender: Any) {
        actingButtonTap(isBA: true)
    }
    
    @IBAction func buttonSecondActorTap(_ sender: Any) {
        actingButtonTap(isBA: false)
    }
    @IBAction func buttonExpireDateTap(_ sender: Any) {
        textFieldExpiredDate.becomeFirstResponder()
    }
    
    @IBAction func buttonDeleteExpireDate(_ sender: Any) {
        textFieldExpiredDate.text = ""
    }
    
    @IBAction func buttonMapTap(_ sender: Any) {
        let sb = UIStoryboard(name: "Map", bundle: nil)
        let popoverContent = (sb.instantiateViewController(withIdentifier: "MapViewController") ) as! MapViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.blurDelegate = self
        popoverContent.delegate = self
        popoverContent.isPopover = true
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 1000)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: view.frame.width, y: (navigationController?.navigationBar.frame.height ?? 44) + 90, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        delegate?.createOrder()
    }
    
}


extension BASmartCustomerFourthSellFlowViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldActTime {
            touchTextfield(textField: textField, type: .time)
        } else {
            touchTextfield(textField: textField, type: .date)
        }
    }
}

extension BASmartCustomerFourthSellFlowViewController: MapSelectDelegate {
    func selectMap(data: [MapData]) {
        labelLocation.text = data.first?.address
        location = data
    }
}

extension BASmartCustomerFourthSellFlowViewController: UpdateImageDelegate {
    func deleteImage(index: Int) {
        
    }
    
    func addImage() {
        let pickerController = DKImagePickerController()
        pickerController.modalPresentationStyle = .fullScreen
        pickerController.view.tintColor = UIColor().defaultColor()
        pickerController.didSelectAssets = { [weak self] (assets: [DKAsset]) in
            assets.forEach { (item) in
                item.fetchOriginalImage { (image, nil) in
                    self?.viewSelectImage.images.append(image ?? UIImage())
                    self?.viewSelectImage.collectionView.reloadData()
                    self?.viewSelectImage.resetView()
                }
            }
        }
        self.present(pickerController, animated: true)
    }
}
