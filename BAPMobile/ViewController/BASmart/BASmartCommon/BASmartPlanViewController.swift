//
//  BASmartPlanViewController.swift
//  BAPMobile
//
//  Created by Emcee on 3/2/21.
//

import UIKit

struct DateScroll {
    var date: Date
    var dateString: String
    var dateOfWeek: String
    var isSelect: Bool
    var isSideCell: Bool
}

protocol BASmartPlanMenuActionDelegate {
    func menuAction(action: BASmartPlanMenuAction, data: BASmartPlanListData)
    func buttonCallTap(objectId: Int)
}

class BASmartPlanViewController: BaseSideMenuViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    
    var dayData = [DateScroll]()
    var data = [BASmartPlanListData]()
    var allDays = [Date]()
    var today = Date()
    var day = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "KẾ HOẠCH LÀM VIỆC"
    }
    
    private func setupView() {
        
        //Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ic_add")?.resizeImage(targetSize: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(addButtonAction))
        collectionView.register(UINib(nibName: "DateScrollCell", bundle: nil), forCellWithReuseIdentifier: "DateScrollCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartPlanListCellTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartPlanListCellTableViewCell")
        tableView.estimatedRowHeight = 430
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        shadowView.addShadow(cornerRadius: 0)
        
        //Get and add day to array
        allDays = Date().getWeekDate(isNextWeek: false, date: Date()) + [Date()] + Date().getWeekDate(isNextWeek: true, date: Date())
        appendDay()
        
        let todayIndex = allDays.firstIndex(of: today) ?? 0
        let index = IndexPath(row: todayIndex, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.selectCellDate(index: index.row, animated: true)
        }
        
        getCatalog()
    }
    
    private func selectCellDate(index: Int, animated: Bool) {
        //Reset select data
        selectedDay(index: index)
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: animated)
        day = Int(dayData[index].date.timeIntervalSince1970)
        getListPlan(day: day)
    }
    
    @objc func addButtonAction() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCreatePlanViewController") ?? UIViewController()) as! BASmartCreatePlanViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 550)
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    private func selectedDay(index: Int) {
        for i in 0..<dayData.count {
            dayData[i].isSelect = false
            dayData[i].isSideCell = false
        }
        dayData[index].isSelect = true
        if index > 0 {
            dayData[index - 1].isSideCell = true
        }
        if index < dayData.count - 1 {
            dayData[index + 1].isSideCell = true
        }
    }
    
    private func getListPlan(day: Int) {
        Network.shared.BASmartPlanList(day: day) { [weak self] (data) in
            self?.data = data ?? [BASmartPlanListData]()
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
        }
    }
    
    
    private func appendDay() {
        allDays.forEach { [weak self] (item) in
            let dayOfWeek = Date().dayOfWeek(date: item)
            let date = Date().dateToDayMonth(date: item)
            if date == Date().dateToDayMonth(date: Date()) {
                today = item
            }
            self?.dayData.append(DateScroll(date: item,
                                            dateString: date,
                                            dateOfWeek: dayOfWeek,
                                            isSelect: false,
                                            isSideCell: false))
            self?.collectionView.reloadData()
        }
        let todayIndex = allDays.firstIndex(of: today) ?? 0
        selectedDay(index: todayIndex)
    }
    
    private func addDate(isNextWeek: Bool) {
        if isNextWeek {
            allDays = allDays + Date().getWeekDate(isNextWeek: true, date: allDays[allDays.count - 1])
        } else {
            allDays = Date().getWeekDate(isNextWeek: false, date: allDays[0]) + allDays
        }
        dayData = [DateScroll]()
        appendDay()
    }
}

extension BASmartPlanViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dayData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateScrollCell", for: indexPath) as! DateScrollCell
        cell.setupData(setting: dayData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            addDate(isNextWeek: false)
            selectCellDate(index: indexPath.row + 7, animated: false)
        } else if indexPath.row == ( dayData.count - 1 ) {
            addDate(isNextWeek: true)
            selectCellDate(index: indexPath.row, animated: true)
        } else {
            selectCellDate(index: indexPath.row, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = Int(collectionView.frame.width / 5)
        return CGSize(width: CGFloat(size), height: collectionView.frame.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension BASmartPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartPlanListCellTableViewCell", for: indexPath) as! BASmartPlanListCellTableViewCell
        let dataParse = data[indexPath.row]
        let isMenu = (dataParse.menuAction?.count ?? 0) > 0 ? true : false
        
        cell.setupDate(data: dataParse,
                       image: dataParse.kindInfo?.src ?? "",
                       title: dataParse.name ?? "",
                       start: dataParse.start ?? 0,
                       end: dataParse.end ?? 0,
                       address: dataParse.address ?? "",
                       purpose: dataParse.purpose ?? [BASmartDetailInfo](),
                       description: dataParse.description ?? "",
                       state: dataParse.stateInfo?.name ?? "",
                       isMenu: isMenu)
        cell.delegate = self
        return cell
    }
    
    
}

extension BASmartPlanViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionView {
            if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)) {
                addDate(isNextWeek: true)
            }
            
            if (scrollView.contentOffset.x < 0){
                addDate(isNextWeek: false)
            }
        }
    }
}



extension BASmartPlanViewController: BASmartPlanMenuActionDelegate {
    func buttonCallTap(objectId: Int) {
        showListPhoneNumber(objectId: objectId, kindId: BASmartKindId.plan.id)
    }
    
    func menuAction(action: BASmartPlanMenuAction, data: BASmartPlanListData) {
        switch action {
        case .signin_approach:
            signinApproach(data: data)
        case .update:
            editPlan(data: data)
        case .receive:
            break
        case .abort:
            deletePlan(id: data.planId ?? 0)
        case .approach_result:
            approach_result(id: data.planId ?? 0)
        case .customer_info:
            customerInfo(data: data)
        }
    }
    
    private func signinApproach(data: BASmartPlanListData) {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartApproachViewController") ?? UIViewController()) as! BASmartApproachViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
        popoverContent.planData = data
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.isCheckingCustomer = false
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    private func approach_result(id: Int) {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartApproachResultViewController") ?? UIViewController()) as! BASmartApproachResultViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 550)
        popoverContent.blurDelegate = self
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        
        Network.shared.BASmartPlanResultApproach(planId: id) { [weak self] (data) in
            if data?.error_code != 0 {
                self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
            } else {
                popoverContent.data = data?.data ?? BASmartApproachResultData()
                self?.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    
    private func customerInfo(data: BASmartPlanListData) {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerInformationViewController") as! BASmartCustomerInformationViewController
        vc.objectId = data.planId ?? 0
        vc.kind = BASmartCustomerGroup.old.id
        vc.phoneKindId = GetPhoneKind.plan.kindId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func deletePlan(id: Int) {
        let alert = UIAlertController(title: "Bạn có chắc muốn xóa kế hoạch?", message: "Sau khi xóa sẽ không thể khôi phục lại kế hoạch", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
            Network.shared.BASmartDeletePlan(objectId: id) { (isDone) in
                self?.presentBasicAlert(title: "Xóa thành công", message: "", buttonTittle: "Đồng ý")
            }
        }))
        alert.addAction(UIAlertAction(title: "Từ chối", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func editPlan(data: BASmartPlanListData) {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCreatePlanViewController") ?? UIViewController()) as! BASmartCreatePlanViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 550)
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.data = data
        popoverContent.isEdit = true
        popoverContent.day = Date().millisecToDate(time: day)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
}

extension BASmartPlanViewController: BASmartDoneCreateDelegate {
    func finishCreate() {
        getListPlan(day: day)
    }
}
