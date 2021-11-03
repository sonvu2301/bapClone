//
//  BASmartSearchByPhoneViewController.swift
//  BAPMobile
//
//  Created by Emcee on 5/31/21.
//

import UIKit
import DropDown

struct HistorySearchByPhone: Codable {
    var phone: String
    var date: Date
}

class BASmartSearchByPhoneViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSearch: UIButton!
    
    var data = [BASmartCustomerListData]()
    var history = [HistorySearchByPhone]()
    
    var userDefault = UserDefaults.standard
    var dropDown = DropDown()
    
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
        
        let image = UIImage(named: "ic_search")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        buttonSearch.setImage(image, for: .normal)
        
        searchBar.delegate = self
        let searchBarStyle = searchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never

        history = getHistorySearch()
        
        dropDown.dataSource = history.map({$0.phone})
        dropDown.width = searchBar.frame.width - 10
        dropDown.direction = .bottom
        dropDown.anchorView = searchBar
        dropDown.bottomOffset = CGPoint(x: 5, y: searchBar.frame.height - 12)
        dropDown.cellNib = UINib(nibName: "DropdownSearchHistoryTableViewCell", bundle: nil)
        dropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropdownSearchHistoryTableViewCell else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.labelDate.text = formatter.string(from: self?.history[index].date ?? Date())
        }
    }
    
    
    private func searchCustomer(phone: String) {
        Network.shared.BASmartCustomerSearchByPhone(phone: phone) { [weak self] (data) in
            if data?.error_code != 0 {
                self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
            } else {
                self?.data = data?.data ?? [BASmartCustomerListData]()
                self?.appendHistorySearch(phone: phone)
                self?.tableView.reloadData()
            }
        }
    }
    
    private func appendHistorySearch(phone: String) {
        var oldHistory = getHistorySearch()
        oldHistory = oldHistory.filter({$0.phone != phone})
        oldHistory.append(HistorySearchByPhone(phone: phone, date: Date()))
        
        history = oldHistory
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(oldHistory) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "search_by_phone")
        }
        dropDown.dataSource = history.map({$0.phone})
    }
    
    private func getHistorySearch() -> [HistorySearchByPhone] {
        if let savedHistory = userDefault.object(forKey: "search_by_phone") as? Data {
            let decoder = JSONDecoder()
            if let loadedHistory = try? decoder.decode([HistorySearchByPhone].self, from: savedHistory) {
                return loadedHistory
            } else {
                return [HistorySearchByPhone]()
            }
        } else {
            return [HistorySearchByPhone]()
        }
    }
    
    @IBAction func buttonSearchTap(_ sender: Any) {
        searchCustomer(phone: searchBar.text ?? "")
    }
    
}

extension BASmartSearchByPhoneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerListContentTableViewCell", for: indexPath) as! BASmartCustomerListContentTableViewCell
        let dataPaste = data[indexPath.row]
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
                       kindId: GetPhoneKind.search.kindId)
        
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
        let dataPaste = data[indexPath.row]
        vc.objectId = dataPaste.object_id ?? 0
        vc.kind = BASmartCustomerGroup.potential.id
        vc.phoneKindId = GetPhoneKind.search.kindId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BASmartSearchByPhoneViewController: BASmartGetPhoneNumberDelegate {
    func getPhoneNumber(objectId: Int, kindId: Int) {
        showListPhoneNumber(objectId: objectId, kindId: kindId)
    }
}

extension BASmartSearchByPhoneViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDown.deselectRow(at: index)
            self?.searchCustomer(phone: item)
        }
        return true
    }
}
