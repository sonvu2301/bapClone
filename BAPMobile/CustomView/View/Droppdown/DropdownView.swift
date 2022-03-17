//
//  DropdownView.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 16/03/2022.
//

import Foundation
import UIKit
import DropDown

//protocol ISelectDropdown{
//    func onSelect(item: Catalog)
//}

class DropdownView: UIView{
    
    let dropDown = DropDown()
    var label = UITextField()
    var icon = UIImageView()
    var data = [Catalog()]
    var selectItem = Catalog()
    //var delegate : ISelectDropdown?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    func initView(){
        label.placeholder = "Chọn dữ liệu..."
        label.isUserInteractionEnabled = false
        icon.image = UIImage(named: "ic_arrow_dropdown")
        icon.contentMode = .scaleAspectFit
        addSubview(label)
        addSubview(icon)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: icon.leadingAnchor).isActive = true
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDroppdown))) 
        
        dropDown.anchorView = self
        dropDown.width = self.frame.width
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
    }
    func setupView(data: [Catalog]){
        self.data = data
        dropDown.dataSource = data.map({($0.name ?? "")})
    }
    @objc func showDroppdown(){
        dropDown.show()
        dropDown.selectionAction = { [weak self] (idx: Int, item: String) in
            self?.label.text = item
            self?.selectItem = self?.data[idx] ?? Catalog()
            //self?.delegate?.onSelect(item: self?.data[idx] ?? Catalog())
        }
    }
}
