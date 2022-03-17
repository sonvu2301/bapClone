//
//  SalaryDetailViewController.swift
//  BAPMobile
//
//  Created by Emcee on 10/1/21.
//

import UIKit
import Charts

class SalaryDetailViewController: BaseViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var viewBeforeTax: SalaryDefaultCustomView!
    @IBOutlet weak var viewTax: SalaryDefaultCustomView!
    @IBOutlet weak var viewReduceSafety: SalaryDefaultCustomView!
    @IBOutlet weak var viewReduceOther: SalaryDefaultCustomView!
    @IBOutlet weak var viewAdvance: SalaryDefaultCustomView!
    
    // MARK: view xử lý bottom bar
    @IBOutlet weak var keepingView: UIView!
    @IBOutlet weak var keepingIcon: UIImageView!
    @IBOutlet weak var keepingLabel: UILabel!
    
    
    @IBOutlet weak var totalMoneyView: UIView!
    @IBOutlet weak var totalMoneyIcon: UIImageView!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    
    @IBOutlet weak var taxView: UIView!
    @IBOutlet weak var TaxIcon: UIImageView!
    @IBOutlet weak var TaxLabel: UILabel!
    
    
    @IBOutlet weak var safetyView: UIView!
    @IBOutlet weak var satefyIcon: UIImageView!
    @IBOutlet weak var satefyLabel: UILabel!
    
    
    @IBOutlet weak var reduceView: UIView!
    @IBOutlet weak var reduceIcon: UIImageView!
    @IBOutlet weak var reduceLabel: UILabel!
    //======================================
    
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    
    @IBOutlet weak var detailSalaryCollection: UICollectionView!
    @IBOutlet weak var salaryTotalView: SalaryTotalView!
    
    
    var data = SalaryModelItem()
    var dataDetail = SalaryDetailData()
    
    
    override func viewDidLoad() {
        
        let date = Date().toDate(monthIndex: data.month ?? 0)
        title = "Tháng " + date.toDateFormat(format: "M - yyyy")
        
        super.viewDidLoad()
        setupView()
        addEventBottomBar()
        setRenderAllwayImage()
        resetBarBottom()
        activeDefaultBottom()
        getData()
        
        // Do any additional setup after loading the view.
    } 
    
    private func setupView() {
        salaryTotalView.setupData(data: data)
        //Setup scroll view
        
        detailSalaryCollection.delegate = self
        detailSalaryCollection.dataSource = self
        detailSalaryCollection.register(UINib(nibName: "SalaryDetailKeepingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SalaryDetailKeepingCollectionViewCell")
        detailSalaryCollection.register(UINib(nibName: "SalaryDetailTotalMoneyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SalaryDetailTotalMoneyCollectionViewCell")
        detailSalaryCollection.register(UINib(nibName: "SalaryDetailTaxCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SalaryDetailTaxCollectionViewCell")
        detailSalaryCollection.register(UINib(nibName: "SalaryDetailSafetyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SalaryDetailSafetyCollectionViewCell")
        detailSalaryCollection.register(UINib(nibName: "SalaryDetailReduceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SalaryDetailReduceCollectionViewCell")
    }
    private func getData(){
        Network.shared.GetSalaryDetail(id: self.data.id ?? 0, completion: {[weak self] (data) in
            self?.dataDetail = data?.data ?? SalaryDetailData()
            self?.detailSalaryCollection.reloadData()
            
        })
    }
}
extension SalaryDetailViewController: UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout,
                                      UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalaryDetailKeepingCollectionViewCell", for: indexPath) as! SalaryDetailKeepingCollectionViewCell
            cell.setupView(list: self.dataDetail.timeKeeping ?? [SalaryDefaultData()])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalaryDetailTotalMoneyCollectionViewCell", for: indexPath) as! SalaryDetailTotalMoneyCollectionViewCell
            cell.setupView(list: self.dataDetail.earnIncome ?? [SalaryDefaultData()])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalaryDetailTaxCollectionViewCell", for: indexPath) as! SalaryDetailTaxCollectionViewCell
            cell.setupView(item: dataDetail.taxEarning ?? SalaryDetailTax())
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalaryDetailSafetyCollectionViewCell", for: indexPath) as! SalaryDetailSafetyCollectionViewCell
            cell.setupView(data: self.dataDetail.safety ?? SalaryDetailSafety())
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalaryDetailReduceCollectionViewCell", for: indexPath) as! SalaryDetailReduceCollectionViewCell
            cell.setupView(list: dataDetail.reduce ?? [SalaryDefaultData()])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalaryDetailKeepingCollectionViewCell", for: indexPath) as! SalaryDetailKeepingCollectionViewCell
            cell.setupView(list: self.dataDetail.timeKeeping ?? [SalaryDefaultData()])
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        activeBarBottom(page: scrollView.currentPage)
    }
}
// MARK: xử lý view tabar bottom
extension SalaryDetailViewController{
    @objc func activeKeepingView(){
        resetBarBottom()
        activeDefaultBottom()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.detailSalaryCollection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    @objc func activeTotalMoneyView(){
        resetBarBottom()
        activeTotalmoney()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.detailSalaryCollection.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func activeTaxView(){
        resetBarBottom()
        activeTax()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.detailSalaryCollection.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func activeSatefyView(){
        resetBarBottom()
        activeSatefy()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.detailSalaryCollection.scrollToItem(at: IndexPath(row: 3, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    @objc func activeReduceView(){
        resetBarBottom()
        activeReduce()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.detailSalaryCollection.scrollToItem(at: IndexPath(row: 4, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func addEventBottomBar(){
        keepingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activeKeepingView)))
        totalMoneyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activeTotalMoneyView)))
        taxView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activeTaxView)))
        safetyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activeSatefyView)))
        reduceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(activeReduceView)))
        
    }
    func activeBarBottom(page: Int){
        resetBarBottom()
        switch page{
        case 1:
            activeDefaultBottom()
        case 2:
            activeTotalmoney()
        case 3:
            activeTax()

        case 4:
            activeSatefy()

        case 5:
            activeReduce()
        default:
            activeDefaultBottom()
        }
    }
    func resetBarBottom(){
        keepingIcon.tintColor = .gray
        keepingLabel.textColor = .gray
        
        totalMoneyIcon.tintColor = .gray
        totalMoneyLabel.textColor = .gray
        
        TaxIcon.tintColor = .gray
        TaxLabel.textColor = .gray
        
        satefyIcon.tintColor = .gray
        satefyLabel.textColor = .gray
        
        reduceIcon.tintColor = .gray
        reduceLabel.textColor = .gray
    }
    func activeDefaultBottom(){
        keepingIcon.tintColor = UIColor(hexString: "#26A0D8")
        keepingLabel.textColor = UIColor(hexString: "#26A0D8")
    }
    func activeTotalmoney(){
        totalMoneyIcon.tintColor = UIColor(hexString: "#26A0D8")
        totalMoneyLabel.textColor = UIColor(hexString: "#26A0D8")
    }
    func activeTax(){
        TaxIcon.tintColor = UIColor(hexString: "#26A0D8")
        TaxLabel.textColor = UIColor(hexString: "#26A0D8")
    }
    func activeSatefy(){
        satefyIcon.tintColor = UIColor(hexString: "#26A0D8")
        satefyLabel.textColor = UIColor(hexString: "#26A0D8")
    }
    func activeReduce(){
        reduceIcon.tintColor = UIColor(hexString: "#26A0D8")
        reduceLabel.textColor = UIColor(hexString: "#26A0D8")
    }
    
    func setRenderAllwayImage(){
        keepingIcon.image = keepingIcon.image?.withRenderingMode(.alwaysTemplate)
        totalMoneyIcon.image = totalMoneyIcon.image?.withRenderingMode(.alwaysTemplate)
        TaxIcon.image = TaxIcon.image?.withRenderingMode(.alwaysTemplate)
        satefyIcon.image = satefyIcon.image?.withRenderingMode(.alwaysTemplate)
        reduceIcon.image = reduceIcon.image?.withRenderingMode(.alwaysTemplate)
    }
}

