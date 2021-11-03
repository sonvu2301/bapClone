//
//  BASmartCallDataViewController.swift
//  BAPMobile
//
//  Created by Emcee on 3/8/21.
//

import UIKit

class BASmartCallDataViewController: BaseSideMenuViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var dayData = [DateScroll]()
    var data = [BASmartCallData]()
    var allDays = [Date]()
    var today = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "DỮ LIỆU CUỘC GỌI"
    }
    
    private func setupView() {
        
        collectionView.register(UINib(nibName: "DateScrollCell", bundle: nil), forCellWithReuseIdentifier: "DateScrollCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addShadow(cornerRadius: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "BASmartCallHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCallHistoryTableViewCell")
        
        //Get and add day to array
        allDays = Date().getWeekDate(isNextWeek: false, date: Date()) + [Date()] + Date().getWeekDate(isNextWeek: true, date: Date())
        appendDay()
        
        let todayIndex = allDays.firstIndex(of: today) ?? 0
        let index = IndexPath(row: todayIndex, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.selectCellDate(index: index.row, animated: true)
        }
        
        getListPlan(day: Int(today.timeIntervalSinceReferenceDate))
    }
    
    private func selectCellDate(index: Int, animated: Bool) {
        //Reset select data
        selectedDay(index: index)
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: animated)
        getListPlan(day: Int(dayData[index].date.timeIntervalSince1970))
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
        Network.shared.BASmartCallList(day: day) { [weak self] (data) in
            self?.data = data ?? [BASmartCallData]()
            self?.collectionView.reloadData()
            self?.tableView.reloadData()
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

extension BASmartCallDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCallHistoryTableViewCell", for: indexPath) as! BASmartCallHistoryTableViewCell
        let dataParse = data[indexPath.row]
        cell.setupData(content: dataParse.name ?? "",
                       phone: dataParse.phone ?? "",
                       time: dataParse.call ?? 0)
        return cell
    }
}


extension BASmartCallDataViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            selectCellDate(index: indexPath.row, animated: false)
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

extension BASmartCallDataViewController: UIScrollViewDelegate {
    
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
