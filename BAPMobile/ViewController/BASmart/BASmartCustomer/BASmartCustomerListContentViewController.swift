//
//  BASmartCustomerListContentViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/5/21.
//

import UIKit

class BASmartCustomerListContentViewController: BaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonRefresh: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var list = [BASmartCustomerListData]()
    var listFiltered = [BASmartCustomerListData]()
    
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    var kind = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartCustomerListContentTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerListContentTableViewCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
        
        let origImage = UIImage(named: "ic_refresh")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        buttonRefresh.setImage(tintedImage, for: .normal)
        buttonRefresh.tintColor = UIColor().defaultColor()
        
        searchBar.delegate = self
    }
    
    func getCustomerList(groupId: Int){
        Network.shared.BASmartGetCustomerList(group_id: groupId) { [weak self] (data) in
            self?.list = data ?? [BASmartCustomerListData]()
            if !(data?.isEmpty ?? false) {
                self?.getCatalog()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.view.removeBlurLoader()
            }
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func buttonRefreshTap(_ sender: Any) {
        view.showBlurLoader()
        getCustomerList(groupId: kind)
    }
}


extension BASmartCustomerListContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchBarEmpty == true ? list.count : listFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerListContentTableViewCell", for: indexPath) as! BASmartCustomerListContentTableViewCell
        let dataPaste = isSearchBarEmpty == true ? list[indexPath.row] : listFiltered[indexPath.row]
        cell.setupCell(code: dataPaste.kh_code ?? "",
                       name: (dataPaste.name == "" ? " " : dataPaste.name) ?? "",
                       address: (dataPaste.address == "" ? " " : dataPaste.address) ?? "",
                       stateName: dataPaste.state_info?.name ?? "",
                       stateColor: dataPaste.state_info?.color ?? "",
                       rankName: dataPaste.rank_info?.name ?? "",
                       rankColor: dataPaste.rank_info?.color ?? "",
                       phone: dataPaste.phone ?? "",
                       rate: dataPaste.rate?.name ?? "",
                       rateColor: dataPaste.rate?.color ?? "",
                       objectId: dataPaste.object_id ?? 0,
                       kindId: GetPhoneKind.basmartDefault.kindId)
        
        if dataPaste.partner != nil {
            cell.setupPartnerInfo(name: dataPaste.partner?.code ?? "",
                                  bcolor: dataPaste.partner?.bcolor ?? "",
                                  fcolor: dataPaste.partner?.fcolor ?? "")
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "BASmartCustomerInformationViewController") as! BASmartCustomerInformationViewController
        let dataPaste = isSearchBarEmpty == true ? list[indexPath.row] : listFiltered[indexPath.row]
        vc.objectId = dataPaste.object_id ?? 0
        vc.kind = GetPhoneKind.basmartDefault.kindId
        vc.phoneKindId = GetPhoneKind.basmartDefault.kindId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BASmartCustomerListContentViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.lowercased()
        listFiltered = list.filter({$0.kh_code?.lowercased().contains(text) == true ||
            $0.name?.lowercased().contains(text) == true ||
            $0.address?.lowercased().contains(text) == true
        })
        
        tableView.reloadData()
    }
}

extension BASmartCustomerListContentViewController: BASmartGetPhoneNumberDelegate {
    func getPhoneNumber(objectId: Int, kindId: Int) {
        showListPhoneNumber(objectId: objectId, kindId: kindId)
    }
}
