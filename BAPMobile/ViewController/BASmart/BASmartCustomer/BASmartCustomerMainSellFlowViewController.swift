//
//  BASmartCustomerMainSellFlowViewController.swift
//  BAPMobile
//
//  Created by Emcee on 4/13/21.
//

import UIKit

enum BASmartSellFlow {
    case first, second, third, fourth
}

enum BASmartSellButtonState {
    case selected, unselected, pass
}

enum BASmartComboState {
    case customer, agent
}

protocol CreateOrderDelegate {
    func createOrder()
}

protocol SelectFeatureComboDelegate {
    func selectedFeature(model: Int)
}

class BASmartCustomerMainSellFlowViewController: BaseViewController {

    @IBOutlet weak var buttonFirstFlow: UIButton!
    @IBOutlet weak var buttonSecondFlow: UIButton!
    @IBOutlet weak var buttonThirdFlow: UIButton!
    @IBOutlet weak var buttonFourthFlow: UIButton!
    @IBOutlet weak var buttonSelectComboCustomer: UIButton!
    @IBOutlet weak var buttonSelectComboAgent: UIButton!
    
    @IBOutlet weak var seperateLine: UIView!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var thirdLineView: UIView!
    @IBOutlet weak var selectComboView: UIView!
    @IBOutlet weak var comboCustomerLine: UIView!
    @IBOutlet weak var comboAgentLine: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonClose: UIButton!
    
    var comboList = BASmartComboSaleData()
    var comboDetail = BASmartComboSaleDetailData()
    var comboName = ""
    var comboState = BASmartComboState.customer
    var objectId = 0
    var partner = ""
    var kind = 0
    var isSelectFeature = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        getComboList()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        
        title = "LÊN ĐƠN"
        
        buttonFirstFlow.setViewCircle()
        buttonSecondFlow.setViewCircle()
        buttonThirdFlow.setViewCircle()
        buttonFourthFlow.setViewCircle()
        buttonFirstFlow.layer.borderWidth = 2
        buttonSecondFlow.layer.borderWidth = 2
        buttonThirdFlow.layer.borderWidth = 2
        buttonFourthFlow.layer.borderWidth = 2
        
