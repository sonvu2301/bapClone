//
//  BASmartCustomerInformationCompetitorViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/12/21.
//

import UIKit

protocol BASmartCompetitorListDelegate {
    func edit(data: BASmartCompetitorCellSource, cellId: Int)
    func delete(objectId: Int)
}

class BASmartCustomerInformationCompetitorViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartCustomerDetailCompetitorList]()
    var editData = BASmartCompetitorCellSource()
    var menuAction = [BASmartDetailMenuDetail]()
    var isShowAddButton = false
    var customerId: Int?
    var objectId: Int?
    var cellId: Int?
    var isEdit = false
    var kindId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BASmartCustomerListCompetitorTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerListCompetitorTableViewCell")
        
        isShowAddButton = menuAction.filter({$0.id == BASmartMenuAction.edit.id || $0.id == BASmartMenuAction.delete.id}).count > 0
        
        if isShowAddButton {
            //add footer view
            let footer = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: 60))
            let addImage = UIImage(named: "ic_add")?.resizeImage(targetSize: CGSize(width: 10, height: 10)).withRenderingMode(.alwaysTemplate)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 20, height: 40))
            button.backgroundColor = UIColor(hexString: "33E776")
            button.setTitleColor(.white, for: .normal)
            button.setTitle(" Thêm mới đối thủ", for: .normal)
            button.setImage(addImage, for: .normal)
            button.tintColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setViewCorner(radius: 5)
            button.addTarget(self, action: #selector(addButtonTap), for: .touchUpInside)
            
            footer.addSubview(button)
            tableView.tableFooterView = footer
        }
    }
    
    @objc func addButtonTap() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCustomerInformationAddCompetitorViewController") ?? UIViewController()) as! BASmartCustomerInformationAddCompetitorViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 550)
        popoverContent.customerId = customerId ?? 0
        popoverContent.data = editData
        popoverContent.objectId = cellId
        popoverContent.isEdit = isEdit
        popoverContent.delegate = self
        popoverContent.blurDelegate = self
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 200, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        isEdit = false
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    private func reloadData() {
        Network.shared.BASmartGetCustomerDetail(objectId: objectId ?? 0, kindId: kindId) { [weak self] (data) in
            self?.data = data?.competitor_list ?? [BASmartCustomerDetailCompetitorList]()
            self?.hideBlurBackground()
            self?.tableView.reloadData()
        }
    }
    
}

extension BASmartCustomerInformationCompetitorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerListCompetitorTableViewCell", for: indexPath) as! BASmartCustomerListCompetitorTableViewCell
        let dataPaste = data[indexPath.row]
        
        let cellData = BASmartCompetitorCellSource(provider: dataPaste.provider_info?.name ?? "",
                                                   vehicleCount: dataPaste.vehicle_count ?? 0,
                                                   level: dataPaste.leave_level_info?.name ?? "",
                                                   expireDate: dataPaste.expried_date ?? 0,
                                                   price: dataPaste.price_str ?? "",
                                                   description: dataPaste.description ?? "",
                                                   isEdit: isShowAddButton)
        
        cell.setupData(data: cellData, objectId: dataPaste.object_id ?? 0)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
}

extension BASmartCustomerInformationCompetitorViewController: BASmartAddNewDelegate {
    func addNew() {
        Network.shared.BASmartGetCustomerDetail(objectId: objectId ?? 0, kindId: kindId) { [weak self] (data) in
            self?.data = data?.competitor_list ?? [BASmartCustomerDetailCompetitorList]()
            self?.tableView.reloadData()
        }
    }
}

extension BASmartCustomerInformationCompetitorViewController: BASmartCompetitorListDelegate {
    func edit(data: BASmartCompetitorCellSource, cellId: Int) {
        editData = data
        self.cellId = cellId
        isEdit = true
        addButtonTap()
    }
    
    func delete(objectId: Int) {
        
        let alert = UIAlertController(title: "Xóa thông tin đối thủ", message: "Bạn có chắc chắn muốn xóa thông tin đối thủ này ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: { [weak self] (action) in
            self?.showBlurBackground()
            Network.shared.BASmartDeleteCompetitor(customerId: self?.customerId ?? 0, objectId: objectId) { [weak self] (data) in
                if data?.error_code != 0 && data?.error_code != nil {
                    self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
                } else {
                    self?.reloadData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
