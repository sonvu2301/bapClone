//
//  SalaryInfoTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 9/16/21.
//

import UIKit
import Charts

enum SalaryLabelName {
    case beforeTax, tax, reduceSafety, reduceOther, advance
    
    var name: String {
        switch self {
        case .beforeTax:
            return "Tổng thu nhập"
        case .tax:
            return "Thuế TNCN"
        case .reduceSafety:
            return "Đóng bảo hiểm"
        case .reduceOther:
            return "Giảm trừ khác"
        case .advance:
            return "Khoản đã ứng"
        }
    }
}

class SalaryInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boundView: UIView!
    
    @IBOutlet weak var viewChartPie: PieChartView!
    
    @IBOutlet weak var viewBeforeTax: SalaryDefaultCustomView!
    @IBOutlet weak var viewTax: SalaryDefaultCustomView!
    @IBOutlet weak var viewReduceSafety: SalaryDefaultCustomView!
    @IBOutlet weak var viewReduceOther: SalaryDefaultCustomView!
    @IBOutlet weak var viewAdvance: SalaryDefaultCustomView!
    
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelMonth: UILabel!
    
    var data = SalaryModelItem()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBeforeTax.labelName.text = "Tổng thu nhập"
        viewTax.labelName.text = "Thuế TNCN"
        viewReduceSafety.labelName.text = "Đóng bảo hiểm"
        viewReduceOther.labelName.text = "Giảm trừ khác"
        viewAdvance.labelName.text = "Khoản đã ứng"
        
        viewBeforeTax.icon.image = UIImage(named: "ic_rainbow")
        
        viewTax.icon.isHidden = true
        viewReduceSafety.icon.isHidden = true
        viewReduceOther.icon.isHidden = true
        viewAdvance.icon.isHidden = true
        
        viewTax.iconView.backgroundColor = .red
        viewReduceSafety.iconView.backgroundColor = .purple
        viewReduceOther.iconView.backgroundColor = .orange
        viewAdvance.iconView.backgroundColor = .green
        
        boundView.addShadow(cornerRadius: 10)
        // Initialization code
    }
    
    override func prepareForReuse() {
        viewBeforeTax.labelName.text = "Tổng thu nhập"
        viewTax.labelName.text = "Thuế TNCN"
        viewReduceSafety.labelName.text = "Đóng bảo hiểm"
        viewReduceOther.labelName.text = "Giảm trừ khác"
        viewAdvance.labelName.text = "Khoản đã ứng"
        
        viewBeforeTax.labelContent.text = ""
        viewTax.labelContent.text = ""
        viewReduceSafety.labelContent.text = ""
        viewReduceOther.labelContent.text = ""
        viewAdvance.labelContent.text = ""
        
        viewBeforeTax.icon.image = UIImage(named: "ic_rainbow")
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(data: SalaryModelItem) {
        self.data = data
        
        //Setup Pie Chart
        let dataChart = PieChartData()
        
        //Entry
        var dataEntries: [PieChartDataEntry] = []
        
        let taxEntry = PieChartDataEntry(value: Double(data.taxEarning ?? 0),
                                               label: SalaryLabelName.tax.name)
        let reduceSafetyEntry = PieChartDataEntry(value: Double(data.reduceSafety ?? 0),
                                               label: SalaryLabelName.reduceSafety.name)
        let reduceOtherEntry = PieChartDataEntry(value: Double(data.reduceOther ?? 0),
                                               label: SalaryLabelName.reduceOther.name)
        let advanceEntry = PieChartDataEntry(value: Double(data.advance ?? 0),
                                               label: SalaryLabelName.advance.name)
        
        dataEntries.append(taxEntry)
        dataEntries.append(reduceSafetyEntry)
        dataEntries.append(reduceOtherEntry)
        dataEntries.append(advanceEntry)
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        
        //Set Color for chart
        let colors: [NSUIColor] = [.red, .purple, .orange, .green]
        dataSet.colors = colors
        
        dataChart.addDataSet(dataSet)
        
        viewChartPie.centerText = "\(data.beforeTax ?? 0)M"
        viewChartPie.rotationEnabled = false
        viewChartPie.highlightPerTapEnabled = false
        
        viewChartPie.data = dataChart
        
        //Data for label
        viewBeforeTax.labelContent.text = "\(data.beforeTax ?? 0) đ"
        viewTax.labelContent.text = "\(data.taxEarning ?? 0) đ"
        viewReduceSafety.labelContent.text = "\(data.reduceSafety ?? 0) đ"
        viewReduceOther.labelContent.text = "\(data.reduceOther ?? 0) đ"
        viewAdvance.labelContent.text = "\(data.advance ?? 0) đ"
        
        var sum = (data.beforeTax ?? 0) - (data.taxEarning ?? 0) - (data.reduceOther ?? 0)
        sum -= ((data.reduceOther ?? 0) + (data.advance ?? 0))
        
        labelTotal.text = "\(sum)"
        labelMonth.text = "Tháng \(data.month ?? 0)"
    }
    
}
