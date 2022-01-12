//
//  BASmartCustomerCreateApproachViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/10/21.
//

import UIKit
import DKImagePickerController

class BASmartCustomerCreateApproachViewController: BaseViewController {

    @IBOutlet weak var viewTime: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewResult: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewPrice: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewQuantity: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewJudge: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewSale: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewDepartment: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewSelectImage: SelectImageView!
    @IBOutlet weak var viewExpectTime: BASmartCustomerListCalendarView!
    @IBOutlet weak var viewNextTime: BASmartCustomerListCalendarView!
    
    @IBOutlet weak var textViewSuggest: UITextView!
    
    @IBOutlet weak var labelProject: UILabel!
    @IBOutlet weak var labelPurpose: UILabel!
    @IBOutlet weak var labelReason: UILabel!
    
    @IBOutlet weak var buttonFirstPKind: UIButton!
    @IBOutlet weak var buttonSecondPKind: UIButton!
    @IBOutlet weak var buttonThirdPKind: UIButton!
    
    @IBOutlet weak var buttonPurpose: UIButton!
    @IBOutlet weak var buttonReason: UIButton!
    @IBOutlet weak var buttonSelectProject: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    var customerId = 0
    var objectId = 0
    var reasons = [BASmartIdInfo]()
    var projects = [BASmartIdInfo]()
    var purposes = [BASmartIdInfo]()
    var delegate: BASmartAddNewDelegate?
    var blurDelegate: BlurViewDelegate?
    var pkind = 0
    
