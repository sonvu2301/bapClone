//
//  ContactViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/14/20.
//

import UIKit

class ContactViewController: BaseViewController {
    
    @IBOutlet weak var inputSearch: UITextField!
    @IBOutlet weak var hbranchCollection: UICollectionView!
    
    @IBOutlet weak var tableEmployee: UITableView!
    
    @IBAction func searchText_changing(_ sender: Any) {
        GenerateDataSearch();
    }
    var data = [GeneralContactListData]()
    var dataSearch = [[ContactItem]()]
    
    
    var branchSelectIdx : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        setupView();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Danh bạ nhân viên"
    }
    
    private func setupView() {
        hbranchCollection.delegate = self
        hbranchCollection.dataSource = self
        hbranchCollection.register(UINib(nibName: "ContactBranchTableViewCell", bundle: nil), forCellWithReuseIdentifier: "ContactBranchTableViewCell")
        
        
        //tableEmployee.separatorStyle = .none
        tableEmployee.rowHeight = UITableView.automaticDimension
        tableEmployee.estimatedRowHeight = 160
        tableEmployee.delegate = self
        tableEmployee.dataSource = self
        tableEmployee.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        
    }
    
    private func getData() {
        Network.shared.GetContactInfo { [weak self] (data) in
            self?.data = data ?? [GeneralContactListData]()
            self?.hbranchCollection.reloadData()
            self?.GenerateDataSearch()
        }
    }
    
    private func GenerateDataSearch(){
        dataSearch = []
        var grp = [String : [ContactItem]]();
        
        for i in 0..<data.count{
            // 1. check Chọn nhánh
            if(branchSelectIdx != -1 && branchSelectIdx != i){
                continue
            }
            if let items = data[i].items{
                for employee in items {
                    // 2. check search
                    if(inputSearch.text != "" && inputSearch.text != nil){
                        let isFoundName = employee.fullname?.ToEng().lowercased().contains(inputSearch.text?.ToEng().lowercased() ?? "") ?? false
                        if(!isFoundName)
                        {
                            continue
                        }
                    }
                    
                    guard let str  = employee.department else {continue}
                    if grp[str] == nil{
                        grp[str] = [employee]
                    }
                    else{
                        var val : [ContactItem] = (grp[str] ?? [ContactItem]()) as [ContactItem];
                        val.append(employee)
                        grp[str] = val;
                    }
                }
            }
        }
        for (_, value) in grp {
            dataSearch.append(value)
        }
        tableEmployee.reloadData();
    }
    
    
    //    @objc func callButtonTap(sender: UIButton) {
    //        print(sender.tag)
    //        if let url = URL(string: "tel://090909090909"), UIApplication.shared.canOpenURL(url) {
    //            UIApplication.shared.open(url)
    //        }
    //    }
}
// coleection view branch
extension ContactViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactBranchTableViewCell", for: indexPath) as! ContactBranchTableViewCell
        
        cell.setData(item : data[indexPath.row].branch ?? ContactBranch())
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        branchSelectIdx = indexPath.row
        if let cell = collectionView.cellForItem(at: indexPath) as? ContactBranchTableViewCell {
            cell.selectItem();
        }
        GenerateDataSearch();
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ContactBranchTableViewCell {
            cell.deSelectItem();
        }
    }
}
extension ContactViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: UIScreen.main.bounds.width/CGFloat(data.count),height: hbranchCollection.bounds.size.height);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
// table view employee
extension ContactViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSearch[section].count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSearch.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSearch[section].first?.department ?? "";
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        let items = dataSearch[indexPath.section]
        cell.setupData(data: items[indexPath.row])
        return cell
    }
}
