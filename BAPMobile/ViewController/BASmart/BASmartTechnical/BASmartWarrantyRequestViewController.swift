//
//  BASmartWarrantyRequestViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/22/21.
//

import UIKit
import DropDown

enum WarrantyState {
    case car, note, attach
}

protocol ReloadDataDelegate {
    func reload()
}

protocol LoadingDelegate {
    func showLoading()
}

protocol BlurBackgroundDelegate {
    func blurBackgroundAction(isShow: Bool)
}

enum SavedType {
    case request, car
    
    var name: String {
        switch self {
        case .request:
            return "Yêu cầu bảo hành "
        case .car:
            return "Hình ảnh xe "
        }
    }
}

class BASmartWarrantyRequestViewController: BaseViewController {

    @IBOutlet weak var viewCarList: UIView!
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var viewAttach: UIView!
    @IBOutlet weak var viewMoneyState: UIView!
    
    @IBOutlet weak var labelPartnerName: UILabel!
    @IBOutlet weak var labelPartnerCode: UILabel!
    @IBOutlet weak var labelXNCode: UILabel!
    @IBOutlet weak var labelCustomerName: UILabel!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelEmployeeName: UILabel!
    
    @IBOutlet weak var buttonXNPhone: UIButton!
    @IBOutlet weak var buttonContactPhone: UIButton!
    @IBOutlet weak var buttonEmployeePhone: UIButton!
    
    @IBOutlet weak var buttonCarList: UIButton!
    @IBOutlet weak var buttonNote: UIButton!
    @IBOutlet weak var buttonAttach: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonMoneyState: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var state = WarrantyState.car
    var basicData = BASmartTechnicalData()
    var data = BASmartTechnicalDetailTaskData()
    let dropDown = DropDown()
    var mstate = 0
    var reloadDelegate: ReloadDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollViewState(state: .car)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let yourBackImage = UIImage(named: "ic_back")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem?.title = " "
    
