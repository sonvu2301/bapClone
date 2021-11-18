//
//  BASmartCustomerInformationViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/12/21.
//

import UIKit
import Kingfisher

protocol BASmartCustomerMainMenuActionDelegate {
    func mainMenuAction(type: BASmartMenuAction)
}

protocol BackToPreviousVCDelegate {
    func backToPrevious()
}

enum ScrollInBASmartInformation {
    case general, humanList, competitor, approach
    
    var contentOffset: CGFloat {
        switch self {
        case .general:
            return 0
        case .humanList:
            return 1
        case .competitor:
            return 2
        case .approach:
            return 3
        }
    }
}

class BASmartCustomerInformationViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var buttonGeneralInfo: UIButton!
    @IBOutlet weak var buttonHumanList: UIButton!
    @IBOutlet weak var buttonCompetitor: UIButton!
    @IBOutlet weak var buttonApproach: UIButton!
    
    @IBOutlet weak var viewGeneralInfoSeperate: UIView!
    @IBOutlet weak var viewHumanListSeperate: UIView!
    @IBOutlet weak var viewCompetitorSeperate: UIView!
    @IBOutlet weak var viewApproachSeperate: UIView!
    @IBOutlet weak var viewSell: UIView!
    
    @IBOutlet weak var viewSellHeight: NSLayoutConstraint!
    
    var scrollType: ScrollInBASmartInformation = .general
    var data = BASmartCustomerDetailData()
    var objectId = 0
    var lastContentOffset: CGFloat = 0
    var kind = 0
    var phoneKindId = 0
    var imagesSell = [UIImage]()
    var isShowAddNewItem = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "THÔNG TIN KHÁCH HÀNG"
    }
    
    private func setupView() {
        viewSell.isHidden = true
        viewSell.setViewCorner(radius: 10)
        viewSell.layer.borderWidth = 1
        viewSell.layer.borderColor = UIColor.black.cgColor
        viewSell.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: view.frame.width * 4, height: 0)
        scrollView.delegate = self
        lastContentOffset = view.frame.width
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BASmartCustomListGalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BASmartCustomListGalleryCollectionViewCell")
        collectionView.contentInsetAdjustmentBehavior = .never
        
        
        //setup child views
        let vc1 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerInformationDetailViewController") as! BASmartCustomerInformationDetailViewController
        let vc2 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerInformationHumanListViewController") as! BASmartCustomerInformationHumanListViewController
        let vc3 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerInformationCompetitorViewController") as! BASmartCustomerInformationCompetitorViewController
        let vc4 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerInformationApproachViewController") as! BASmartCustomerInformationApproachViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc3.view.frame = CGRect(x: view.frame.width * 2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc4.view.frame = CGRect(x: view.frame.width * 3, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        self.addChild(vc1)
        self.addChild(vc2)
        self.addChild(vc3)
        self.addChild(vc4)
        scrollView.addSubview(vc1.view)
        scrollView.addSubview(vc2.view)
        scrollView.addSubview(vc3.view)
        scrollView.addSubview(vc4.view)
        
        vc1.data = data.general_info ?? BASmartCustomerDetailGeneral()
        vc2.data = data.human_list ?? [BASmartCustomerDetailHumanList]()
        vc3.data = data.competitor_list ?? [BASmartCustomerDetailCompetitorList]()
        vc4.data = data.approach_list ?? [BASmartCustomerDetailApproachList]()
        
        vc1.menuAction = data.menu_action?.main ?? [BASmartDetailMenuDetail]()
        vc2.menuAction = data.menu_action?.human ?? [BASmartDetailMenuDetail]()
        vc3.menuAction = data.menu_action?.competitor ?? [BASmartDetailMenuDetail]()
        vc4.menuAction = data.menu_action?.approach ?? [BASmartDetailMenuDetail]()
        
        vc2.customerId = data.general_info?.object_id ?? 0
        vc3.customerId = data.general_info?.object_id ?? 0
        vc4.customerId = data.general_info?.object_id ?? 0
        vc2.objectId = objectId
        vc3.objectId = objectId
        vc4.objectId = objectId
        
        vc1.objectId = objectId
        vc1.delegate = self
        vc1.updateDelegate = self
        
        vc2.kindId = kind
        vc3.kindId = kind
        vc4.kindId = kind
        
        vc1.phoneKindId = phoneKindId
        
        vc1.setupView()
        vc2.setupView()
        vc3.setupView()
        vc4.setupView()
        scrollToView(scrollTo: .general)
        scrollView.isPagingEnabled = true
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "menu")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(openMenuTabBar))
        navigationItem.rightBarButtonItem = menuBarButton
        
        
        collectionView.reloadData()
    }
    
    private func scrollToView(scrollTo: ScrollInBASmartInformation) {
        scrollType = scrollTo
        lastContentOffset = view.frame.width * scrollTo.contentOffset
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.scrollView.setContentOffset(CGPoint(x: self?.lastContentOffset ?? 0, y: 0), animated: false)
        }
        
        buttonGeneralInfo.backgroundColor = UIColor(hexString: "C8C8C8")
        buttonHumanList.backgroundColor = UIColor(hexString: "C8C8C8")
        buttonCompetitor.backgroundColor = UIColor(hexString: "C8C8C8")
        buttonApproach.backgroundColor = UIColor(hexString: "C8C8C8")
        
        buttonGeneralInfo.setTitleColor(.black, for: .normal)
        buttonHumanList.setTitleColor(.black, for: .normal)
        buttonCompetitor.setTitleColor(.black, for: .normal)
        buttonApproach.setTitleColor(.black, for: .normal)
        
        viewGeneralInfoSeperate.backgroundColor = .clear
        viewHumanListSeperate.backgroundColor = .clear
        viewCompetitorSeperate.backgroundColor = .clear
        viewApproachSeperate.backgroundColor = .clear
        
        switch scrollTo {
        case .general:
            buttonGeneralInfo.backgroundColor = .white
            buttonGeneralInfo.setTitleColor(UIColor().defaultColor(), for: .normal)
            viewGeneralInfoSeperate.backgroundColor = UIColor().defaultColor()
        case .humanList:
            buttonHumanList.backgroundColor = .white
            buttonHumanList.setTitleColor(UIColor().defaultColor(), for: .normal)
            viewHumanListSeperate.backgroundColor = UIColor().defaultColor()
        case .competitor:
            buttonCompetitor.backgroundColor = .white
            buttonCompetitor.setTitleColor(UIColor().defaultColor(), for: .normal)
            viewCompetitorSeperate.backgroundColor = UIColor().defaultColor()
        case .approach:
            buttonApproach.backgroundColor = .white
            buttonApproach.setTitleColor(UIColor().defaultColor(), for: .normal)
            viewApproachSeperate.backgroundColor = UIColor().defaultColor()
        }
    }
    
    private func getData() {
        Network.shared.BASmartGetCustomerDetail(objectId: objectId, kindId: kind) { [weak self] (data) in
            self?.data = data ?? BASmartCustomerDetailData()
            self?.setupView()
            self?.collectionView.reloadData()
        }
    }
    
    @objc func openMenuTabBar() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCustomerListMenuActionViewController") ?? UIViewController()) as! BASmartCustomerListMenuActionViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.delegate = self
        popoverContent.blurDelegate = self
        popoverContent.data = data.menu_action?.main ?? [BASmartDetailMenuDetail]()
        // Set height
        // Get the number of item without edit and delete action
        let menuItemsShow = data.menu_action?.main?.filter({$0.id != BASmartMenuAction.edit.id &&
                                                            $0.id != BASmartMenuAction.delete.id &&
                                                            $0.id != BASmartMenuAction.diary.id})
        let menuHeight = ( (menuItemsShow?.count ?? 0) - 1 ) * 40
        popoverContent.preferredContentSize = CGSize(width: 250, height: menuHeight)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: view.frame.width, y: (navigationController?.navigationBar.frame.height ?? 44) + 90, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    private func openSellViewController(partner: String, kind: Int) {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerMainSellFlowViewController") as! BASmartCustomerMainSellFlowViewController
        vc.objectId = objectId
        vc.partner = partner
        vc.kind = kind
        navigationController?.pushViewController(vc, animated: true)
        viewSell.isHidden = true
    }
    
    @IBAction func buttonGeneralInfoTap(_ sender: Any) {
        scrollToView(scrollTo: .general)
    }
    
    @IBAction func buttonHumanListTap(_ sender: Any) {
        scrollToView(scrollTo: .humanList)
    }
    
    @IBAction func buttonCompetitorTap(_ sender: Any) {
        scrollToView(scrollTo: .competitor)
    }
    
    @IBAction func buttonApproachTap(_ sender: Any) {
        scrollToView(scrollTo: .approach)
    }
    
    @IBAction func buttonCloseSelectSellView(_ sender: Any) {
        hideBlurBackground()
        viewSell.isHidden = true
    }
    
}

