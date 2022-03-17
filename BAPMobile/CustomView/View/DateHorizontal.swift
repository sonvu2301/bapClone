//
//  DateHorizontal.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 04/03/2022.
//

import UIKit
// kiểu enum ngày tháng năm
enum enumDateHorizontal: String {
    case year
    case month
    case day
}

protocol IDateDelegate{
    func selectDateDelegate(date: Date)
    func selectDateDelegate(dateUnx: Int)
}
extension IDateDelegate{
    func selectDateDelegate(date: Date){
        print("chưa append IDateDelegate")
    }
    func selectDateDelegate(dateUnx: Int){
        print("chưa append IDateDelegate")
    }
}
struct DateObject {
    var date: Date
    var isActive : Bool
    init(){
        date = Date().add7()
        isActive = false
    }
    init(date: Date, isActive: Bool){
        self.date = date
        self.isActive = isActive
    }
}

class DateHorizontal: UIView {
    
    @IBOutlet var DateView: UIView!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var dateList = [DateObject]()
    var defaultDate  = Date()
    var minDate  = Date()
    var maxDate = Date()
    var delegate : IDateDelegate?
    private var type : enumDateHorizontal = .month
    // lấy ngày hiện tại để xử lý
    var dateComponentCurrent = Date().add7().getComponents()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    // khởi tạo cấu hình mặc định
    func commonInit(){
        
        Bundle.main.loadNibNamed("DateHorizontal", owner: self, options: nil)
        addSubview(DateView)
        DateView.frame = self.bounds;
        DateView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        CollectionView.dataSource = self;
        CollectionView.delegate = self;
    }
    
    func setType(type : enumDateHorizontal){
        self.type = type
        InitCell()
        setMinDate()
        setMaxDate()
        initData()
        selectCellDate();
    }
    func InitCell(){
        switch type {
        case .year:
            CollectionView.register(UINib(nibName: "YearScrollCell", bundle: nil), forCellWithReuseIdentifier: "YearScrollCell")
        case .month:
            CollectionView.register(UINib(nibName: "MonthScrollCell", bundle: nil), forCellWithReuseIdentifier: "MonthScrollCell")
        case .day:
            CollectionView.register(UINib(nibName: "DateScrollCell", bundle: nil), forCellWithReuseIdentifier: "DateScrollCell")
        }
    }
    
    // MARK: khởi tạo dữ liệu khi các viewcontroller append
    func initData(){
        if type == .month{
            initMonth()
        }
        else if type == .year{
            initYear()
        }
        else if type == .day{
            initDay()
        }
        else {
            initMonth()
        }
        
        
    }
    func initYear(){
        defaultDate = getDate(day: 1, month: 1, year: dateComponentCurrent.year ?? 0)
        let min = minDate.getComponents().year ?? 0
        let max = maxDate.getComponents().year ?? 0
        for i in min...max{
            let d = getDate(day: 1, month: 1, year: i)
            let obj = DateObject(date: d, isActive: d == defaultDate)
            dateList.append(obj)
        }
    }
    func initMonth(){
        defaultDate = getDate(day: 1, month: dateComponentCurrent.month ?? 0, year: dateComponentCurrent.year ?? 0)
        let min = minDate.getComponents().year ?? 0
        let max = maxDate.getComponents().year ?? 0
        for y in min...max{
            for m in 1...12{
                let d = getDate(day: 1, month: m, year: y)
                let obj = DateObject(date: d, isActive: d == defaultDate)
                dateList.append(obj)
            }
            
        }
    }
    func initDay(){
        defaultDate = getDate(day: dateComponentCurrent.day ?? 0, month: dateComponentCurrent.month ?? 0, year: dateComponentCurrent.year ?? 0)
        let min = minDate.getComponents().year ?? 0
        let max = maxDate.getComponents().year ?? 0
        for y in min...max{
            for m in 1...12{
                var day = 1
                var startMonth = getDate(day: day, month: m, year: y)
                let startNextMonth = getDate(day: 1, month: m + 1, year: y)
                while startMonth < startNextMonth{
                    let obj = DateObject(date: startMonth, isActive: startMonth == defaultDate)
                    dateList.append(obj)
                    day += 1
                    startMonth = Calendar.current.date(byAdding: DateComponents(year: 0, month: 0, day: 1), to: startMonth)!
                }
            }
            
        }
        
    }
    
    func getDate(day : Int, month: Int, year: Int) -> Date{
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        if let temp =  Calendar.current.date(from: components){
            return Calendar.current.date(byAdding: DateComponents(year: 0, month: 0, day: 0, hour: 7), to: temp)!
        }
        else {
            
            return  Calendar.current.date(byAdding: DateComponents(year: 0, month: 0, day: 0, hour: 7), to: Date())!
        }
    }
    func setMaxDate(){
        var components = DateComponents()
        components.hour = 7
        // đối với năm mặc định > 2 năm
        if type == .year{
            components.day = 1
            components.month = 1;
            components.year = (dateComponentCurrent.year ?? 0) + 2
        }
        // đối với tháng mặc định > 2 tháng
        else if type  == .month{
            components.day = 1
            components.month = (dateComponentCurrent.month ?? 0) + 2
            components.year = dateComponentCurrent.year
        }
        // đối với ngày mặc định > 2 tháng
        else if type == .day{
            components.day = dateComponentCurrent.day
            components.month = (dateComponentCurrent.month ?? 0) + 2
            components.year = dateComponentCurrent.year
        }
        // mặc định là đối với tháng > 2 tháng
        else {
            components.day = 1
            components.month = (dateComponentCurrent.month ?? 0) + 2
            components.year = dateComponentCurrent.year
        }
        maxDate = Calendar.current.date(from: components) ?? Date()
    }
    func setMinDate(){
        var components = DateComponents()
        if type == .year{
            components.day = 1
            components.month = 1;
            components.year = 2010
        }
        else if type  == .month{
            components.day = 1
            components.month = 1
            components.year = 2021
        }
        else if type == .day{
            components.day = 1
            components.month = 1
            components.year = 2014
        }
        else {
            components.day = 1
            components.month = 1
            components.year = 2021
        }
        minDate = Calendar.current.date(from: components) ?? Date()
    }
    
    private func selectCellDate() {
        delegate?.selectDateDelegate(date: (dateList.filter({$0.isActive == true}).first ?? DateObject()).date)
        self.CollectionView.reloadData()
        if let idx = dateList.firstIndex(where: {$0.isActive == true}){
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.CollectionView.scrollToItem(at: IndexPath(row: idx, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}
extension DateHorizontal:UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dateList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type{
        case .year:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YearScrollCell", for: indexPath) as! YearScrollCell
            cell.setupData(list: dateList, idx: indexPath.row)
            return cell
        case .month:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthScrollCell", for: indexPath) as! MonthScrollCell
            cell.setupData(list: dateList, idx: indexPath.row)
            return cell
        case .day:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateScrollCell", for: indexPath) as! DateScrollCell
            cell.setupData(list: dateList, idx: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dateList =  dateList.map {itemlet in
            var item = itemlet
            item.isActive = false
            return item
        }
        dateList[indexPath.row].isActive = true;
        selectCellDate()
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
//extension DateHorizontal: UIScrollViewDelegate {
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
////        if scrollView == CollectionView {
////            if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)) {
////                addDate(isNextWeek: true)
////            }
////
////            if (scrollView.contentOffset.x < 0){
////                addDate(isNextWeek: false)
////            }
////        }
//    }
//}
