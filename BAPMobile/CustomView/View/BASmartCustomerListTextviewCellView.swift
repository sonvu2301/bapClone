//
//  BASmartCustomerListTextviewCellView.swift
//  BAPMobile
//
//  Created by Emcee on 1/12/22.
//

import UIKit

class BASmartCustomerListTextviewCellView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var labelName: UILabel!
    
    var textViewPlaceholder = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BASmartCustomerListTextviewCellView", owner: self, options: nil)
        addSubview(contentView)
        textView.autocorrectionType = .no
        textView.delegate = self
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        textView.text = textViewPlaceholder
        textView.textColor = .lightGray
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        textView.delegate = self
    }
    
    func setupView(name: String, placeHolder: String, content: String) {
        textViewPlaceholder = placeHolder
        labelName.text = name
        if content != "" {
            textView.text = content
        }
    }
}

extension BASmartCustomerListTextviewCellView: UITextViewDelegate {
    
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
        if self.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
