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
    
    @IBOutlet weak var viewWorkDay: UIView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewTaxTab: UIView!
    @IBOutlet weak var viewWarranty: UIView!
    @IBOutlet weak var viewReduce: UIView!
    
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var data = SalaryModelItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        
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
        
        pieChartView.centerText = "\(data.beforeTax ?? 0)M"
        pieChartView.rotationEnabled = false
        pieChartView.highlightPerTapEnabled = false
        
        pieChartView.data = dataChart
        
        //Setup scroll view
        
        
    }

}
