//
//  ContactBranchTableViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 22/02/2022.
//

import Foundation
import UIKit
class ContactBranchTableViewCell:UICollectionViewCell{
    
    @IBOutlet weak var lblBranch: UILabel!
    
    @IBOutlet weak var lineBranch: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
         
        // Initialization code
    }
    func setData(item : ContactBranch){
        lblBranch.text = item.name;
    }
    
    func selectItem(){
        lineBranch.isHidden = false;
        lblBranch.textColor = UIColor(hexString: "#26A0D8")
    }
    func deSelectItem(){
        lblBranch.textColor = .gray;
        lineBranch.isHidden = true;
    }
    
}
