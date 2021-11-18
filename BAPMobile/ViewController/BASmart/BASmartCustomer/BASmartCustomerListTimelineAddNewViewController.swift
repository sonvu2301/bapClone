//
//  BASmartCustomerListTimelineAddNewViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/28/21.
//

import UIKit

struct BASmartCustomerDiary: Codable {
    var objectId: Int
    var sideId: Int
    var title: String
    var contact: String
    var phone: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case objectId = "objectid"
        case sideId = "sideid"
        case title = "title"
        case contact = "contact"
        case phone = "phone"
        case description = "description"
    }
}

class BASmartCustomerListTimelineAddNewViewController: BaseViewController {

    @IBOutlet weak var buttonPassive: UIButton!
    @IBOutlet weak var buttonActive: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var viewTitle: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewContact: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewPhone: BASmartCustomerListDefaultCellView!
    
    @IBOutlet weak var textViewContent: UITextView!
    
    var objectId = 0
    var state = 1
    var delegate: AddNewDiaryDelegate?
    var blurDelegate: BlurViewDelegate?
    var name = ""
    var textViewPlaceholder = "Nhập nội dung tương tác"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        title = "THÊM MỚI LỊCH SỬ TƯƠNG TÁC"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().defaultColor()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        stateButtonTap(isButtonActive: true)
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4", alpha: 0.5).cgColor
        
        name = UserInfo.shared.name
        viewTitle.setupView(title: "Tiêu đề",
                            placeholder: "Nhập tên tiêu đề",
                            isNumberOnly: false,
                            content: "",
                            isAllowSelect: true,
                            isPhone: false,
                            isUsingLabel: false)
        viewContact.setupView(title: "Liên hệ",
                              placeholder: "Nhập thông tin liên hệ",
                              isNumberOnly: false,
                              content: name,
                              isAllowSelect: false,
                              isPhone: false,
                              isUsingLabel: false)
        viewPhone.setupView(title: "SĐT",
                            placeholder: "Nhập số điện thoại",
                            isNumberOnly: true,
                            content: "",
                            isAllowSelect: true,
                            isPhone: true,
                            isUsingLabel: false)
        
        if textViewContent.text == "" {
            textViewContent.text = textViewPlaceholder
            textViewContent.textColor = UIColor.lightGray
        }
        textViewContent.selectedTextRange = textViewContent.textRange(from: textViewContent.beginningOfDocument, to: textViewContent.beginningOfDocument)
        textViewContent.delegate = self
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor().defaultColor().cgColor
        view.layer.cornerRadius = 14
    }
    
    private func stateButtonTap(isButtonActive: Bool) {
        let imageActive = isButtonActive == true ? UIImage(named: "dot_blue")?.resizeImage(targetSize: CGSize(width: 15, height: 15)) : UIImage(named: "dot_gray")?.resizeImage(targetSize: CGSize(width: 15, height: 15))
        let imagePassive = isButtonActive == true ? UIImage(named: "dot_gray")?.resizeImage(targetSize: CGSize(width: 15, height: 15)) : UIImage(named: "dot_blue")?.resizeImage(targetSize: CGSize(width: 15, height: 15))
        buttonActive.setImage(imageActive, for: .normal)
        buttonPassive.setImage(imagePassive, for: .normal)
        state = isButtonActive == true ? 1 : 2
        viewContact.textView.text = isButtonActive == true ? name : ""
        viewContact.textView.isUserInteractionEnabled = !isButtonActive
    }
    
    @IBAction func buttonActiveTap(_ sender: Any) {
        stateButtonTap(isButtonActive: true)
    }
    
    @IBAction func buttonPassiveTap(_ sender: Any) {
        stateButtonTap(isButtonActive: false)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        let description = textViewContent.text == textViewPlaceholder ? "" : textViewContent.text
        
        let param = BASmartCustomerDiary(objectId: objectId,
                                         sideId: state,
                                         title: viewTitle.textView.text ?? "",
                                         contact: viewContact.textView.text ?? "",
                                         phone: viewPhone.textView.text ?? "",
                                         description: description ?? "")
        Network.shared.BASmartAddCustomerTimeline(param: param) { [weak self] (data) in
            if data?.error_code != 0 {
                self?.presentBasicAlert(title: "Lỗi", message: data?.message ?? "", buttonTittle: "Đồng ý")
            } else {
                let alert = UIAlertController(title: "Thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel, handler: { [weak self] (action) in
                    self?.delegate?.addNewDiary()
                    self?.blurDelegate?.hideBlur()
                    self?.dismiss(animated: true, completion: nil)
                }))
                
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
}

extension BASmartCustomerListTimelineAddNewViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = textViewPlaceholder
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        else {
            return true
        }
        
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
