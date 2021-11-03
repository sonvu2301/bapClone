//
//  MainMarketingViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/24/20.
//

import UIKit
import Charts
import CoreLocation

enum BASmartMainState {
    case checkin, notCheckin, notStart, outOfWork, wait, endOfWork
}

class BASmartMainViewController: BaseSideMenuViewController {

    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var boundChartView: UIView!
    @IBOutlet weak var boundListWarningView: UIView!
    @IBOutlet weak var reopenView: UIView!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var reasonViewBound: UIView!
    @IBOutlet weak var waitingView: UIView!
    
    @IBOutlet weak var customerView: BASmartMainSmallCustomView!
    @IBOutlet weak var problemView: BASmartMainSmallCustomView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var listWarningTableView: UITableView!
    
    @IBOutlet weak var reopenImage: UIImageView!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var KPICheckboxButton: UIButton!
    @IBOutlet weak var KmCheckboxButton: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonCapture: UIButton!
    @IBOutlet weak var buttonCheckin: UIButton!
    @IBOutlet weak var buttonReopen: UIButton!
    @IBOutlet weak var buttonCancelReopen: UIButton!
    @IBOutlet weak var buttonConfirmReopen: UIButton!
    
    @IBOutlet weak var textViewReopen: UITextView!
    @IBOutlet weak var labelChartName: UILabel!
    @IBOutlet weak var labelWait: UILabel!
    
    var data = BASmartData()
    var kpiChartData = [BarChartDataEntry]()
    var kmChartData = [BarChartDataEntry]()
    var averageLine = ChartLimitLine()
    var state: BASmartMainState?
    var isReopen = false
    
    let reasonPlaceholder = "Nhập lý do(*)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkState()
        getData()
        setupDraggableButton()
//        CoreDataBASmart.shared.deleteAllData(entity: "BASmartAttachs")
//        CoreDataBASmart.shared.deleteAllData(entity: "BASmartVehicleImages")
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        scheduleTableView.register(UINib(nibName: "BASmartScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartScheduleTableViewCell")
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.allowsSelection = false
        scheduleTableView.separatorStyle = .none

        listWarningTableView.register(UINib(nibName: "BASmartWarningTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartWarningTableViewCell")
        listWarningTableView.delegate = self
        listWarningTableView.dataSource = self
        listWarningTableView.allowsSelection = false
        listWarningTableView.separatorStyle = .none
        
        scheduleView.setViewCorner(radius: 5)
        boundChartView.setViewCorner(radius: 5)
        boundListWarningView.setViewCorner(radius: 5)
        customerView.setViewCorner(radius: 5)
        problemView.setViewCorner(radius: 5)
        
        customerView.setupView(name: data.customer_data?.title ?? "",
                               timeNumber: String(data.customer_data?.data_count ?? 0),
                               timeNumberName: data.customer_data?.unit_name ?? "",
                               totalNumber: data.customer_data?.quote ?? "")
        problemView.setupView(name: data.working_data?.title ?? "",
                              timeNumber: String(data.working_data?.data_count ?? 0),
                              timeNumberName: data.working_data?.unit_name ?? "",
                              totalNumber: data.working_data?.quote ?? "")
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        listWarningTableView.delegate = self
        listWarningTableView.dataSource = self
        
        loadingIndicator.startAnimating()
        
        buttonReopen.setViewCorner(radius: buttonReopen.frame.height / 2)
        
        reopenView.setViewCorner(radius: 5)
        reasonView.setViewCorner(radius: 5)
        buttonCancelReopen.setViewCorner(radius: 5)
        buttonConfirmReopen.setViewCorner(radius: 5)
        reasonViewBound.setViewCorner(radius: 5)
        reasonViewBound.layer.borderWidth = 1
        reasonViewBound.layer.borderColor = UIColor.black.cgColor
        
        textViewReopen.delegate = self
        textViewReopen.text = reasonPlaceholder
        textViewReopen.textColor = .red

        textViewReopen.selectedTextRange = textViewReopen.textRange(from: textViewReopen.beginningOfDocument, to: textViewReopen.beginningOfDocument)
    }
    
    private func setupChartData() {
        let kpi = data.work_mark?.data_list
        let km = data.work_move?.data_list
        
        let average = data.work_mark?.line_value
        averageLine = ChartLimitLine(limit: Double(average ?? 0))
        averageLine.lineColor = .blue
        
        let kpi_range = kpi?.count ?? 0
        let km_range = km?.count ?? 0
        
        //Setup kpi data entry
        if kpi_range != 0 && km_range != 0 {
            for i in 1...kpi_range {
                let value = kpi?[i-1].value
                kpiChartData.append(BarChartDataEntry(x: Double(i), y: Double(value ?? 0)))
            }
            
            //Setup km data entry
            for i in 1...km_range {
                let value = km?[i-1].value
                kmChartData.append(BarChartDataEntry(x: Double(i), y: Double(value ?? 0)))
            }
        }
        
        //For the first chart
        let set = BarChartDataSet(entries: kpiChartData, label: "Điểm đạt trong ngày")
        set.highlightEnabled = false
        
        
        var legendColor = kpi?.map({UIColor(hexString: $0.color ?? "")})
        legendColor?.removeDuplicates()
        set.colors = legendColor ?? [UIColor]()
        
        
        let legend = LegendEntry(label: "Điểm trung bình (\(String(average ?? 0)))",
                                 form: .line,
                                 formSize: 30,
                                 formLineWidth: 3,
                                 formLineDashPhase: 1,
                                 formLineDashLengths: nil,
                                 formColor: averageLine.lineColor)
        
        chartView.legend.extraEntries = [legend]
        
        let data = BarChartData(dataSet: set)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        data.barWidth = 0.3
        
        chartView.data = data
        chartView.leftAxis.addLimitLine(averageLine)
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.labelCount = 3
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(decimals: 100)
        chartView.doubleTapToZoomEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.xAxis.drawAxisLineEnabled = true
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.rightAxis.enabled = false
        
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisRange = 50
        
        chartView.xAxis.labelHeight = 50
        chartView.xAxis.drawLimitLinesBehindDataEnabled = true
        chartView.xAxis.drawGridLinesBehindDataEnabled = true
        chartView.xAxis.drawLabelsEnabled = true
        chartView.legend.stackSpace = 0
        chartView.autoScaleMinMaxEnabled = false
        chartView.scaleYEnabled = false
        var date = Date().getWeekDate(isNextWeek: false, date: Date())
        for _ in 0..<(6 - kpiChartData.count) {
            date.removeFirst()
        }
        let index = date.map({Date().dateToDayMonth(date: $0)})
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: index)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.setLabelCount(index.count, force: false)
        chartView.xAxis.granularity = 1
    }
    
