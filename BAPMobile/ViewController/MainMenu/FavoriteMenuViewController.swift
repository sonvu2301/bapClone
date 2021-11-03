//
//  FavoriteMenuViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/4/20.
//

import UIKit

class FavoriteMenuViewController: UIViewController {

    @IBOutlet weak var emptyLabel: UILabel!
    let data: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        let isShowEmptyLabel = data.count > 0 ? true : false
        emptyLabel.isHidden = isShowEmptyLabel
    }
}
