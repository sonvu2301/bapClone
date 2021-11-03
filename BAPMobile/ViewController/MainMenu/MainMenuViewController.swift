//
//  MainMenuViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/4/20.
//

import UIKit
import Alamofire

enum State {
    case all
    case favorite
}

class MainMenuViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var allMenuButton: UIButton!
    @IBOutlet weak var slideImage: UICollectionView!
    
    var images = [UIImage]()
    var lastContentOffset: CGFloat = 0
    var imageIndex = 0
    var data: LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlideImage()
        setupMainScrollView()
        detectAppToBackGround()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        scrollMenu(isScrollToFavorite: false, scrollView: mainScrollView)
    }
    
    
    //Check if app go to back ground
    private func detectAppToBackGround() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
    
    @objc func willResignActive(_ notification: Notification) {
        scrollMenu(isScrollToFavorite: false, scrollView: mainScrollView)
    }
    
    @IBAction func favoriteButtonTap(_ sender: Any) {
        scrollMenu(isScrollToFavorite: true, scrollView: mainScrollView)
    }
    
    @IBAction func allMenuButtonTap(_ sender: Any) {
        scrollMenu(isScrollToFavorite: false, scrollView: mainScrollView)
    }
    
}

extension MainMenuViewController: UIScrollViewDelegate {
    
    private func setupMainScrollView() {
        mainScrollView.contentSize = CGSize(width: view.frame.width * 2, height: 0)
        mainScrollView.setContentOffset(CGPoint(x: mainScrollView.frame.width, y: 0), animated: false)
        mainScrollView.delegate = self
        lastContentOffset = view.frame.width
        
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoriteMenuViewController") as! FavoriteMenuViewController
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllMainMenuViewController") as! AllMainMenuViewController
        //pass data
        vc2.data = self.data?.data.menu_list
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: mainScrollView.frame.width, height: mainScrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width, y: 0, width: mainScrollView.frame.width, height: mainScrollView.frame.height)
        self.addChild(vc1)
        self.addChild(vc2)
        mainScrollView.addSubview(vc1.view)
        mainScrollView.addSubview(vc2.view)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = view.frame.width
        let contentOffset = scrollView.contentOffset.x
        if scrollView == mainScrollView {
            if lastContentOffset == width && contentOffset < (lastContentOffset - 100) {
                scrollMenu(isScrollToFavorite: true, scrollView: scrollView)
            } else if lastContentOffset == 0 && contentOffset > 100 {
                scrollMenu(isScrollToFavorite: false, scrollView: scrollView)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let width = view.frame.width
        if scrollView == mainScrollView {
            if lastContentOffset == width && scrollView.contentOffset.x > (lastContentOffset - 100) {
                scrollMenu(isScrollToFavorite: false, scrollView: scrollView)
            } else if lastContentOffset == 0 && scrollView.contentOffset.x < 100 {
                scrollMenu(isScrollToFavorite: true, scrollView: scrollView)
            }
        } else if scrollView == slideImage {
            imageIndex = slideImage.indexPathsForVisibleItems[0].row
        }
    }
    
    private func scrollMenu(isScrollToFavorite: Bool, scrollView: UIScrollView) {
        if isScrollToFavorite {
            UIView.animate(withDuration: 0.5) {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            } completion: { [weak self] (done) in
                self?.lastContentOffset = 0
                self?.allMenuButton.titleLabel?.textColor = .gray
                self?.favoriteButton.titleLabel?.textColor = UIColor().defaultColor()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0), animated: false)
            } completion: { [weak self] (done) in
                self?.lastContentOffset = self?.view.frame.width ?? 0
                self?.allMenuButton.titleLabel?.textColor = UIColor().defaultColor()
                self?.favoriteButton.titleLabel?.textColor = .gray
            }
        }
    }
}

//Top slide image
extension MainMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    private func setupSlideImage() {
        //add image name in data
        data?.data.header.forEach({ (item) in
            images.append(UIImage(named: item.src) ?? UIImage())
        })
        
        //setup slide image
        slideImage.delegate = self
        slideImage.dataSource = self
        slideImage.contentInsetAdjustmentBehavior = .never
        let maxImage = images.count - 1
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {  [weak self] (timer) in
            if self?.imageIndex ?? 0 < maxImage {
                self?.imageIndex += 1
                self?.slideImage.scrollToItem(at: IndexPath(row: self?.imageIndex ?? 0, section: 0), at: .centeredHorizontally, animated: true)
            } else {
                self?.imageIndex = 0
                self?.slideImage.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideImage", for: indexPath) as! SlideImageCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = slideImage.frame.size
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