        selectComboView.layer.borderWidth = 1
        selectComboView.layer.borderColor = UIColor().defaultColor().cgColor
        selectComboView.setViewCorner(radius: 5)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "BASmartSelectComboTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartSelectComboTableViewCell")
         
        
    }
    
    private func setupChildView(detail: BASmartComboSaleDetailData) {
        scrollView.contentSize = CGSize(width: view.frame.width * 4, height: 0)
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        
        let vc1 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerFirstSellFlowViewController") as! BASmartCustomerFirstSellFlowViewController
        let vc2 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerSecondSellFlowViewController") as! BASmartCustomerSecondSellFlowViewController
        let vc3 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerThirdSellFlowViewController") as! BASmartCustomerThirdSellFlowViewController
        let vc4 = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerFourthSellFlowViewController") as! BASmartCustomerFourthSellFlowViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc3.view.frame = CGRect(x: view.frame.width * 2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc4.view.frame = CGRect(x: view.frame.width * 3, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        vc1.data = detail
        vc1.tableData = detail.common?.sorted(by: {($0.order ?? 0) < ($1.order ?? 0)}) ?? [BASmartComboSaleCustomerCommon]()
        vc1.tableOptionData = detail.option ?? [BASmartComboSaleCustomerCommon]()
        vc1.tableData.forEach { (item) in
            vc1.tableOptionData = vc1.tableOptionData.filter({$0.object != item.object})
        }
        vc1.labelNameProduct.text = comboName
        vc1.setNumbers()
        vc1.tableView.reloadData()
        
        vc2.data = detail
        vc2.vtype = detail.vtype ?? [BASmartComboSaleModel]()
        vc2.appendState()
        vc2.selectModelDelegate = self
        
        vc4.delegate = self
        
        self.addChild(vc1)
        self.addChild(vc2)
        self.addChild(vc3)
        self.addChild(vc4)
        scrollView.addSubview(vc1.view)
        scrollView.addSubview(vc2.view)
        scrollView.addSubview(vc3.view)
        scrollView.addSubview(vc4.view)
        
        seperateLine.drawDottedLine(view: seperateLine)
        
        buttonClose.setViewCorner(radius: 5)
        buttonClose.layer.borderWidth = 1
        buttonClose.layer.borderColor = UIColor(hexString: "9A9A9A").cgColor
        
        scrollTo(flow: .first)
    }
    
    
    private func scrollTo(flow: BASmartSellFlow) {
        firstLineView.backgroundColor = UIColor(hexString: "C8C8C8")
        secondLineView.backgroundColor = UIColor(hexString: "C8C8C8")
        thirdLineView.backgroundColor = UIColor(hexString: "C8C8C8")
        
        switch flow {
        case .first:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            flowButtonState(state: .selected, button: buttonFirstFlow)
            flowButtonState(state: .unselected, button: buttonSecondFlow)
            flowButtonState(state: .unselected, button: buttonThirdFlow)
            flowButtonState(state: .unselected, button: buttonFourthFlow)
        case .second:
            scrollView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
            firstLineView.backgroundColor = UIColor().defaultColor()
            flowButtonState(state: .pass, button: buttonFirstFlow)
            flowButtonState(state: .selected, button: buttonSecondFlow)
            flowButtonState(state: .unselected, button: buttonThirdFlow)
            flowButtonState(state: .unselected, button: buttonFourthFlow)
        case .third:
            if isSelectFeature {
                scrollView.setContentOffset(CGPoint(x: view.frame.width * 2, y: 0), animated: true)
                firstLineView.backgroundColor = UIColor().defaultColor()
                secondLineView.backgroundColor = UIColor().defaultColor()
                flowButtonState(state: .pass, button: buttonFirstFlow)
                flowButtonState(state: .pass, button: buttonSecondFlow)
                flowButtonState(state: .selected, button: buttonThirdFlow)
                flowButtonState(state: .unselected, button: buttonFourthFlow)
            } else {
                let defaultContent = view.frame.width
                switch scrollView.contentOffset.x {
                case 0:
                    flowButtonState(state: .selected, button: buttonFirstFlow)
                    flowButtonState(state: .unselected, button: buttonSecondFlow)
                    flowButtonState(state: .unselected, button: buttonThirdFlow)
                    flowButtonState(state: .unselected, button: buttonFourthFlow)
                case defaultContent:
                    firstLineView.backgroundColor = UIColor().defaultColor()
                    flowButtonState(state: .pass, button: buttonFirstFlow)
                    flowButtonState(state: .selected, button: buttonSecondFlow)
                    flowButtonState(state: .unselected, button: buttonThirdFlow)
                    flowButtonState(state: .unselected, button: buttonFourthFlow)
                case 3 * defaultContent:
                    firstLineView.backgroundColor = UIColor().defaultColor()
                    secondLineView.backgroundColor = UIColor().defaultColor()
                    thirdLineView.backgroundColor = UIColor().defaultColor()
                    flowButtonState(state: .pass, button: buttonFirstFlow)
                    flowButtonState(state: .pass, button: buttonSecondFlow)
                    flowButtonState(state: .pass, button: buttonThirdFlow)
                    flowButtonState(state: .selected, button: buttonFourthFlow)
                default:
                    break
                }
                
                presentBasicAlert(title: "Hãy chọn mô hình", message: "", buttonTittle: "Đồng ý")
            }
        case .fourth:
            scrollView.setContentOffset(CGPoint(x: view.frame.width * 3, y: 0), animated: true)
            firstLineView.backgroundColor = UIColor().defaultColor()
            secondLineView.backgroundColor = UIColor().defaultColor()
            thirdLineView.backgroundColor = UIColor().defaultColor()
            flowButtonState(state: .pass, button: buttonFirstFlow)
            flowButtonState(state: .pass, button: buttonSecondFlow)
            flowButtonState(state: .pass, button: buttonThirdFlow)
            flowButtonState(state: .selected, button: buttonFourthFlow)
        }
    }
    
    private func getComboList() {
        Network.shared.BASmartComboSaleList(partner: partner, kind: kind) { [weak self] (data) in
            self?.comboList = data ?? BASmartComboSaleData()
            self?.selectComboView.isHidden = false
            self?.showBlurBackground()
            self?.view.bringSubviewToFront(self?.selectComboView ?? UIView())
            self?.tableView.reloadData()
        }
    }
    
    private func getDetailCombo(combo: Int) {
        Network.shared.BASmartComboSaleDetail(customer: objectId, combo: combo) { [weak self] (data) in
            self?.comboDetail = data ?? BASmartComboSaleDetailData()
            self?.selectComboView.isHidden = true
            self?.hideBlurBackground()
            self?.setupChildView(detail: self?.comboDetail ?? BASmartComboSaleDetailData())
        }
    }
    
    private func flowButtonState(state: BASmartSellButtonState, button: UIButton) {
        switch state {
        case .selected:
            button.backgroundColor = UIColor().defaultColor()
            button.layer.borderColor = UIColor().defaultColor().cgColor
            button.setTitleColor(.white, for: .normal)
        case .unselected:
            button.backgroundColor = UIColor(hexString: "C8C8C8")
            button.layer.borderColor = UIColor(hexString: "C8C8C8").cgColor
            button.setTitleColor(UIColor(hexString: "969696"), for: .normal)
        case .pass:
            button.backgroundColor = UIColor.clear
            button.layer.borderColor = UIColor().defaultColor().cgColor
            button.setTitleColor(UIColor().defaultColor(), for: .normal)
        }
    }
    
    private func selectComboState(state: BASmartComboState) {
        let selectColor = UIColor().defaultColor()
        let deselectColor = UIColor(hexString: "B4B4B4")
        
        switch state {
        case .customer:
            buttonSelectComboCustomer.backgroundColor = .white
            buttonSelectComboCustomer.setTitleColor(selectColor, for: .normal)
            buttonSelectComboAgent.backgroundColor = deselectColor
            buttonSelectComboAgent.setTitleColor(.black, for: .normal)
            comboCustomerLine.backgroundColor = selectColor
            comboAgentLine.backgroundColor = deselectColor
            comboState = .customer
            tableView.reloadData()
        case .agent:
            buttonSelectComboCustomer.backgroundColor = deselectColor
            buttonSelectComboCustomer.setTitleColor(.black, for: .normal)
            buttonSelectComboAgent.backgroundColor = .white
            buttonSelectComboAgent.setTitleColor(selectColor, for: .normal)
            comboCustomerLine.backgroundColor = deselectColor
            comboAgentLine.backgroundColor = selectColor
            comboState = .agent
            tableView.reloadData()
        }
    }
    
    @IBAction func buttonFirstFlowTap(_ sender: Any) {
        scrollTo(flow: .first)
    }
    
    @IBAction func buttonSecondFlowTap(_ sender: Any) {
        scrollTo(flow: .second)
    }
    
    @IBAction func buttonThirdFlowTap(_ sender: Any) {
        scrollTo(flow: .third)
    }
    
    @IBAction func buttonFourthFlowTap(_ sender: Any) {
        scrollTo(flow: .fourth)
    }
    
    @IBAction func buttonSelectComboCustomerTap(_ sender: Any) {
        selectComboState(state: .customer)
        comboState = .customer
    }
    
    @IBAction func buttonSelectComboAgentTap(_ sender: Any) {
        selectComboState(state: .agent)
        comboState = .agent
    }
    
    @IBAction func buttonCloseTap(_ sender: Any) {
        hideBlurBackground()
        selectComboView.isHidden = true
    }
    
}

extension BASmartCustomerMainSellFlowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch comboState {
        case .customer:
            return comboList.common?.count ?? 0
        case .agent:
            return comboList.owner?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartSelectComboTableViewCell", for: indexPath) as! BASmartSelectComboTableViewCell
        var cellData = BASmartComboSaleDataDetail()
        switch comboState {
        case .customer:
            cellData = comboList.common?[indexPath.row] ?? BASmartComboSaleDataDetail()
        case .agent:
            cellData = comboList.owner?[indexPath.row] ?? BASmartComboSaleDataDetail()
        }
        cell.setupData(name: cellData.name ?? "",
                       code: cellData.code ?? "",
                       description: cellData.description ?? "",
                       bcolor: cellData.bcolor ?? "",
                       fcolor: cellData.fcolor ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var comboId = 0
        switch comboState {
        case .customer:
            comboId = comboList.common?[indexPath.row].objectid ?? 0
            comboName = comboList.common?[indexPath.row].name ?? ""
        case .agent:
            comboId = comboList.owner?[indexPath.row].objectid ?? 0
            comboName = comboList.owner?[indexPath.row].name ?? ""
        }
        getDetailCombo(combo: comboId)
    }
}


extension BASmartCustomerMainSellFlowViewController: SelectFeatureComboDelegate {
    func selectedFeature(model: Int) {
        isSelectFeature = true
        let vc = self.children[2] as! BASmartCustomerThirdSellFlowViewController
        vc.getData(model: model)
    }
}

