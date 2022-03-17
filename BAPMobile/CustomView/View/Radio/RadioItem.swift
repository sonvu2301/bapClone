//
//  RadioItem.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 16/03/2022.
//

import UIKit

class RadioItem: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    var imageView = UIImageView(image: UIImage(named: "radio-uncheck"))
    var label = UILabel()
    
    func setupSubviews(){
        //26A0D8
        imageView.contentMode = .scaleAspectFit
        label.font = label.font.withSize(13)
        imageView.setImageColor(color: .gray)
        addSubview(imageView)
        addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    func setupView(name: String, isCheck: Bool = false){
        label.text = name
        if isCheck{
            imageView.image = UIImage(named: "radio-check")
            imageView.setImageColor(color: UIColor(hexString: "#26A0D8"))
        }
        else{
            imageView.image = UIImage(named: "radio-uncheck")
            imageView.setImageColor(color: .gray)
        }
    }
}
