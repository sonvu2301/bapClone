//
//  SalaryViewController.swift
//  BAPMobile
//
//  Created by Emcee on 9/13/21.
//

import UIKit

struct YearCell {
    var year: Int
    var isSelect: Bool
    var isSide: Bool
}


class SalaryViewController: BaseViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var yearData = [YearCell]()
    var years = [Int]()
    var data = SalaryModelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "BẢNG TÍNH LƯƠNG THÁNG"
    }
    
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SalaryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "SalaryInfoTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 180
        
        collectionView.register(UINib(nibName: "YearScrollCell", bundle: nil), forCellWithReuseIdentifier: "YearScrollCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addShadow(cornerRadius: 0)
        
        //Input year for collection view
        let startYear = 2010
        let endYear = 2026
        years = Date().getYear(start: startYear, end: endYear)
        years.forEach { [weak self] (year) in
            let item = YearCell(year: year, isSelect: false, isSide: false)
            self?.yearData.append(item)
        }
        
        selectedYear(year: Calendar.current.component(.year, from: Date()))
    }
    
    private func selectedYear(year: Int) {
        //reset data
        for i in 0..<yearData.count {
            yearData[i].isSelect = false
            yearData[i].isSide = false
        }
        
        //set state data
        guard let index = years.firstIndex(of: year) else { return }
        let endOfIndex = years.count - 1
        switch index {
        case 0:
            yearData[index].isSelect = true
            yearData[index + 1].isSide = true
        case endOfIndex:
            yearData[index].isSelect = true
            yearData[index - 1].isSide = true
        default:
            yearData[index].isSelect = true
            yearData[index + 1].isSide = true
            yearData[index - 1].isSide = true
        }
    }
    
    
    private func getData(year: Int) {
        Network.shared.GetSalaryInfo(year: year) { [weak self] (data) in
            self?.data = data?.data ?? SalaryModelData()
            self?.tableView.reloadData()
        }
    }
}

extension SalaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalaryInfoTableViewCell", for: indexPath) as! SalaryInfoTableViewCell
        cell.setupData(data: data.items?[indexPath.row] ?? SalaryModelItem())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SalaryDetailViewController") as! SalaryDetailViewController
        vc.data = data.items?[indexPath.row] ?? SalaryModelItem()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension SalaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        yearData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YearScrollCell", for: indexPath) as! YearScrollCell
        let index = indexPath.row
        cell.setupData(data: yearData[index])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedYear(year: yearData[indexPath.row].year)
        
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
