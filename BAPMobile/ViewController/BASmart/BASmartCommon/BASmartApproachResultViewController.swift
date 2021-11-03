//
//  BASmartApproachResultViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/25/21.
//

import UIKit
import Kingfisher

class BASmartApproachResultViewController: BaseViewController {

    @IBOutlet weak var viewShowImage: SelectImageView!
    @IBOutlet weak var viewTime: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewHourMinuteTime: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewResult: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewVehicleCount: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewDateInstall: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewModel: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewDateDay: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewJudge: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewSuggest: BASmartCustomerListDefaultCellView!
    
    @IBOutlet weak var purpose1: UIView!
    @IBOutlet weak var purpose2: UIView!
    @IBOutlet weak var purpose3: UIView!
    @IBOutlet weak var purpose4: UIView!
    @IBOutlet weak var purpose5: UIView!
    @IBOutlet weak var purpose6: UIView!
    
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var seperateLine: UIView!
    
    var blurDelegate: BlurViewDelegate?
    var data = BASmartApproachResultData()
    var purposeList = [PlanPurpose]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        title = "KẾT QUẢ TIẾP XÚC KHÁCH HÀNG"
        
        viewTime.setupView(title: "Thời điểm",
                           placeholder: "",
                           isNumberOnly: false,
                           content: Date().millisecToDate(time: data.start ?? 0),
                           isAllowSelect: false,
                           isPhone: false,
                           isUsingLabel: false)
        
        viewHourMinuteTime.setupView(title: "Thời gian",
                                     placeholder: "",
                                     isNumberOnly: false,
                                     content: Date().millisecToHourMinuteWithText(time: data.total ?? 0),
                                     isAllowSelect: false,
                                     isPhone: false,
                                     isUsingLabel: false)
        
        viewResult.setupView(title: "Kết quả",
                             placeholder: "",
                             isNumberOnly: false,
                             content: data.result ?? "",
                             isAllowSelect: false,
                             isPhone: false,
                             isUsingLabel: false)
        
        viewVehicleCount.setupView(title: "Số xe",
                                   placeholder: "",
                                   isNumberOnly: false,
                                   content: String(data.vehicleCount ?? 0),
                                   isAllowSelect: false,
                                   isPhone: false,
                                   isUsingLabel: false)
        
        viewDateInstall.setupView(title: "Ngày lắp",
                                  placeholder: "",
                                  isNumberOnly: false,
                                  content: Date().millisecToDate(time: data.expectedTime ?? 0),
                                  isAllowSelect: false,
                                  isPhone: false,
                                  isUsingLabel: false)
        
        viewModel.setupView(title: "Ph.kiện",
                            placeholder: "",
                            isNumberOnly: false,
                            content: data.transport?.name ?? "",
                            isAllowSelect: false,
                            isPhone: false,
                            isUsingLabel: false)
        
        viewDateDay.setupView(title: "Lịch hẹn",
                              placeholder: "",
                              isNumberOnly: false,
                              content: Date().millisecToDate(time: data.nextTime ?? 0),
                              isAllowSelect: false,
                              isPhone: false,
                              isUsingLabel: false)
        
        viewJudge.setupView(title: "Đánh giá",
                            placeholder: "",
                            isNumberOnly: false,
                            content: data.rate?.name ?? "",
                            isAllowSelect: false,
                            isPhone: false,
                            isUsingLabel: false)
        
        viewSuggest.setupView(title: "Đề xuất",
                              placeholder: "",
                              isNumberOnly: false,
                              content: data.scheme ?? "",
                              isAllowSelect: false,
                              isPhone: false,
                              isUsingLabel: false)
        
        purpose1.isHidden = true
        purpose2.isHidden = true
        purpose3.isHidden = true
        purpose4.isHidden = true
        purpose5.isHidden = true
        purpose6.isHidden = true
        
        data.purpose?.forEach({ [weak self] (item) in
            switch item.id {
            case PlanPurpose.takeCare.id:
                self?.purpose1.isHidden = false
            case PlanPurpose.welcome.id:
                self?.purpose2.isHidden = false
            case PlanPurpose.transport.id:
                self?.purpose3.isHidden = false
            case PlanPurpose.userManual.id:
                self?.purpose4.isHidden = false
            case PlanPurpose.support.id:
                self?.purpose5.isHidden = false
            case PlanPurpose.recoverDebt.id:
                self?.purpose6.isHidden = false
            default:
                break
            }
        })
        
        labelAddress.text = data.address
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "DCDCDC").cgColor
        buttonCancel.setViewCorner(radius: 5)
        
        seperateLine.drawDottedLine(view: seperateLine)
        
        view.setCornerRadiusPopover()
    }
    
    
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        blurDelegate?.hideBlur()
        dismiss(animated: true, completion: nil)
    }
    
}
