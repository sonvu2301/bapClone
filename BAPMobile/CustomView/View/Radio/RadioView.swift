//
//  RadioView.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 16/03/2022.
//

import Foundation
import UIKit
class RadioView: UIStackView{
    
    var selectItem = Catalog()
    var list = [Catalog()]
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    func initView(){
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
        spacing = 10
    }
    func setupView(list: [Catalog], idx: Int = -1){
        self.list = list
        setupView()
    }
    func setupView(idx: Int = -1){
        if self.list.count == 0{
            return
        }
        for i in 0..<self.list.count{
            let radio = RadioItem(frame: CGRect.zero)
            radio.setupView(name: self.list[i].name ?? "", isCheck: idx == i)
            let tapp = RadioViewCustomTap(target: self, action: #selector(selectRadio))
            tapp.index = i
            tapp.item = self.list[i]
            radio.addGestureRecognizer(tapp)
            addArrangedSubview(radio)
        }
    }
    func constrainFull(parentView: UIView){
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: parentView.topAnchor ).isActive = true
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
    @objc func selectRadio(sender: RadioViewCustomTap){
        selectItem = sender.item
        self.subviews.forEach({ $0.removeFromSuperview() })
        setupView(idx: sender.index)
        print(sender.index)
        
    }
}
class RadioViewCustomTap: UITapGestureRecognizer{
    var index = -1
    var item = Catalog()
}