    var isReasonDelete = false
    var textViewPlaceholder = "Nhập đề xuất"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "THÊM MỚI THÔNG TIN TIẾP XÚC"
    }
    
    private func setupView() {
        viewTime.setupView(title: "Thời điểm",
                           placeholder: "",
                           isNumberOnly: false,
                           content: Date().millisecToDateHourSaved(time: Int(Date().timeIntervalSince1970)),
                           isAllowSelect: false,
                           isPhone: false,
                           isUsingLabel: false)
        
        viewResult.setupView(title: "Kết quả",
                             placeholder: "Nhập kết quả...",
                             isNumberOnly: false,
                             content: "",
                             isAllowSelect: true,
                             isPhone: false,
                             isUsingLabel: false)
        
        viewPrice.setupView(title: "Đơn giá",
                            placeholder: "Nhập đơn giá...",
                            isNumberOnly: true,
                            content: "",
                            isAllowSelect: true,
                            isPhone: false,
                            isUsingLabel: false)
        
        viewQuantity.setupView(title: "Số xe",
                               placeholder: "Nhập số xe",
                               isNumberOnly: true,
                               content: "",
                               isAllowSelect: true,
                               isPhone: false,
                               isUsingLabel: false)
        
        viewExpectTime.setupView(title: "Ngày lắm",
                                 birth: "",
                                 placeHolder: "Chọn ngày lắp...")
        
        viewNextTime.setupView(title: "Lịch hẹn",
                               birth: "",
                               placeHolder: "Chọn lịch hẹn...")
        
        let catalog = BASmartCustomerCatalogDetail.shared
        
        viewJudge.setupView(title: "Đánh giá",
                            placeholder: "Đánh giá kết quả tiếp xúc...",
                            content: catalog.rate,
                            name: "",
                            id: 0)
        viewJudge.showReasonDelegate = self
        
        viewSale.setupView(title: "Chốt sale",
                           placeholder: "Khả năng chốt sale...",
                           content: catalog.ability,
                           name: "",
                           id: 0)
        
        viewDepartment.setupView(title: "Bộ phận",
                                 placeholder: "Chọn bộ phận...",
                                 content: catalog.department,
                                 name: "",
                                 id: 0)
        
        viewSelectImage.delegate = self
        
        viewJudge.buttonDropdown.isUserInteractionEnabled = false
        viewSale.buttonDropdown.isUserInteractionEnabled = false
        
        let bgColor =  UIColor(hexString: "DCDCDC")
        viewJudge.buttonDropdown.backgroundColor = bgColor
        viewSale.buttonDropdown.backgroundColor = bgColor
        
        labelReason.isHidden = true
        buttonReason.isHidden = true
        
        let tapProject = UITapGestureRecognizer(target: self, action: #selector(openProject))
        labelProject.addGestureRecognizer(tapProject)
        labelProject.isUserInteractionEnabled = true
        
        let tapReason = UITapGestureRecognizer(target: self, action: #selector(openReason))
        labelReason.addGestureRecognizer(tapReason)
        labelReason.isUserInteractionEnabled = true
        
        let tapPurpose = UITapGestureRecognizer(target: self, action: #selector(openPurpose))
        labelPurpose.addGestureRecognizer(tapPurpose)
        labelPurpose.isUserInteractionEnabled = true
        
        if textViewSuggest.text == "" {
            textViewSuggest.text = textViewPlaceholder
            textViewSuggest.textColor = UIColor.lightGray
        }
        textViewSuggest.selectedTextRange = textViewSuggest.textRange(from: textViewSuggest.beginningOfDocument, to: textViewSuggest.beginningOfDocument)
        textViewSuggest.delegate = self
        
        let image = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        buttonFirstPKind.setImage(image, for: .normal)
        buttonSecondPKind.setImage(image, for: .normal)
        buttonThirdPKind.setImage(image, for: .normal)
        
        buttonCancel.setViewCorner(radius: 5)
        buttonCancel.layer.borderColor = UIColor(hexString: "DCDCDC").cgColor
        buttonCancel.layer.borderWidth = 1
        buttonConfirm.setViewCorner(radius: 5)
    }
    
    private func createApproach() {
        
        let scheme = textViewSuggest.text == textViewPlaceholder ? "" : textViewSuggest.text
//        let loc = getCurrentLocationParam()
        let loc = BASmartLocationParam(lng: 105.134512365, lat: 21.47512115, opt: 0)
        
        let photos = viewSelectImage.images.map({BASmartDailyWorkingPhotolist(image: $0.resizeImageWithRate().toBase64() ?? "", time: Int(Date().timeIntervalSince1970))})
        
        let param = BASmartCustomerCreateApproachParam(
            customerId: customerId,
            pkind: pkind,
            start: Int(Date().timeIntervalSince1970),
            total: 3600,
            project: projects,
            rate: viewJudge.id,
            reason: reasons,
            ability: viewSale.id,
            result: viewResult.textView.text,
            vehicleCount: Int(viewQuantity.textView.text ?? "0"),
            expect: viewExpectTime.textField.text?.stringToIntDate(),
            scheme: scheme,
            price: Int(viewPrice.textView.text ?? "0"),
            transport: 1,
            next: viewNextTime.textField.text?.stringToIntDate(),
            department: viewDepartment.id,
            location: loc,
            purpose: purposes,
            photo: photos,
            ignore: false)
        
        Network.shared.BASmartCreateApproach(param: param) { [weak self] data in
            if data?.errorCode != 0 {
                self?.presentBasicAlert(title: "Lỗi", message: data?.message ?? "", buttonTittle: "Đồng ý")
            } else {
                
            }
        }
    }
    
    private func openMultiSelectCatalog(type: SelectMultiCatalogType, dataSelect: [BASmartIdInfo]) {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartReasonViewController") as! BASmartReasonViewController
        vc.delegate = self
        vc.dataSelect = dataSelect
        vc.type = type
        if type == .purpose {
            vc.isRate = true
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func selectPKind(state: ScrollState) {
        let imageUncheck = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let imageCheck = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        buttonFirstPKind.setImage(imageUncheck, for: .normal)
        buttonSecondPKind.setImage(imageUncheck, for: .normal)
        buttonThirdPKind.setImage(imageUncheck, for: .normal)
        switch state {
        case .first:
            buttonFirstPKind.setImage(imageCheck, for: .normal)
            pkind = ScrollState.first.pkind
        case .second:
            buttonSecondPKind.setImage(imageCheck, for: .normal)
            pkind = ScrollState.second.pkind
        case .third:
            buttonThirdPKind.setImage(imageCheck, for: .normal)
            pkind = ScrollState.third.pkind
        }
    }
    
    @objc func openProject() {
        openMultiSelectCatalog(type: .project, dataSelect: projects)
    }
    
    @objc func openReason() {
        openMultiSelectCatalog(type: .reason, dataSelect: reasons)
    }
    
    @objc func openPurpose() {
        openMultiSelectCatalog(type: .purpose, dataSelect: purposes)
    }
    
    @IBAction func buttonSelectProjectTap(_ sender: Any) {
        openMultiSelectCatalog(type: .project, dataSelect: projects)
    }
    
    @IBAction func buttonReasonTap(_ sender: Any) {
        if isReasonDelete {
            labelReason.text = ""
            reasons = [BASmartIdInfo]()
            buttonReason.setImage(UIImage(named: "edit"), for: .normal)
            isReasonDelete = false
        } else {
            openMultiSelectCatalog(type: .reason, dataSelect: reasons)
        }
    }
    
    @IBAction func buttonSelectPurposeTap(_ sender: Any) {
        openMultiSelectCatalog(type: .purpose, dataSelect: purposes)
    }
    
    @IBAction func buttonFirstPKindTap(_ sender: Any) {
        selectPKind(state: .first)
    }
    
    @IBAction func buttonSecondPKindTap(_ sender: Any) {
        selectPKind(state: .second)
    }
    
    @IBAction func buttonThirdPKindTap(_ sender: Any) {
        selectPKind(state: .third)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        createApproach()
    }
    
}

extension BASmartCustomerCreateApproachViewController: UpdateImageDelegate {
    func deleteImage(index: Int) {
        
    }
    
    func addImage() {
        let pickerController = DKImagePickerController()
        pickerController.modalPresentationStyle = .overFullScreen
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

extension BASmartCustomerCreateApproachViewController: RateDelegate {
    
    func showReason(isShow: Bool) {
        buttonReason.isHidden = !isShow
        labelReason.isHidden = !isShow
        labelReason.text = ""
        reasons = [BASmartIdInfo]()
    }
}


extension BASmartCustomerCreateApproachViewController: GetReasonListDelegate {
    func showRate(isShow: Bool) {
        viewJudge.dropDownStatus(isShow: isShow)
        viewSale.dropDownStatus(isShow: isShow)
        
        if !isShow {
            labelReason.text = ""
            reasons = [BASmartIdInfo]()
            buttonReason.isHidden = true
            labelReason.isHidden = true
            
            viewJudge.listId = [BASmartIdInfo]()
            viewSale.listId = [BASmartIdInfo]()
        }
    }
    
    func selectList(type: SelectMultiCatalogType, data: [BASmartIdInfo], name: String) {
        switch type {
        case .reason:
            reasons = data
            labelReason.text = name
            let image = name.count > 0 ? UIImage(named: "ic_delete") : UIImage(named: "edit")
            buttonReason.setImage(image, for: .normal)
            isReasonDelete = name.count > 0 ? true : false
        case .project:
            projects = data
            labelProject.text = name
        case .purpose:
            purposes = data
            labelPurpose.text = name
        }
    }
}

extension BASmartCustomerCreateApproachViewController: UITextViewDelegate {
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
