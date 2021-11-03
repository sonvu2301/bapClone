//
//  BASmartCustomerInformationAddHumanViewController.swift
//  BAPMobile
//
//  Created by Emcee on 2/2/21.
//

import UIKit

class BASmartCustomerInformationAddHumanViewController: UIViewController {

    @IBOutlet weak var viewName: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewTarget: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewPhone: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewPosition: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewDate: BASmartCustomerListCalendarView!
    @IBOutlet weak var viewEmail: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewFacebook: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewMarrige: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewGender: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewReligion: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewEthnic: BASmartCustomerListDropdownView!
    @IBOutlet weak var textViewDescription: UITextView!
    
    var customerId = 0
    var objectId = 0
    var delegate: BASmartAddNewDelegate?
    var blurDelegate: BlurViewDelegate?
    var data = BASmartHumanCellSource()
    var isEdit = false
    var textViewPlaceholder = "Nhập tính cách, sở thích người đại diện"
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().defaultColor()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        //setup data source for dropdown
        let catalog = BASmartCustomerCatalogDetail.shared
        viewTarget.setupView(title: "Đối tượng",
                             placeholder: "Chọn đối tượng",
                             content: catalog.humanKind,
                             name: "",
                             id: 0)
        viewPosition.setupView(title: "Chức vụ",
                               placeholder: "Chọn chức vụ",
                               content: catalog.position,
                               name: "",
                               id: 0)
        viewMarrige.setupView(title: "Hôn nhân",
                              placeholder: "Chọn tình trạng hôn nhân",
                              content: catalog.marital,
                              name: "",
                              id: 0)
        viewGender.setupView(title: "Giới tính",
                             placeholder: "Chọn giới tính",
                             content: catalog.gender,
                             name: "",
                             id: 0)
        viewReligion.setupView(title: "Tôn giáo",
                               placeholder: "Chọn tôn giáo",
                               content: catalog.religion,
                               name: "",
                               id: 0)
        viewEthnic.setupView(title: "Dân tộc",
                             placeholder: "Chọn dân tộc",
                             content: catalog.ethnic,
                             name: "",
                             id: 0)
        
        //setup name for normal cell
        viewName.setupView(title: "Họ tên",
                           placeholder: "Nhập họ tên",
                           isNumberOnly: false,
                           content: "",
                           isAllowSelect: true,
                           isPhone: false,
                           isUsingLabel: false)
        
        viewPhone.setupView(title: "Điện thoại",
                            placeholder: "Nhập số điện thoại",
                            isNumberOnly: true,
                            content: "",
                            isAllowSelect: true,
                            isPhone: true,
                            isUsingLabel: false)
        
        viewEmail.setupView(title: "Email",
                            placeholder: "Nhập email",
                            isNumberOnly: false,
                            content: "",
                            isAllowSelect: true,
                            isPhone: false,
                            isUsingLabel: false)
        
        viewFacebook.setupView(title: "Facebook",
                               placeholder: "Nhập facebook",
                               isNumberOnly: false,
                               content: "",
                               isAllowSelect: true,
                               isPhone: false,
                               isUsingLabel: false)
        
        viewDate.setupView(title: "Ngày sinh",
                           birth: data.birth ?? "",
                           placeHolder: "Nhập ngày sinh")
        
        if isEdit {
            title = "CẬP NHẬT THÔNG TIN NGƯỜI ĐẠI DIỆN"
            viewName.textView.text = data.name
            viewPhone.textView.text = data.phone
            viewEmail.textView.text = data.email
            viewFacebook.textView.text = data.facebook
            viewTarget.setupButton(title: data.kind ?? "")
            viewPosition.setupButton(title: data.position ?? "")
            viewMarrige.setupButton(title: data.marriage ?? "")
            viewGender.setupButton(title: data.gender ?? "")
            viewReligion.setupButton(title: data.religion ?? "")
            viewEthnic.setupButton(title: data.ethnic ?? "")
            viewDate.textField.text = data.birth
            textViewDescription.text = data.hobbit
            getPhoneNumber()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if textViewDescription.text == "" {
            textViewDescription.text = textViewPlaceholder
            textViewDescription.textColor = UIColor.lightGray
        }
        textViewDescription.selectedTextRange = textViewDescription.textRange(from: textViewDescription.beginningOfDocument, to: textViewDescription.beginningOfDocument)
        textViewDescription.delegate = self
        viewPhone.textView.delegate = self
    }
    
    
    private func getPhoneNumber() {
        Network.shared.BASmartGetPhoneNumber(kindId: GetPhoneKind.human.kindId, objectId: objectId) { [weak self] (data) in
            let phoneList = data?.map({ ($0.phone ?? "") }) ?? [String]()
            var phoneNumbers = ""
            phoneList.forEach { (item) in
                phoneNumbers += (item + ",")
            }
            self?.viewPhone.textView.text = String(phoneNumbers.dropLast())
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BASmartCustomerInformationAddHumanViewController: UITextViewDelegate, UITextFieldDelegate {
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
