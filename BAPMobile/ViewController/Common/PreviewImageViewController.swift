//
//  PreviewImageViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/4/21.
//

import UIKit
import Kingfisher

class PreviewImageViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var list = [String]()
    var index = 0
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        collectionView.register(UINib(nibName: "BASmartSellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BASmartSellCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.collectionView.scrollToItem(at: IndexPath(row: self?.index ?? 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    @IBAction func buttonBackTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PreviewImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BASmartSellCollectionViewCell", for: indexPath) as! BASmartSellCollectionViewCell
        cell.setupData(imageUrl: list[indexPath.row], isSquare: false)
        cell.image.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
