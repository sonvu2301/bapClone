//
//  BASmartWarehouseCustomerListViewController.swift
//  BAPMobile
//
//  Created by Emcee on 11/30/21.
//

import UIKit

class BASmartWarehouseCustomerListViewController: BaseSideMenuViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartWarehouseCustomerData]()
    var catalog = BASmartWarehouseCatalogData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "DỮ LIỆU KHÁCH HÀNG"
    }
    

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartWarehouseCustomerListTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartWarehouseCustomerListTableViewCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "ic_add")?.resizeImage(targetSize: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(addButtonAction))
        
        getData()
        getWarehouseCatalog()
    }
    
    private func getWarehouseCatalog() {
        Network.shared.BASmartGetWarehouseCatalog { [weak self] data in
            self?.catalog = data?.data ?? BASmartWarehouseCatalogData()
        }
    }
    
    private func getData() {
        Network.shared.BASmartWarehouseCustomerList { [weak self] data in
            self?.data = data?.data ?? [BASmartWarehouseCustomerData]()
            self?.tableView.reloadData()
        }
    }
    
    @objc func addButtonAction() {
        let storyBoard = UIStoryboard(name: "BASmartWarranty", bundle: nil)
        let popoverContent = storyBoard.instantiateViewController(withIdentifier: "BASmartAddCustomerWarehouseViewController") as! BASmartAddCustomerWarehouseViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 610)
        popoverContent.blurDelegate = self
        popoverContent.finishDelegate = self
        popoverContent.catalog = catalog
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 400, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        popover?.delegate = self
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
}

extension BASmartWarehouseCustomerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartWarehouseCustomerListTableViewCell", for: indexPath) as! BASmartWarehouseCustomerListTableViewCell
        cell.setupData(data: data[indexPath.row])
        return cell
    }
}

extension BASmartWarehouseCustomerListViewController: BASmartDoneCreateDelegate {
    func finishCreate() {
        getData()
    }
}
