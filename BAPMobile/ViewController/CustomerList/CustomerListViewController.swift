//
//  CustomerListViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/18/20.
//

import UIKit

class CustomerListViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data = [CustomerData]()
    var dataFiltered = [CustomerData]()
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Danh Sách Khách Hàng"
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomerListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomerListTableViewCell")
        
        searchBar.delegate = self
        searchBar.setImage(UIImage(named: "ic_search")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), for: .search, state: .normal)
        view.showBlurLoader()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_refresh")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(reloadData))
    }
    
    private func getData() {
        Network.shared.getCustomerList(key: "") { [weak self](data) in
            self?.data = data?.data ?? [CustomerData]()
            self?.tableView.reloadData()
            self?.view.removeBlurLoader()
        }
    }
    
    @objc func reloadData() {
        view.showBlurLoader()
        getData()
    }
    
}

extension CustomerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = isSearchBarEmpty == true ? data.count : dataFiltered.count
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerListTableViewCell", for: indexPath) as! CustomerListTableViewCell
        let parseData = isSearchBarEmpty == true ? data[indexPath.row] : dataFiltered[indexPath.row]
        cell.setupData(xn: String(parseData.xn_code ?? 0), name: parseData.name ?? "", address: parseData.address ?? "", phone: parseData.phone ?? "")
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor(hexString: "E6E6E6") : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "CustomerList", bundle: nil).instantiateViewController(withIdentifier: "CustomerCarListViewController") as! CustomerCarListViewController
        let parseData = isSearchBarEmpty == true ? data[indexPath.row] : dataFiltered[indexPath.row]
        vc.presetupView(xn: String(parseData.xn_code ?? 0),
                        name: parseData.name ?? "",
                        address: parseData.address ?? "",
                        phone: parseData.phone ?? "",
                        object_id: parseData.object_id ?? 0)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension CustomerListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.lowercased()
        dataFiltered = data.filter({$0.address?.lowercased().contains(text) == true ||
            String($0.xn_code ?? 0).lowercased().contains(text) == true ||
            $0.name?.lowercased().contains(text) == true
        })
        
        tableView.reloadData()
    }
    
}

