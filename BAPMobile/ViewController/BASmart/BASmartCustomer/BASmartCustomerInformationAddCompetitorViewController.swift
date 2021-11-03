//
//  BASmartCustomerInformationAddCompetitorViewController.swift
//  BAPMobile
//
//  Created by Emcee on 2/3/21.
//

import UIKit

class BASmartCustomerInformationAddCompetitorViewController: UIViewController {

    @IBOutlet weak var viewName: DropDownSearchTextFieldView!
    @IBOutlet weak var viewLevel: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewDate: BASmartCustomerListCalendarView!
    @IBOutlet weak var viewNumber: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewPrice: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewDescription: UITextView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    var delegate: BASmartAddNewDelegate?
    var blurDelegate: BlurViewDelegate?
    var data: BASmartCompetitorCellSource?
    var customerId = 0
    var objectId: Int?
    var isEdit = false
    var textViewPlaceholder = "Nhập thông tin ghi chú đối thủ"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        title = "THÊM ĐỐI THỦ"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().defaultColor()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor().defaultColor().cgColor
        view.setCornerRadiusPopover()
        
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4", alpha: 0.5).cgColor
        
        
        //setup data source for dropdown
        let catalog = BASmartCustomerCatalogDetail.shared
        viewName.setupView(title: "Tên đối thủ",
                           content: catalog.provider.filter({$0.name != ""}),
                           id: 0,
                           placeholder: "Chọn tên đối thủ")
        viewLevel.setupView(title: "Mức độ rời",
                            placeholder: "Chọn mức độ rời mạng",
                            content: catalog.leaveLevel,
                            name: "",
                            id: 0)
        viewNumber.setupView(title: "Số lượng xe",
                             placeholder: "Nhập số lượng xe",
                             isNumberOnly: true,
                             content: "",
                             isAllowSelect: true,
                             isPhone: false,
                             isUsingLabel: false)
        viewPrice.setupView(title: "Giá dịch vụ",
                            placeholder: "Nhập giá dịch vụ của đối thủ",
                            isNumberOnly: false,
                            content: "",
                            isAllowSelect: true,
                            isPhone: false,
                            isUsingLabel: false)
        viewDate.setupView(title: "Hạn thu phí",
                           birth: "",
                           placeHolder: "Hạn thu phí")
        
        if isEdit {
            title = "CẬP NHẬT THÔNG TIN ĐỐI THỦ"
            viewName.textField.text = data?.provider ?? ""
            let id = catalog.provider.filter({$0.name == data?.provider}).map({$0.id}).first
            viewName.id = (id ?? 0) ?? 0
            viewLevel.setupButton(title: data?.level ?? "")
            viewNumber.textView.text = String(data?.vehicleCount ?? 0)
            viewPrice.textView.text = data?.price
            viewDate.textField.text = Date().millisecToDate(time: data?.expireDate ?? 0)
            viewDate.datePicker.date = Date(timeIntervalSince1970: TimeInterval(data?.expireDate ?? 0))
            viewDescription.text = data?.description
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if viewDescription.text == "" {
            viewDescription.text = textViewPlaceholder
            viewDescription.textColor = UIColor.lightGray
        }
        
        viewDescription.selectedTextRange = viewDescription.textRange(from: viewDescription.beginningOfDocument, to: viewDescription.beginningOfDocument)
        viewDescription.delegate = self
    }
    
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        let description = viewDescription.text == textViewPlaceholder ? "" : viewDescription.text
        
        if isEdit {
            let param = BASmartEditCompetitorParam(customerId: customerId,
                                                   objectId: objectId ?? 0,
                                                   provider: viewName.id,
                                                   vehicleCount: Int(viewNumber.textView.text ?? "0") ?? 0,
                                                   level: viewLevel.id,
                                                   date: Int(viewDate.datePicker.date.timeIntervalSince1970),
                                                   price: viewPrice.textView.text ?? "",
                                                   description: description ?? "")
            
            Network.shared.BASmartEditCompetitor(param: param) { [weak self] (data) in
                if data?.state == true {
                    self?.finishRequest()
                }
                else {
                    self?.presentBasicAlert(title: data?.message ?? "",
                                            message: "",
                                            buttonTittle: "Đồng ý")
                }
            }
        }
        
        else {
            let param = BASmartAddCompetitorParam(customerId: customerId,
                                                  provider: viewName.id,
                                                  vehicleCount: Int(viewNumber.textView.text ?? "0") ?? 0,
                                                  level: viewLevel.id,
                                                  date: Int(viewDate.datePicker.date.timeIntervalSince1970),
                                                  price: viewPrice.textView.text ?? "",
                                                  description: description ?? "")
            
            Network.shared.BASmartAddCompetitor(param: param) { [weak self] (data) in
                if data?.state == true {
                    self?.finishRequest()
                }
                else {
                    self?.presentBasicAlert(title: data?.message ?? "",
                                            message: "",
                                            buttonTittle: "Đồng ý")
                }
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
        self.delegate?.addNew()
        blurDelegate?.hideBlur()
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BASmartCustomerInformationAddCompetitorViewController: UITextViewDelegate {
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
