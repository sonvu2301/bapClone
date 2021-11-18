//
//  BASmartCustomerInformationApproachViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/12/21.
//

import UIKit

protocol PreviewImageDelegate {
    func previewImage(url: String, indexPhoto: Int, indexList: Int)
}

class BASmartCustomerInformationApproachViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartCustomerDetailApproachList]()
    var customerId = 0
    var objectId = 0
    var kindId = 0
    var menuAction = [BASmartDetailMenuDetail]()
    var isShowAddButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BASmartCustomerInformationApproachTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerInformationApproachTableViewCell")
        
        isShowAddButton = menuAction.filter({$0.id == BASmartMenuAction.edit.id || $0.id == BASmartMenuAction.delete.id}).count > 0
        
        if isShowAddButton {
            //add footer view
            let footer = UIView(frame: CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: 60))
            let addImage = UIImage(named: "ic_add")?.resizeImage(targetSize: CGSize(width: 10, height: 10)).withRenderingMode(.alwaysTemplate)
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 20, height: 40))
            button.backgroundColor = UIColor(hexString: "33E776")
            button.setTitleColor(.white, for: .normal)
            button.setTitle(" Thêm mới tiếp xúc", for: .normal)
            button.setImage(addImage, for: .normal)
            button.tintColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setViewCorner(radius: 5)
            button.addTarget(self, action: #selector(addButtonTap), for: .touchUpInside)
            
            footer.addSubview(button)
            tableView.tableFooterView = footer
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func reloadData() {
        Network.shared.BASmartGetCustomerDetail(objectId: objectId, kindId: kindId) { [weak self] (data) in
            self?.data = data?.approach_list ?? [BASmartCustomerDetailApproachList]()
            self?.hideBlurBackground()
            self?.tableView.reloadData()
        }
    }
    
    @objc func addButtonTap() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCustomerCreateApproachViewController") ?? UIViewController()) as! BASmartCustomerCreateApproachViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 1000)
        popoverContent.customerId = customerId
        popoverContent.objectId = objectId
        popoverContent.delegate = self
        popoverContent.blurDelegate = self
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 200, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        
//        isEdit = false
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
}

extension BASmartCustomerInformationApproachViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerInformationApproachTableViewCell", for: indexPath) as! BASmartCustomerInformationApproachTableViewCell
        let dataPaste = data[indexPath.row]
        cell.delegate = self
        cell.previewImageDelegate = self
        cell.setupData(data: dataPaste)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 720
    }
    
}

extension BASmartCustomerInformationApproachViewController: BASmartHumanListDelegate {
    func edit(data: BASmartHumanCellSource, objectId: Int) {
        
    }
    
    func delete(objectId: Int) {
        let alert = UIAlertController(title: "Xóa thông tin tiếp xúc", message: "Bạn có chắc chắn muốn xóa tiếp xúc này ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: { [weak self] (action) in
            self?.showBlurBackground()
            Network.shared.BASmartDeleteApproach(customerId: self?.customerId ?? 0, objectId: objectId) { [weak self] (data) in
                if data?.error_code != 0 && data?.error_code != nil {
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

extension BASmartCustomerInformationApproachViewController: PreviewImageDelegate {
    func previewImage(url: String, indexPhoto: Int, indexList: Int) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewImageViewController") as! PreviewImageViewController
        guard let list = data[indexList].photo?.map({$0.link_full ?? ""}) else { return }
//        vc.setupData(imageList: list, index: indexPhoto)
        vc.list = list
        vc.index = indexPhoto
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension BASmartCustomerInformationApproachViewController: BASmartAddNewDelegate {
    func addNew() {
        Network.shared.BASmartGetCustomerDetail(objectId: objectId , kindId: kindId) { [weak self] (data) in
            self?.data = data?.approach_list ?? [BASmartCustomerDetailApproachList]()
            self?.tableView.reloadData()
        }
    }
}
