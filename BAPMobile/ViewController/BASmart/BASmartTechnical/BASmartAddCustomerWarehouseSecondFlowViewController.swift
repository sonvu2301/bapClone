//
//  BASmartAddCustomerWarehouseSecondFlowViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/30/21.
//

import UIKit

class BASmartAddCustomerWarehouseSecondFlowViewController: BaseViewController {

    var catalog = BASmartWarehouseCatalogData()
    
    @IBOutlet weak var buttonApproach: UIButton!
    
    @IBOutlet weak var viewHide: UIView!
    @IBOutlet weak var viewPKind: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewApproach: BASmartCustomerListCatalogView!
    @IBOutlet weak var viewRate: BASmartCustomerListDropdownView!
    @IBOutlet weak var viewResult: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewVehicleCount: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewExpectedTime: BASmartCustomerListCalendarView!
    @IBOutlet weak var viewNextTime: BASmartCustomerListCalendarView!
    
    @IBOutlet weak var textViewScheme: UITextView!
    
    var isIgnore = false
    var textViewPlaceholder = "Nhập đề xuất..."
    var approachProjectList = [BASmartDetailInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.setupView()
        }
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        buttonApproach.setImage(UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 25, height: 25)), for: .normal)
        
        viewPKind.setupView(title: "Kiểu t.x",
                            placeholder: "Chọn kiểu tiếp xúc...",
                            content: catalog.pkind?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: false)}) ?? [BASmartCustomerCatalogItems](),
                            name: "",
                            id: 0)
        
        viewApproach.setupView(name: "D.án t.x",
                               content: "")
        viewApproach.delegate = self
        
        viewRate.setupView(title: "Đánh giá",
                            placeholder: "Chọn mã đánh giá...",
                            content: catalog.rate?.map({BASmartCustomerCatalogItems(id: $0.id, ri: 0, name: $0.name, target: false)}) ?? [BASmartCustomerCatalogItems](),
                            name: "",
                            id: 0)
        
        viewResult.setupView(title: "Kết quả",
                             placeholder: "Nhập kết quả...",
                             isNumberOnly: false,
                             content: "",
                             isAllowSelect: true,
                             isPhone: false,
                             isUsingLabel: false)
        
        viewVehicleCount.setupView(title: "Số xe",
                                   placeholder: "",
                                   isNumberOnly: true,
                                   content: "0",
                                   isAllowSelect: true,
                                   isPhone: false,
                                   isUsingLabel: false)
        
        viewExpectedTime.setupView(title: "Ngày lắp",
                                   birth: "",
                                   placeHolder: "Chọn ngày lắp...")
        
        viewNextTime.setupView(title: "Lịch hẹn",
                                   birth: "",
                                   placeHolder: "Chọn lịch hẹn...")
        
        textViewScheme.text = textViewPlaceholder
        textViewScheme.textColor = .lightGray
        textViewScheme.selectedTextRange = textViewScheme.textRange(from: textViewScheme.beginningOfDocument, to: textViewScheme.beginningOfDocument)
        textViewScheme.delegate = self
    }
    
    
    @IBAction func buttonApproachTap(_ sender: Any) {
        isIgnore = !isIgnore
        let iconCheck = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        let iconUncheck = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 25, height: 25))
        
        let img = isIgnore == true ? iconCheck : iconUncheck
        buttonApproach.setImage(img, for: .normal)
        viewHide.isHidden = !isIgnore
        
    }
    
}

extension BASmartAddCustomerWarehouseSecondFlowViewController: BASmartCustomerListOpenCatalogDelegate {
    func buttonTap() {
        let vc = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartWarehouseCatalogViewController") as! BASmartWarehouseCatalogViewController
        vc.data = approachProjectList
        vc.catalog = catalog.approachProject ?? [BASmartDetailInfo]()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BASmartAddCustomerWarehouseSecondFlowViewController: BASmartWarehouseCatalogDelegate {
    func selectItem(items: [BASmartDetailInfo]) {
        approachProjectList = items
        var name = ""
        items.forEach { item in
            name += "\(item.name ?? ""), "
        }
        name = String(name.dropLast())
        name = String(name.dropLast())
        viewApproach.labelContent.text = name
    }
    
    
}

extension BASmartAddCustomerWarehouseSecondFlowViewController: UITextViewDelegate {
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
