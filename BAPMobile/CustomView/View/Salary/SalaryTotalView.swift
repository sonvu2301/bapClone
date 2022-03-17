//
//  SalaryTotalView.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 10/03/2022.
//

import UIKit
import Charts

class SalaryTotalView: UIView {

    @IBOutlet weak var salaryTotalView: UIView!
    
    @IBOutlet weak var viewChartPie: PieChartView!
    
    @IBOutlet weak var totalMoney: SalaryDefaultCustomView!
    @IBOutlet weak var viewTax: SalaryDefaultCustomView!
    @IBOutlet weak var viewReduceSafety: SalaryDefaultCustomView!
    @IBOutlet weak var viewReduceOther: SalaryDefaultCustomView!
    @IBOutlet weak var viewAdvance: SalaryDefaultCustomView!
    
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelMonth: UILabel!
    
    var data = SalaryModelItem()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit(){
        Bundle.main.loadNibNamed("SalaryTotalView", owner: self, options: nil)
        addSubview(salaryTotalView)
        salaryTotalView.frame = self.bounds;
        salaryTotalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        totalMoney.labelName.text = "Tổng thu nhập"
        viewTax.labelName.text = "Thuế TNCN"
        viewReduceSafety.labelName.text = "Đóng bảo hiểm"
        viewReduceOther.labelName.text = "Giảm trừ khác"
        viewAdvance.labelName.text = "Khoản đã ứng"
        
        totalMoney.icon.image = UIImage(named: "ic_rainbow")
        
        viewTax.icon.isHidden = true
        viewReduceSafety.icon.isHidden = true
        viewReduceOther.icon.isHidden = true
        viewAdvance.icon.isHidden = true
        
        viewTax.iconView.backgroundColor = .red
        viewReduceSafety.iconView.backgroundColor = .purple
        viewReduceOther.iconView.backgroundColor = .orange
        viewAdvance.iconView.backgroundColor = .green
        
        // Initialization code
    }
    func setupData(data: SalaryModelItem) {
        self.data = data
        
        //Setup Pie Chart
        let dataChart = PieChartData()
        
        //Entry
        var dataEntries: [PieChartDataEntry] = []
        
        let taxEntry = PieChartDataEntry(value: Double(truncating: NSDecimalNumber(decimal: data.taxEarning ?? 0)),
                                               label: "Thuế TNCN")
        let reduceSafetyEntry = PieChartDataEntry(value: Double(truncating: NSDecimalNumber(decimal: data.reduceSafety ?? 0)),
                                               label: "Đóng bảo hiểm")
        let reduceOtherEntry = PieChartDataEntry(value: Double(truncating: NSDecimalNumber(decimal: data.reduceOther ?? 0)),
                                               label: "Giảm trừ khác")
        let advanceEntry = PieChartDataEntry(value: Double(truncating: NSDecimalNumber(decimal: data.advance ?? 0)),
                                               label: "Khoản đã ứng")
        
        dataEntries.append(taxEntry)
        dataEntries.append(reduceSafetyEntry)
        dataEntries.append(reduceOtherEntry)
        dataEntries.append(advanceEntry)
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        
        //Set Color for chart
        let colors: [NSUIColor] = [.red, .purple, .orange, .green]
        dataSet.colors = colors
        dataSet.drawValuesEnabled = false
        
        dataChart.addDataSet(dataSet)
        
        //viewChartPie.centerText = "\(data.beforeTax ?? 0)M"
        viewChartPie.rotationEnabled = false
        viewChartPie.highlightPerTapEnabled = false
        viewChartPie.legend.enabled = false
        viewChartPie.data = dataChart
        viewChartPie.drawEntryLabelsEnabled = false
        
        //Data for label
        totalMoney.labelContent.text = "\(data.salaryTotal ?? 0) đ"
        viewTax.labelContent.text = "\(data.taxEarning ?? 0) đ"
        viewReduceSafety.labelContent.text = "\(data.reduceSafety ?? 0) đ"
        viewReduceOther.labelContent.text = "\(data.reduceOther ?? 0) đ"
        viewAdvance.labelContent.text = "\(data.advance ?? 0) đ"
        
        var totalMoney = (data.salaryTotal ?? 0) - (data.taxEarning ?? 0)
        totalMoney = totalMoney - (data.reduceSafety ?? 0) - (data.reduceOther ?? 0)
        totalMoney = totalMoney - (data.advance ?? 0)
        
        labelTotal.text = "\(totalMoney)"
        let m = Date().toDate(monthIndex: data.month ?? 0).getComponents().month ?? 0
        labelMonth.text = "Tháng \(m)"
    }
    func prepareForReuse(){
        totalMoney.labelName.text = "Tổng thu nhập"
        viewTax.labelName.text = "Thuế TNCN"
        viewReduceSafety.labelName.text = "Đóng bảo hiểm"
        viewReduceOther.labelName.text = "Giảm trừ khác"
        viewAdvance.labelName.text = "Khoản đã ứng"
        
        totalMoney.labelContent.text = ""
        viewTax.labelContent.text = ""
        viewReduceSafety.labelContent.text = ""
        viewReduceOther.labelContent.text = ""
        viewAdvance.labelContent.text = ""
        
        totalMoney.icon.image = UIImage(named: "ic_rainbow")
        viewTax.icon.isHidden = true
        viewTax.iconView.backgroundColor = .red
        viewReduceSafety.icon.isHidden = true
        viewReduceSafety.iconView.backgroundColor = .purple
        viewReduceOther.icon.isHidden = true
        viewReduceOther.iconView.backgroundColor = .orange
        viewAdvance.icon.isHidden = true
        viewAdvance.iconView.backgroundColor = .green
        
        labelTotal.text = ""
        labelMonth.text = ""
    }

}