    private func setupDraggableButton() {
        view.addSubview(buttonStart)
        view.addSubview(buttonCapture)
        view.addSubview(buttonCheckin)
        
        buttonStart.frame = CGRect(x: view.frame.width - 100, y: view.frame.height - 100, width: 80, height: 80)
        buttonCapture.frame = CGRect(x: view.frame.width - 100, y: view.frame.height - 180, width: 80, height: 80)
        buttonCheckin.frame = CGRect(x: view.frame.width - 100, y: view.frame.height - 100, width: 80, height: 80)
        buttonStart.setViewCircle()
        buttonCapture.setViewCircle()
        buttonCheckin.setViewCircle()
        
        let panStart = UIPanGestureRecognizer(target: self, action: #selector(panButtonStart(pan:)))
        let panCapture = UIPanGestureRecognizer(target: self, action: #selector(panButtonCapture(pan:)))
        let panCheckin = UIPanGestureRecognizer(target: self, action: #selector(panButtonCheckin(pan:)))
        buttonStart.addGestureRecognizer(panStart)
        buttonCapture.addGestureRecognizer(panCapture)
        buttonCheckin.addGestureRecognizer(panCheckin)
    }
    
    @objc func panButtonStart(pan: UIPanGestureRecognizer) {
        let location = pan.location(in: view)
        buttonStart.center = location
    }
    
    @objc func panButtonCapture(pan: UIPanGestureRecognizer) {
        let location = pan.location(in: view)
        buttonCapture.center = location
    }
    
    @objc func panButtonCheckin(pan: UIPanGestureRecognizer) {
        let location = pan.location(in: view)
        buttonCheckin.center = location
    }
    
    private func getData() {
        title = "TRANG CHỦ"
        view.showBlurLoader()
        Network.shared.BASmartGetMainProcessHome { [weak self] (data) in
            self?.data = data ?? BASmartData()
            self?.setupView()
            self?.setupChartData()
            self?.scheduleTableView.reloadData()
            self?.listWarningTableView.reloadData()
            self?.view.removeBlurLoader()
        }
        
        getCatalog()
    }
    
    private func checkState() {
        view.showBlurLoader()
        Network.shared.BASmartTimeKeepingCheck { [weak self] (data) in
            SideMenuItems.shared.addSideMenuItems(items: data?.data.menulist ?? [BASmartMenuList]())
            self?.view.removeBlurLoader()
            switch data?.data.state {
            case 0:
                self?.state = .notStart
            case 1:
                self?.state = .notCheckin
            case 2:
                self?.state = .outOfWork
            case 4:
                self?.state = .wait
            case 5:
                self?.state = .checkin
            case 7:
                self?.state = .endOfWork
            default:
                break
            }
            
            self?.timeKeepingState(state: self?.state ?? .wait)
            
            switch self?.state {
            case .notStart, .endOfWork:
                self?.isReopen = data?.data.state == 0 ? false : true
                self?.setupFirstView(isReopen: self?.isReopen ?? false)
            case .wait:
                self?.waitingView.isHidden = false
                self?.labelWait.text = "Đang chờ quản lý duyệt mở lại ngày làm việc"
            case .checkin:
                self?.waitingView.isHidden = false
                self?.labelWait.text = "Đang vào điểm tiếp xúc"
            case .notCheckin:
                self?.waitingView.isHidden = true
            case .outOfWork:
                break
            case .none:
                break
            }
            
        }
    }
    
    private func checkin() {
        getLocationPermission()
        view.showBlurLoader()
        Network.shared.BASmartTimeChecking(state: 1, lat: locValue.latitude, long: locValue.longitude, opt: 0) { [weak self] (data) in
            SideMenuItems.shared.addSideMenuItems(items: data?.menuList ?? [BASmartMenuList]())
            self?.addSideMenu()
            self?.checkState()
            self?.view.removeBlurLoader()
        }
    }
    
    private func setupFirstView(isReopen: Bool) {
        reopenView.isHidden = false
        buttonCheckin.isHidden = true
        buttonStart.isHidden = true
        buttonCapture.isHidden = true
        hideLeftBarButton()
        self.isReopen = isReopen
        if !isReopen {
            reopenImage.image = UIImage(named: "batdau")
        }
        buttonReopen.backgroundColor = UIColor(hexString: "62D994")
        buttonReopen.setTitle("BẮT ĐẦU", for: .normal)
    }
    
    private func timeKeepingState(state: BASmartMainState) {
        
        let imageStart = UIImage(named: "button_radiem")?.resizeImage(targetSize: CGSize(width: 80, height: 80))
        let imageCapture = UIImage(named: "button_chupanh")?.resizeImage(targetSize: CGSize(width: 80, height: 80))
        let imageCheckin = UIImage(named: "button_vaodiem")?.resizeImage(targetSize: CGSize(width: 80, height: 80))
        let imageReopen = UIImage(named: "button_molai")?.resizeImage(targetSize: CGSize(width: 80, height: 80))
        
        buttonCapture.isHidden = true
        buttonStart.isHidden = true
        buttonCheckin.isHidden = true
        
        switch state {
        case .checkin:
            buttonStart.isHidden = false
            buttonCapture.isHidden = false
            buttonStart.setImage(imageStart, for: .normal)
            buttonCapture.setImage(imageCapture, for: .normal)
        case .notCheckin:
            buttonCheckin.isHidden = false
            buttonCheckin.setImage(imageCheckin, for: .normal)
        case .notStart:
            break
        case .outOfWork:
            buttonCheckin.isHidden = false
            buttonCheckin.setImage(imageReopen, for: .normal)
        case .wait:
            break
        case .endOfWork:
            break
        }
    }
    
    @IBAction func KPIButtonTap(_ sender: Any) {
        checkboxChange(isKPI: true)
    }
    
    @IBAction func KPICheckboxButtonTap(_ sender: Any) {
        checkboxChange(isKPI: true)
    }
    
    @IBAction func KMButtonTap(_ sender: Any) {
        checkboxChange(isKPI: false)
    }
    
    @IBAction func KMCheckboxButtonTap(_ sender: Any) {
        checkboxChange(isKPI: false)
    }
    
    @IBAction func buttonCaptureTap(_ sender: Any) {
        showAlertSelectImage()
        isFromBase = true
    }
    
    @IBAction func buttonStartTap(_ sender: Any) {
    
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCheckOutWorkingViewController") ?? UIViewController()) as! BASmartCheckOutWorkingViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.getCatalog()
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonCheckinTap(_ sender: Any) {
        
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartSuggestCheckinViewController") ?? UIViewController()) as! BASmartSuggestCheckinViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 1000)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: view.frame.width, y: (navigationController?.navigationBar.frame.height ?? 44) + 90, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buttonReopenTap(_ sender: Any) {
        //is reopen or start new day
        if isReopen {
            DispatchQueue.main.async { [weak self] in
                self?.reopenView.addSubview(self?.blurView ?? UIView())
                self?.reasonView.isHidden = false
                self?.reopenView.bringSubviewToFront(self?.reasonView ?? UIView())
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: "Chào mừng bạn bắt đầu một ngày làm việc mới", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel, handler: { [weak self] (action) in
                    self?.reopenView.isHidden = true
                    self?.checkin()
                }))
                
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func buttonCancelReopenTap(_ sender: Any) {
        reasonView.isHidden = true
        blurView.removeFromSuperview()
    }
    
    @IBAction func buttonConfirmReopenTap(_ sender: Any) {
        
        let param = BASmartRequestReopenParam(reason: textViewReopen.text, location: BASmartLocationParam(lng: locValue.longitude, lat: locValue.latitude, opt: 1))
        
        Network.shared.BASmartRequestReopen(param: param) { [weak self] (data) in
            if data?.error_code != 0 {
                self?.presentBasicAlert(title: "", message: data?.message ?? "", buttonTittle: "Đồng ý")
            } else {
                let alert = UIAlertController(title: "Thành công", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
                    self?.blurView.removeFromSuperview()
                    self?.reopenView.isHidden = true
                    self?.showLeftBarButton()
                    self?.checkState()
                }))
                
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func checkboxChange(isKPI: Bool) {
        let KPICheckboxImage = isKPI == true ? UIImage(named: "dot_blue") : UIImage(named: "dot_gray")
        let KmCheckboxImage = isKPI == true ? UIImage(named: "dot_gray") : UIImage(named: "dot_blue")
        
        KPICheckboxButton.setImage(KPICheckboxImage, for: .normal)
        KmCheckboxButton.setImage(KmCheckboxImage, for: .normal)
        
        let entries = isKPI == true ? kpiChartData : kmChartData
        let setName = isKPI == true ? data.work_mark?.main_quote ?? "" : data.work_move?.main_quote ?? ""
        let set = BarChartDataSet(entries: entries, label: setName)
        var colors = [UIColor]()
        
        //Set color and average line for chart
        if isKPI {
            chartView.leftAxis.addLimitLine(averageLine)
            let chartData = data.work_mark?.data_list
            colors = chartData?.map({ UIColor(hexString: $0.color ?? "")}) ?? [UIColor]()
            let legend = LegendEntry(label: "Điểm trung bình",
                                     form: .line,
                                     formSize: 30,
                                     formLineWidth: 3,
                                     formLineDashPhase: 1,
                                     formLineDashLengths: nil,
                                     formColor: averageLine.lineColor)
            chartView.legend.extraEntries = [legend]
            labelChartName.text = "HIỆU QUẢ CÔNG VIỆC"
        } else {
            chartView.leftAxis.removeLimitLine(averageLine)
            let chartData = data.work_move?.data_list
            colors = chartData?.map({ UIColor(hexString: $0.color ?? "")}) ?? [UIColor]()
            chartView.legend.extraEntries.removeAll()
            labelChartName.text = "QUÃNG ĐƯỜNG DI CHUYỂN"
        }
        
        colors.removeDuplicates()
        set.highlightEnabled = false
        set.colors = colors
        let data = BarChartData(dataSet: set)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        data.barWidth = 0.3
        chartView.data = data
        chartView.reloadInputViews()
    }
    
}

extension BASmartMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case scheduleTableView:
            return data.schedule_list?.count ?? 0
        case listWarningTableView:
            return data.warning_data?.data_list?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case scheduleTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartScheduleTableViewCell", for: indexPath) as! BASmartScheduleTableViewCell
            let cellData = data.schedule_list?[indexPath.row]
            cell.setupView(start: cellData?.start_time ?? 0,
                           end: cellData?.end_time ?? 0,
                           title: cellData?.title ?? "")
            return cell
            
        case listWarningTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartWarningTableViewCell", for: indexPath) as! BASmartWarningTableViewCell
            let cellData = data.warning_data?.data_list?[indexPath.row]
            cell.setupView(icon: cellData?.icon ?? "",
                           time: cellData?.time ?? 0,
                           content: cellData?.title ?? "")
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case scheduleTableView:
            return 55
        case listWarningTableView:
            return 40
        default:
            return 0
        }
    }
}

extension BASmartMainViewController: ImagePickerFinishDelegate {
    func imagePickerFinish(image: UIImage) {
        let photo = BASmartDailyWorkingPhotolist(image: image.toBase64() ?? "",
                                                 time: Int(Date().timeIntervalSinceReferenceDate))
        var photoList = [BASmartDailyWorkingPhotolist]()
        photoList.append(photo)
        let param = BASmartDailyWorkingParam(photolist: photoList)
        Network.shared.BASmartDailyWorkingPhoto(param: param) { (item) in
            
        }
    }
}

extension BASmartMainViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = reasonPlaceholder
            textView.textColor = .red

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
        else if textView.textColor == .red && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == .red {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

extension BASmartMainViewController: BASmartDoneCreateDelegate {
    func finishCreate() {
        checkState()
    }
}