        title = "YÊU CẦU BẢO HÀNH"
    }
    
    private func setupView() {
        
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: 0)
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        
        let vc1 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartWarrantyCarListViewController") as! BASmartWarrantyCarListViewController
        let vc2 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartWarrantyNoteViewController") as! BASmartWarrantyNoteViewController
        let vc3 = UIStoryboard(name: "BASmartWarranty", bundle: nil).instantiateViewController(withIdentifier: "BASmartWarrantyAttachViewController") as! BASmartWarrantyAttachViewController
        
        vc1.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc2.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        vc3.view.frame = CGRect(x: view.frame.width * 2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        vc1.data = data.vehicle ?? [BASmartVehicle]()
        vc1.basicData = basicData
        vc2.data = data.memo ?? [BASmartMemo]()
        vc3.data = data.file ?? [BASmartFileAttach]()
        vc3.task = basicData.task ?? BASmartTaskData()
        
        vc1.setupView()
        vc2.setupView()
        vc3.setupView()
        
        vc1.id = basicData.task?.id ?? 0
        
        vc3.finishDelegate = self
        vc3.loadingDelegate = self
        vc3.blurBackground = self
        let name = "\(SavedType.request.name) (\(basicData.partner?.code ?? "")-\(basicData.task?.taskNumber ?? ""))"
        vc3.name = name
        vc3.getSavedAttachs(name: name)
        
        self.addChild(vc1)
        self.addChild(vc2)
        self.addChild(vc3)
        scrollView.addSubview(vc1.view)
        scrollView.addSubview(vc2.view)
        scrollView.addSubview(vc3.view)
        scrollView.isPagingEnabled = true
        
        buttonCarList.setImage(UIImage(named: "icon_vehicle")?.resizeImage(targetSize: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), for: .normal)
        buttonNote.setImage(UIImage(named: "edit")?.resizeImage(targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
        buttonAttach.setImage(UIImage(named: "attachment")?.resizeImage(targetSize: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), for: .normal)
        
        labelPartnerCode.text = basicData.task?.taskNumber
        labelPartnerName.text = basicData.partner?.code
        labelXNCode.text = basicData.customer?.xncode
        labelCustomerName.text = basicData.customer?.name
        labelContact.text = basicData.contact?.name
        labelTime.text = Date().millisecToDateHour(time: basicData.implement ?? 0)
        labelAddress.text = basicData.address
        labelEmployeeName.text = basicData.seller?.name
        
        let phoneImage = UIImage(named: "ic_tel_01")?.resizeImage(targetSize: CGSize(width: 18, height: 18)).withRenderingMode(.alwaysTemplate)
        
        buttonXNPhone.setImage(phoneImage, for: .normal)
        buttonContactPhone.setImage(phoneImage, for: .normal)
        buttonEmployeePhone.setImage(phoneImage, for: .normal)
        
        buttonXNPhone.tintColor = UIColor().defaultColor()
        buttonContactPhone.tintColor = UIColor().defaultColor()
        buttonEmployeePhone.tintColor = UIColor().defaultColor()
        
        buttonXNPhone.setTitle(" \(basicData.customer?.phone ?? "")", for: .normal)
        buttonContactPhone.setTitle(" \(basicData.contact?.mobile ?? "")", for: .normal)
        buttonEmployeePhone.setTitle(" \(basicData.seller?.mobile ?? "")", for: .normal)
        
        buttonConfirm.setViewCorner(radius: 5)
        viewMoneyState.layer.borderWidth = 1
        viewMoneyState.layer.borderColor = UIColor.lightGray.cgColor
        viewMoneyState.setViewCorner(radius: 5)
        
        if (data.mstate?.count ?? 0) < 1 {
            viewMoneyState.isHidden = true
        } else {
            dropDown.anchorView = viewMoneyState
            dropDown.width = viewMoneyState.frame.width - 30
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.dataSource = data.mstate?.map({$0.name ?? ""}) ?? [String]()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ic_add")?.resizeImage(targetSize: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(addButtonAction))
    }
    
    private func scrollViewState(state: WarrantyState) {
        
        self.state = state
        
        buttonCarList.tintColor = .lightGray
        buttonNote.tintColor = .lightGray
        buttonAttach.tintColor = .lightGray
        
        buttonCarList.setTitleColor(.lightGray, for: .normal)
        buttonNote.setTitleColor(.lightGray, for: .normal)
        buttonAttach.setTitleColor(.lightGray, for: .normal)
        
        viewCarList.backgroundColor = UIColor(hexString: "DCDCDC")
        viewNote.backgroundColor = UIColor(hexString: "DCDCDC")
        viewAttach.backgroundColor = UIColor(hexString: "DCDCDC")
        
        switch state {
        case .car:
            buttonCarList.tintColor = .white
            buttonCarList.setTitleColor(.white, for: .normal)
            viewCarList.backgroundColor = UIColor().defaultColor()
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case .note:
            buttonNote.tintColor = .white
            buttonNote.setTitleColor(.white, for: .normal)
            viewNote.backgroundColor = UIColor().defaultColor()
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width, y: 0), animated: true)
        case .attach:
            buttonAttach.tintColor = .white
            buttonAttach.setTitleColor(.white, for: .normal)
            viewAttach.backgroundColor = UIColor().defaultColor()
            scrollView.setContentOffset(CGPoint(x: 2 * scrollView.bounds.size.width, y: 0), animated: true)
        }
        
        
    }
    
    func getData(id: Int) {
        self.view.showBlurLoader()
        
        let location = getCurrentLocation()
        let locationParam = BASmartLocationParam(lng: location.lng,
                                                 lat: location.lat,
                                                 opt: 0)
        
        let param = BASmartTechnicalDetailTaskParam(taskid: id,
                                                    location: locationParam)
        
        Network.shared.BASmartTechnicalTaskDetail(param: param) { [weak self] (data) in
            self?.data = data?.data ?? BASmartTechnicalDetailTaskData()
            self?.setupView()
            self?.view.removeBlurLoader()
        }
    }
    
    private func technicalTaskTransfer() {
        
        let location = getCurrentLocationParam()
        var param = BASmartTechnicalTransferParam()
        if (data.mstate?.count ?? 0) > 0 {
            param = BASmartTechnicalTransferParam(task: basicData.task?.id ?? 0,
                                                  state: mstate,
                                                  location: location)
        } else {
            param = BASmartTechnicalTransferParam(task: basicData.task?.id ?? 0,
                                                  location: location)
        }
        Network.shared.BASmartTechnicalTransfer(param: param) { [weak self] (data) in
            self?.reloadDelegate?.reload()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addButtonAction() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartWarrantySearchVehicleViewController") ?? UIViewController()) as! BASmartWarrantySearchVehicleViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.id = basicData.task?.id ?? 0
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }

    @IBAction func buttonXNPhoneTap(_ sender: Any) {
        if let url = URL(string: "tel://\(basicData.customer?.phone ?? "")"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func buttonContactPhoneTap(_ sender: Any) {
        if let url = URL(string: "tel://\(basicData.contact?.mobile ?? "")"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func buttonEmployeePhoneTap(_ sender: Any) {
        if let url = URL(string: "tel://\(basicData.seller?.mobile ?? "")"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func buttonCarListTap(_ sender: Any) {
        scrollViewState(state: .car)
    }
    
    @IBAction func buttonNoteTap(_ sender: Any) {
        scrollViewState(state: .note)
    }
    
    @IBAction func buttonAttachTap(_ sender: Any) {
        scrollViewState(state: .attach)
    }
    
    @IBAction func buttonMoneyStateTap(_ sender: Any) {
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.buttonMoneyState.setTitle(item, for: .normal)
            self?.buttonMoneyState.setTitleColor(.black, for: .normal)
            self?.mstate = self?.data.mstate?[index].id ?? 0
        }
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        
        let alert = UIAlertController(title: "XÁC NHẬN", message: "Bạn có chắc chắn muốn hoàn thành đơn yêu cầu bảo hành này không?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "BỎ QUA", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "XÁC NHẬN", style: .default, handler: { [weak self] (action) in
            self?.technicalTaskTransfer()
        }))
        if (data.mstate?.count ?? 0) > 0 {
            if mstate == 0 {
                presentBasicAlert(title: "Lựa chọn trạng thái thu tiền", message: "", buttonTittle: "Đồng ý")
            } else {
                present(alert, animated: true, completion: nil)
            }
        } else {
            present(alert, animated: true, completion: nil)
        }
        
    }
    
}

extension BASmartWarrantyRequestViewController: BASmartDoneCreateDelegate {
    func finishCreate() {
        let vc = self.children[0] as! BASmartWarrantyCarListViewController
        vc.getData()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension BASmartWarrantyRequestViewController: ReloadDataDelegate {
    func reload() {
        getData(id: basicData.task?.id ?? 0)
        view.removeBlurLoader()
    }
}

extension BASmartWarrantyRequestViewController: LoadingDelegate {
    func showLoading() {
        view.showBlurLoader()
    }
}

extension BASmartWarrantyRequestViewController: BlurBackgroundDelegate {
    func blurBackgroundAction(isShow: Bool) {
        if isShow {
            showBlurBackground()
        } else {
            hideBlurBackground()
        }
    }
}

extension BASmartWarrantyRequestViewController: UIScrollViewDelegate {
    
}