extension BASmartCustomerInformationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let conditionOffset = view.frame.width * 0.5
        switch scrollType {
        case .general:
            if contentOffset >= conditionOffset {
                scrollToView(scrollTo: .humanList)
            }
        case .humanList:
            if contentOffset >= (lastContentOffset + conditionOffset) {
                scrollToView(scrollTo: .competitor)
            } else if contentOffset <= (lastContentOffset - conditionOffset) {
                scrollToView(scrollTo: .general)
            }
        case .competitor:
            if contentOffset >= (lastContentOffset + conditionOffset) {
                scrollToView(scrollTo: .approach)
            } else if contentOffset <= (lastContentOffset - conditionOffset) {
                scrollToView(scrollTo: .humanList)
            }
        case .approach:
            if contentOffset <= (lastContentOffset - conditionOffset) {
                scrollToView(scrollTo: .competitor)
            }
        }
    }    
}

extension BASmartCustomerInformationViewController: BASmartCustomerMainMenuActionDelegate {
    func mainMenuAction(type: BASmartMenuAction) {
        switch type {
        case .none, .edit, .delete, .diary:
            break
        case .checkin:
            checkin()
        case .create:
            createPlan()
        case .tb:
            openSell(type: .TB)
        case .ba:
            openSell(type: .BA)
        case .photoList:
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerListGalleryViewController") as! BASmartCustomerListGalleryViewController
            vc.objectId = objectId
            vc.type = .customer
            navigationController?.pushViewController(vc, animated: true)
        case .history:
            let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerListTimelineViewController") as! BASmartCustomerListTimelineViewController
            vc.objectId = objectId
            navigationController?.pushViewController(vc, animated: true)
        case .tranfer:
            let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartSearchEmployeeViewController") ?? UIViewController()) as! BASmartSearchEmployeeViewController
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = .popover
            let popover = nav.popoverPresentationController
            popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
            popoverContent.blurDelegate = self
            popoverContent.finishDelegate = self
            popoverContent.objectId = objectId
            popover?.delegate = self
            popover?.sourceView = self.view
            popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
            popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
            
            showBlurBackground()
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    private func createPlan() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCreatePlanViewController") ?? UIViewController()) as! BASmartCreatePlanViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 550)
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.name = self.data.general_info?.name ?? ""
        popoverContent.customerId = self.data.general_info?.object_id ?? 0
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    private func checkin() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartApproachViewController") ?? UIViewController()) as! BASmartApproachViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
        popoverContent.customerData = data.general_info ?? BASmartCustomerDetailGeneral()
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.isCheckingCustomer = true
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    private func openSell(type: BASmartSellKindId) {
        showBlurBackground()
        viewSell.isHidden = false
        view.bringSubviewToFront(viewSell)
        kind = type.id
    }
    
    
}

extension BASmartCustomerInformationViewController: BackToPreviousVCDelegate {
    func backToPrevious() {
        navigationController?.popViewController(animated: true)
    }
}

extension BASmartCustomerInformationViewController: BASmartDoneUpdateDelegate {
    func finishUpdate() {
        getData()
    }
}

extension BASmartCustomerInformationViewController: BASmartDoneCreateDelegate {
    func finishCreate() {
        getData()
    }
}

extension BASmartCustomerInformationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = (data.partner_list?.count ?? 0) - 2 >= section * 2 ? 2 : 1
        return number
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let number = (data.partner_list?.count ?? 0) % 2 == 0 ? (data.partner_list?.count ?? 0) / 2 : (data.partner_list?.count ?? 0) / 2 + 1
        viewSellHeight.constant = CGFloat(number * Int(viewSell.frame.size.width) / 2 + 60)
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BASmartCustomListGalleryCollectionViewCell", for: indexPath) as! BASmartCustomListGalleryCollectionViewCell
        let index = indexPath.section * 2 + indexPath.row
        cell.setupData(smallLink: data.partner_list?[index].icon ?? "",
                       bigLink: data.partner_list?[index].icon ?? "",
                       size: 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section * 2 + indexPath.row
        hideBlurBackground()
        openSellViewController(partner: data.partner_list?[index].code ?? "", kind: kind)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = viewSell.frame.size.width / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
