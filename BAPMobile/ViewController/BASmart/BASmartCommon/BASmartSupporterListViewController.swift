//
//  BASmartSupporterListViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/3/21.
//

import UIKit

protocol SelectCheckBoxDelegate {
    func selectAction(state: Bool, index: Int)
}

class BASmartSupporterListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seperateView: UIView!
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    
    var data = [BASmartUtilitySupportData]()
    var states = [Bool]()
    var delegate: GetSupporterNameDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "TÌM KIẾM NHÂN VIÊN"
    }
    
    private func setupView() {
        seperateView.drawDottedLine(view: seperateView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartSupporterListTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartSupporterListTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.allowsSelection = false
        
        viewSearch.layer.borderColor = UIColor.black.cgColor
        viewSearch.layer.borderWidth = 1
        viewSearch.setViewCorner(radius: viewSearch.frame.height / 2)
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor.lightGray.cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        searchSupporter(key: "")
    }
    
    private func searchSupporter(key: String) {
        Network.shared.BASmartGetSupport(search: key) { [weak self] (data) in
            if data?.error_code == 0 || data?.error_code == nil {
                self?.data = data?.data ?? [BASmartUtilitySupportData]()
                self?.finishSearch()
            } else {
                self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
            }
        }
    }
    
    private func finishSearch() {
        states = [Bool]()
        data.forEach { (_) in
            states.append(false)
        }
        tableView.reloadData()
    }
    
    @IBAction func buttonSearchTap(_ sender: Any) {
        searchSupporter(key: textFieldSearch.text ?? "")
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        var names = ""
        for i in 0..<states.count {
            if states[i] == true {
                names += (data[i].fullName ?? "") + " (" + (data[i].userName ?? "") + ") "
            }
        }
        delegate?.getName(name: names)
        navigationController?.popViewController(animated: true)
    }
    
}

extension BASmartSupporterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartSupporterListTableViewCell", for: indexPath) as! BASmartSupporterListTableViewCell
        let dataParse = data[indexPath.row]
        let state = states[indexPath.row]
        cell.setupView(supporterData: dataParse,
                       state: state,
                       index: indexPath.row,
                       isReason: false,
                       reasonData: nil)
        return cell
    }
}


extension BASmartSupporterListViewController: SelectCheckBoxDelegate {
    func selectAction(state: Bool, index: Int) {
        states[index] = state
    }
}
