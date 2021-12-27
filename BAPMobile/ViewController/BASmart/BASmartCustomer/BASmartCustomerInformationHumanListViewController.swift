//
//  BASmartCustomerInformationHumanListViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/12/21.
//

import UIKit

protocol BASmartDoneUpdateDelegate {
    func finishUpdate()
}

protocol BASmartAddNewDelegate {
    func addNew()
}

protocol BASmartHumanListDelegate {
    func edit(data: BASmartHumanCellSource, objectId: Int)
    func delete(objectId: Int)
}

class BASmartCustomerInformationHumanListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartCustomerDetailHumanList]()
    var editData = BASmartHumanCellSource()
    var editProfList = [BASmartCustomerCatalogItemsDetail]()
    var menuAction = [BASmartDetailMenuDetail]()
    var isShowAddButton = false
    var isEdit = false
    var customerId = 0
    var objectId = 0
    var cellId = 0
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
        tableView.register(UINib(nibName: "BASmartCustomerListHumanTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerListHumanTableViewCell")
        
        isShowAddButton = menuAction.filter({$0.id == BASmartMenuAction.edit.id || $0.id == BASmartMenuAction.delete.id}).count > 0
        
        if isShowAddButton {
            //add footer view
            let footer = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: 60))
            let addImage = UIImage(named: "ic_add")?.resizeImage(targetSize: CGSize(width: 10, height: 10)).withRenderingMode(.alwaysTemplate)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 20, height: 40))
            button.backgroundColor = UIColor(hexString: "33E776")
            button.setTitleColor(.white, for: .normal)
            button.setTitle(" Thêm mới người đại diện", for: .normal)
            button.setImage(addImage, for: .normal)
            button.tintColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setViewCorner(radius: 5)
            button.addTarget(self, action: #selector(addButtonTap), for: .touchUpInside)
            
            footer.addSubview(button)
            tableView.tableFooterView = footer
        }
    }
    
    private func reloadData() {
        Network.shared.BASmartGetCustomerDetail(objectId: objectId, kindId: kindId) { [weak self] (data) in
            self?.data = data?.human_list ?? [BASmartCustomerDetailHumanList]()
            self?.hideBlurBackground()
            self?.tableView.reloadData()
        }
    }
    
    @objc func addButtonTap() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCustomerInformationAddHumanBaseViewController") ?? UIViewController()) as! BASmartCustomerInformationAddHumanBaseViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 800)
        popoverContent.customerId = customerId
        popoverContent.data = editData
        popoverContent.profList = editProfList
        popoverContent.isEdit = isEdit
        popoverContent.objectId = cellId
        popoverContent.delegate = self
        popoverContent.blurDelegate = self
        
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
        isEdit = false
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
}

extension BASmartCustomerInformationHumanListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerListHumanTableViewCell", for: indexPath) as! BASmartCustomerListHumanTableViewCell
        cell.delegate = self
        let dataParse = data[indexPath.row]
        let cellData = BASmartHumanCellSource(name: dataParse.full_name ?? "",
                                              kind: dataParse.kind_info?.name ?? "",
                                              position: dataParse.position_info?.name ?? "",
                                              birth: dataParse.birthday ?? "",
                                              email: dataParse.email ?? "",
                                              facebook: dataParse.facebook ?? "",
                                              marriage: dataParse.marital_info?.name ?? "",
                                              gender: dataParse.gender_info?.name ?? "",
                                              religion: dataParse.religion_info?.name ?? "",
                                              ethnic: dataParse.ethnic_info?.name ?? "",
                                              hobbit: dataParse.hobbit ?? "",
                                              phone: dataParse.phone ?? "")
        
        cell.setupData(data: cellData,
                       objectId: dataParse.object_id ?? 0,
                       kindId: GetPhoneKind.human.kindId)
        cell.callDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
}

extension BASmartCustomerInformationHumanListViewController: BASmartAddNewDelegate {
    func addNew() {
        reloadData()
    }
}

extension BASmartCustomerInformationHumanListViewController: BASmartHumanListDelegate {
    func edit(data: BASmartHumanCellSource, objectId: Int) {
        editData = data
        cellId = objectId
        isEdit = true
        editProfList = self.data.filter({$0.object_id == objectId}).first?.prof ?? [BASmartCustomerCatalogItemsDetail]()
        addButtonTap()
    }
    
    func delete(objectId: Int) {
        
        let alert = UIAlertController(title: "Xóa thông tin người đại diện", message: "Bạn có chắc chắn muốn xóa thông tin người đại diện này ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: { [weak self] (action) in
            self?.showBlurBackground()
            Network.shared.BASmartDeleteHuman(customerId: self?.customerId ?? 0, objectId: objectId) { [weak self] (data) in
                if data?.errorCode != 0 && data?.errorCode != nil {
                    self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
                    self?.hideBlurBackground()
                } else {
                    self?.reloadData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension BASmartCustomerInformationHumanListViewController: BASmartGetPhoneNumberDelegate {
    func getPhoneNumber(objectId: Int, kindId: Int) {
        showListPhoneNumber(objectId: objectId, kindId: kindId)
    }
}
