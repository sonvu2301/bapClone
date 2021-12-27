//
//  BASmartCustomerInformationDetailViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/12/21.
//

import UIKit

enum BASMartCustomerInformationDetailCellType {
    case customerCode, customerKind, customerType, name, phone, contact, address, source, model, scale, foundation, email, facebook, website, decription
    
    var title: String {
        switch self {
        case .customerCode:
            return "Mã KH"
        case .customerKind:
            return "Nhóm KH"
        case .customerType:
            return "Loại KH"
        case .name:
            return "Tên KH"
        case .phone:
            return "SĐT"
        case .contact:
            return "Liên hệ"
        case .address:
            return "Địa chỉ"
        case .source:
            return "Nguồn KH"
        case .model:
            return "Mô hình"
        case .scale:
            return "Quy mô"
        case .foundation:
            return "Thành lập"
        case .email:
            return "Email"
        case .facebook:
            return "Facebook"
        case .website:
            return "Website"
        case .decription:
            return "Thông tin ghi chú khách hàng"
        }
    }
}


class BASmartCustomerInformationDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonUpdate: UIButton!
    
    var data = BASmartCustomerDetailGeneral()
    var cellType = [BASMartCustomerInformationDetailCellType]()
    var objectId = 0
    var phoneKindId = 0
    var delegate: BackToPreviousVCDelegate?
    var updateDelegate: BASmartDoneUpdateDelegate?
    var menuAction = [BASmartDetailMenuDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartCustomerDetailDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerDetailDefaultTableViewCell")
        tableView.register(UINib(nibName: "BASmartCustomerListPhoneTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerListPhoneTableViewCell")
        tableView.register(UINib(nibName: "BASmartCustomerListDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerListDescriptionTableViewCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        cellType.append(contentsOf: [.customerCode, .customerKind, .customerType, .name, .phone, .contact, .address, .source, .model, .scale, .foundation, .email, .facebook, .website, .decription])
        
        buttonDelete.setViewCorner(radius: 5)
        buttonUpdate.setViewCorner(radius: 5)
        
        footerView.isHidden = true
        if menuAction.filter({$0.id == BASmartMenuAction.edit.id || $0.id == BASmartMenuAction.delete.id}).count > 0 {
            footerView.isHidden = false
        }
    }
    
    private func deleteCustomer() {
        Network.shared.BASmartDeleteCustomer(objectId: objectId) { [weak self] (data) in
            if data?.errorCode != 0 {
                let alert = UIAlertController(title: "Thành công", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel, handler: { (action) in
                    self?.delegate?.backToPrevious()
                }))
            } else {
                self?.presentBasicAlert(title: "Lỗi", message: data?.message ?? "", buttonTittle: "Đồng ý")
            }
        }
    }
    
    
    @IBAction func buttonDeleteTap(_ sender: Any) {
        let alert = UIAlertController(title: "Bạn có chắc muốn xóa khách hàng?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
            self?.deleteCustomer()
        }))
        alert.addAction(UIAlertAction(title: "Từ chối", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonUpdateTap(_ sender: Any) {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCustomerListEditDetailViewController") ?? UIViewController()) as! BASmartCustomerListEditDetailViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
        popoverContent.data = data
        popoverContent.blurDelegate = self
        popoverContent.updateDelegate = self
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension BASmartCustomerInformationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cellTitle = cellType[index].title
        
        switch cellType[index] {
        case .customerCode:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.kh_code ?? "", isShowIcon: true)
            return cell
        case .customerKind:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.kind_info?.name ?? "", isShowIcon: true)
            return cell
        case .customerType:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.type_info?.name ?? "", isShowIcon: true)
            return cell
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.name ?? "", isShowIcon: true)
            return cell
        case .phone:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerListPhoneTableViewCell", for: indexPath) as! BASmartCustomerListPhoneTableViewCell
            cell.setupData(title: cellTitle, phone: data.phone ?? "", objectId: objectId, kindId: phoneKindId)
            cell.delegate = self
            return cell
        case .contact:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.contact ?? "", isShowIcon: true)
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.address ?? "", isShowIcon: false)
            return cell
        case .source:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.source_info?.name ?? "", isShowIcon: true)
            return cell
        case .model:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            var contents = ""
            data.model_list?.forEach({ (item) in
                contents += "\(item.name ?? "")(\(item.ri ?? 0)), "
            })
            if contents.count > 0 {
                contents = String(contents.dropLast())
                contents = String(contents.dropLast())
            }
            cell.setupData(title: cellTitle, content: contents, isShowIcon: true)
            return cell
        case .scale:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.scale_info?.name ?? "", isShowIcon: true)
            return cell
        case .foundation:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.foundation ?? "", isShowIcon: true)
            return cell
        case .email:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.email ?? "", isShowIcon: true)
            return cell
        case .facebook:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.facebook ?? "", isShowIcon: true)
            return cell
        case .website:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerDetailDefaultTableViewCell", for: indexPath) as! BASmartCustomerDetailDefaultTableViewCell
            cell.setupData(title: cellTitle, content: data.website ?? "", isShowIcon: true)
            return cell
        case .decription:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerListDescriptionTableViewCell", for: indexPath) as! BASmartCustomerListDescriptionTableViewCell
            cell.setupData(content: data.description ?? "")
            return cell
        }
    }
    
}

extension BASmartCustomerInformationDetailViewController: BASmartGetPhoneNumberDelegate {
    func getPhoneNumber(objectId: Int, kindId: Int) {
        showListPhoneNumber(objectId: objectId, kindId: kindId)
    }
}

extension BASmartCustomerInformationDetailViewController: BASmartDoneUpdateDelegate {
    func finishUpdate() {
        updateDelegate?.finishUpdate()
    }
}
