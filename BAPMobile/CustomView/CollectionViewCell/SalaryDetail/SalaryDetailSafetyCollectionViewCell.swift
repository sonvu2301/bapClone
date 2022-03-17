//
//  SalaryDetailSafetyCollectionViewCell.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 09/03/2022.
//

import UIKit
import Charts

class SalaryDetailSafetyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taxDetailTable: UITableView!
    @IBOutlet weak var taxPiechartView: PieChartView!
    var data = SalaryDetailSafety()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        // Initialization code
        taxDetailTable.dataSource = self
        taxDetailTable.delegate = self
        taxDetailTable.register(UINib(nibName: "SalaryDetailCellLabel", bundle: nil), forCellReuseIdentifier: "SalaryDetailCellLabel")
    }
    
    override func prepareForReuse() {
    }
    func setupView(data: SalaryDetailSafety){
        self.data = data
        let dataChart = PieChartData()
        var dataEntries: [PieChartDataEntry] = []
        data.items?.forEach {(item) in
            if(item.id ?? 0 > 0){
                let obj = PieChartDataEntry(value: Double(truncating: NSDecimalNumber(decimal: item.value ?? 0)), label: item.label)
                dataEntries.append(obj)
            }
        }
        let dataSet = PieChartDataSet(entries: dataEntries, label: "Pie charts")
        dataSet.entryLabelColor = .black
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.red, .purple, .orange, .green]
        dataSet.sliceSpace = 6
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.3
        dataSet.valueLinePart2Length = 0.6
        dataSet.xValuePosition = .outsideSlice
        
        dataChart.addDataSet(dataSet)
        
        taxPiechartView.drawEntryLabelsEnabled = true
        taxPiechartView.legend.enabled = false
        taxPiechartView.drawHoleEnabled = false
        taxPiechartView.setExtraOffsets(left: 40, top: 20, right: 40, bottom: 20)
        
        taxPiechartView.data = dataChart
        taxDetailTable.reloadData()
    }
}
extension SalaryDetailSafetyCollectionViewCell:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taxDetailTable.dequeueReusableCell(withIdentifier: "SalaryDetailCellLabel", for: indexPath) as! SalaryDetailCellLabel
        cell.setupView(item: data.items?[indexPath.row] ?? SalaryDetailSaftyItems())
        return cell
    }
}
