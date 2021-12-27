//
//  AlertDenyViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/25/21.
//

import UIKit

class AlertDenyViewController: UIViewController {

    @IBOutlet weak var viewBoundTextview: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var buttonFirstKind: UIButton!
    @IBOutlet weak var buttonSecondKind: UIButton!
    @IBOutlet weak var buttonThirdKind: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    var state = ScrollState.first
    var kind = 0
    var contentString = ""
    var textViewPlaceholder = "Nhập ghi chú (nếu có)..."
    
    var delegate: AlertActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        setupKindButton(state: state)
        
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.setViewCorner(radius: 5)
        viewBoundTextview.layer.borderWidth = 1
        viewBoundTextview.layer.borderColor = UIColor.black.cgColor
        viewBoundTextview.setViewCorner(radius: 5)
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "BEBEBE").cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        labelContent.text = contentString
        
        textView.text = textViewPlaceholder
        textView.textColor = .lightGray
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        textView.delegate = self
    }
    
    private func setupKindButton(state: ScrollState) {
        let imageCheck = UIImage(named: "ic_check")?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        let imageUncheck = UIImage(named: "ic_uncheck")?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        
        buttonFirstKind.setImage(imageUncheck, for: .normal)
        buttonSecondKind.setImage(imageUncheck, for: .normal)
        buttonThirdKind.setImage(imageUncheck, for: .normal)
        
        kind = state.pkind
        self.state = state
        
        switch state {
        case .first:
            buttonFirstKind.setImage(imageCheck, for: .normal)
        case .second:
            buttonSecondKind.setImage(imageCheck, for: .normal)
        case .third:
            buttonThirdKind.setImage(imageCheck, for: .normal)
        }
    }
    
    @IBAction func buttonFirstKindTap(_ sender: Any) {
        setupKindButton(state: .first)
    }
    
    @IBAction func buttonSecondKindTap(_ sender: Any) {
        setupKindButton(state: .second)
    }
    
    @IBAction func buttonThirdKindTap(_ sender: Any) {
        setupKindButton(state: .third)
    }
    
    @IBAction func buttonRemoveTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        let desc = (textView.text == textViewPlaceholder ? "" : textView.text) ?? ""
        delegate?.delete(kind: kind, message: desc)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AlertDenyViewController: UITextViewDelegate {
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