extension BASmartCustomerMainSellFlowViewController: CreateOrderDelegate {
    func createOrder() {
        let vc1 = self.children[0] as! BASmartCustomerFirstSellFlowViewController
        let vc2 = self.children[1] as! BASmartCustomerSecondSellFlowViewController
        let vc3 = self.children[2] as! BASmartCustomerThirdSellFlowViewController
        let vc4 = self.children[3] as! BASmartCustomerFourthSellFlowViewController
        
        let detailOrder = vc1.tableData.map({BASmartDetailOrder(objectid: $0.object,
                                                      norm: $0.norm,
                                                      price: $0.price,
                                                      month: $0.month,
                                                      date: $0.date)})
        
        _ = comboDetail.customer?.tax?.count == 0 ? vc4.textFieldUserId.text : comboDetail.customer?.tax
        
//        let customer = BASmartComboSaleCustomerDetailParam(tax: tax,
//                                                           turcoeff: vc1.count,
//                                                           liqDate: vc4.textFieldExpiredDate.text?.stringToIntDate(),
//                                                           user: vc2.textFieldUser.text,
//                                                           pass: vc2.textFieldPass.text ?? "")
        
        let customer = BASmartComboSaleCustomerDetailParam(channelId: 0,
                                                           tax: "013196213",
                                                           turcoeff: vc1.count,
                                                           liqDate: vc4.textFieldExpiredDate.text?.stringToIntDate(),
                                                           dealerId: 0,
                                                           user: vc2.textFieldUser.text,
                                                           pass: vc2.textFieldPass.text ?? "")
        
        let deploy = "\(vc4.textFieldActTime.text ?? "") \(vc4.textFieldActDate.text ?? "")"
        let location = BASmartLocationParam(
            lng: vc4.location?.first?.coords?.first?.lng ?? 0,
            lat: vc4.location?.first?.coords?.first?.lat ?? 0,
            opt: 0)
        let files = vc4.viewSelectImage.images.map({BASmartImageAttach(imgdata: $0.toBase64())})
        
        let param = BASmartCreateOrderParam(
            customerId: objectId,
            comboId: kind,
            detail: detailOrder,
            vat: vc1.checkboxVAT,
            exchange: Int(vc1.textFieldChange.text ?? "0"),
            systemId: vc2.viewSystem.id,
            modelId: vc2.viewModel.id,
            vType: vc2.vtype.map({BASmartVtype(id: $0.id)}),
            feature: vc3.listFeature.map({BASmartVtype(id: $0)}),
            paymentId: vc4.paymentId.id,
            receiverId: vc4.receiverId,
            deployId: vc4.deployId,
            customer: customer,
            contactName: vc4.textFieldActorNumber.text,
            contactPhone: vc4.textFieldActorNumber.text,
            reportName: vc4.textFieldReporter.text,
            reportPhone: vc4.textFieldReporterNumber.text,
            deployTime: deploy.stringHourToIntDate(),
            address: vc4.labelLocation.text,
            location: location,
            content: vc4.textFieldDescription.text,
            fileAttach: files
        )
        
        self.view.showBlurLoader()
        Network.shared.BASmartCreateOrder(param: param) { [weak self] isDone in
            if isDone {
                
            } else {
                
            }
            self?.view.removeBlurLoader()
        }
    }
}
