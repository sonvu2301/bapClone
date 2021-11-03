//
//  BASmartCustomerInformationApproachTableViewCell.swift
//  BAPMobile
//
//  Created by Emcee on 1/18/21.
//

import UIKit

class BASmartCustomerInformationApproachTableViewCell: UITableViewCell {

    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelOpinion: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var buttonAddress: UIButton!
    
    @IBOutlet weak var viewProject: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewJudge: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewReason: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewSale: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewTime: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewPurpose: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewResult: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewQuantity: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewProcessDate: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewAppointmentDate: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewDepartment: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewSuggestion: BASmartCustomerListDefaultCellView!
    @IBOutlet weak var viewSelectImage: SelectImageView!
    @IBOutlet weak var viewOpinion: UIView!
    
    var data = BASmartCustomerDetailApproachList()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boundView.setViewCorner(radius: 10)
        boundView.layer.borderWidth = 1
        boundView.layer.borderColor = UIColor().defaultColor().cgColor
        
        viewProject.setupView(title: "Dự án",
                              placeholder: "",
                              isNumberOnly: false,
                              content: "",
                              isAllowSelect: false,
                              isPhone: false,
                              isUsingLabel: true)
        viewJudge.setupView(title: "Đánh giá",
                            placeholder: "",
                            isNumberOnly: false,
                            content: "",
                            isAllowSelect: false,
                            isPhone: false,
                            isUsingLabel: true)
        viewReason.setupView(title: "Lý do",
                             placeholder: "",
                             isNumberOnly: false,
                             content: "",
                             isAllowSelect: false,
                             isPhone: false,
                             isUsingLabel: true)
        viewSale.setupView(title: "Chốt sale",
                           placeholder: "",
                           isNumberOnly: false,
                           content: "",
                           isAllowSelect: false,
                           isPhone: false,
                           isUsingLabel: true)
        viewTime.setupView(title: "Thời gian",
                           placeholder: "",
                           isNumberOnly: false,
                           content: "",
                           isAllowSelect: false,
                           isPhone: false,
                           isUsingLabel: true)
        viewPurpose.setupView(title: "Mục đích",
                              placeholder: "",
                              isNumberOnly: false,
                              content: "",
                              isAllowSelect: false,
                              isPhone: false,
                              isUsingLabel: true)
        viewResult.setupView(title: "Kết quả",
                             placeholder: "",
                             isNumberOnly: false,
                             content: "",
                             isAllowSelect: false,
                             isPhone: false,
                             isUsingLabel: true)
        viewQuantity.setupView(title: "Số xe",
                               placeholder: "",
                               isNumberOnly: false,
                               content: "",
                               isAllowSelect: false,
                               isPhone: false,
                               isUsingLabel: true)
        viewProcessDate.setupView(title: "Ngày lắp",
                                  placeholder: "",
                                  isNumberOnly: false,
                                  content: "",
                                  isAllowSelect: false,
                                  isPhone: false,
                                  isUsingLabel: true)
        viewAppointmentDate.setupView(title: "Lịch hẹn",
                                      placeholder: "",
                                      isNumberOnly: false,
                                      content: "",
                                      isAllowSelect: false,
                                      isPhone: false,
                                      isUsingLabel: true)
        viewDepartment.setupView(title: "Bộ phận",
                                 placeholder: "",
                                 isNumberOnly: false,
                                 content: "",
                                 isAllowSelect: false,
                                 isPhone: false,
                                 isUsingLabel: true)
        viewSuggestion.setupView(title: "Đề xuất",
                                 placeholder: "",
                                 isNumberOnly: false,
                                 content: "",
                                 isAllowSelect: false,
                                 isPhone: false,
                                 isUsingLabel: true)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        viewProject.textView.text = ""
        viewJudge.textView.text = ""
        viewSale.textView.text = ""
        viewTime.textView.text = ""
        viewPurpose.textView.text = ""
        viewResult.textView.text = ""
        labelPrice.text = ""
        labelStatus.text = ""
        labelStatus.textColor = UIColor.black
        viewQuantity.textView.text = ""
        viewProcessDate.textView.text = ""
        viewAppointmentDate.textView.text = ""
        viewReason.textView.text = ""
        viewReason.isHidden = true
        viewDepartment.textView.text = ""
        viewSuggestion.textView.text = ""
    }
    
    func setupData(data: BASmartCustomerDetailApproachList) {
        self.data = data
        viewProject.labelContent.text = getListName(list: data.projectList ?? [BASmartDetailInfo]())
        viewJudge.labelContent.text = data.rate?.name
        viewSale.labelContent.text = data.ability?.name
        viewTime.labelContent.text = Date().millisecToHourMinuteWithText(time: data.totalTime ?? 0)
        viewPurpose.labelContent.text = getListName(list: data.purposeList ?? [BASmartDetailInfo]())
        viewResult.labelContent.text = data.result
        labelPrice.text = "\(data.price?.price ?? 0)"
        labelStatus.text = data.price?.style?.name
        labelStatus.textColor = UIColor(hexString: data.price?.style?.color ?? "FFFFFF")
        viewQuantity.labelContent.text = "\(data.vehicleCount ?? 0)"
        if data.expectedTime ?? 0 > 0 {
            viewProcessDate.labelContent.text = Date().millisecToDate(time: data.expectedTime ?? 0)
        }
        if data.nextTime ?? 0 > 0 {
            viewAppointmentDate.labelContent.text = Date().millisecToDate(time: data.nextTime ?? 0)
        }
        if data.reason?.count ?? 0 > 0 {
            viewReason.isHidden = false
            viewReason.labelContent.text = getListName(list: data.reason ?? [BASmartDetailInfo]())
        } else {
            viewReason.isHidden = true
        }
        viewDepartment.labelContent.text = data.department?.name
        viewSuggestion.labelContent.text = data.scheme
        if data.opinion?.count ?? 0 > 0 {
            viewOpinion.isHidden = false
            labelOpinion.attributedText = getListOpinions(list: data.opinion ?? [BASmartCustomerOpinion]())
        } else {
            viewOpinion.isHidden = true
        }
    }
    
    private func getListName(list: [BASmartDetailInfo]) -> String {
        var name = ""
        list.forEach({ (item) in
            name += (item.name ?? "") + ", "
        })
        if name.count > 0 {
            name = String(name.dropLast())
            name = String(name.dropLast())
        }
        
        return name
    }
    
    private func getListOpinions(list: [BASmartCustomerOpinion]) -> NSMutableAttributedString {
        let opinions = NSMutableAttributedString(string:"")
        let boldAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13) ]
        list.forEach { (item) in
            let key = NSMutableAttributedString(string: "\(item.key ?? "")", attributes: boldAttribute )
            opinions.append(key)
            opinions.append(NSMutableAttributedString(string:" \(item.val ?? "")"))
        }
        
        return opinions
    }
}
