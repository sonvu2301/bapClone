//
//  BASmartReasonViewController.swift
//  BAPMobile
//
//  Created by Emcee on 6/18/21.
//

import UIKit

enum SelectMultiCatalogType {
    case reason, project
}

class BASmartReasonViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    @IBOutlet weak var seperateView: UIView!
    
    var delegate: GetReasonListDelegate?
    var data = [BASmartCustomerCatalogItems]()
    var dataSelect = [BASmartIdInfo]()
    var type = SelectMultiCatalogType.reason
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        seperateView.drawDottedLine(view: seperateView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BASmartSupporterListTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartSupporterListTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.allowsSelection = true
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor.lightGray.cgColor
        buttonCancel.setViewCorner(radius: 5)
        buttonConfirm.setViewCorner(radius: 5)
        
        switch type {
        case .reason:
            data = BASmartCustomerCatalogDetail.shared.reason
        case .project:
            data = BASmartCustomerCatalogDetail.shared.project
        }
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "CHỌN LÝ DO"
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonConfirmTap(_ sender: Any) {
        var names = ""
        dataSelect.forEach { [weak self] (item) in
            let reason = self?.data.filter({($0.id ?? 0) == item.id}) ??  [BASmartCustomerCatalogItems]()
            names += reason.first?.name ?? ""
            names += ", "
        }
        
        names = String(names.dropLast())
        names = String(names.dropLast())
        switch type {
        case .reason:
            delegate?.reasonList(reason: dataSelect, name: names)
        case .project:
            delegate?.projectList(project: dataSelect, name: names)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension BASmartReasonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartSupporterListTableViewCell", for: indexPath) as! BASmartSupporterListTableViewCell
        let dataPaste = data[indexPath.row]
        let state = dataSelect.map({$0.id}).contains(dataPaste.id)

        cell.setupView(supporterData: nil,
                       state: state,
                       index: indexPath.row,
                       isReason: true,
                       reasonData: dataPaste)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let dataParse = data[indexPath.row]
        let selectedId = dataSelect.map({$0.id})
        if selectedId.contains(dataParse.id) {
            if let index = selectedId.firstIndex(of: dataParse.id) {
                dataSelect.remove(at: index)
            }
        } else {
            dataSelect.append(BASmartIdInfo(id: dataParse.id))
        }
        
        tableView.reloadData()
    }
}

extension BASmartReasonViewController: SelectCheckBoxDelegate {
    func selectAction(state: Bool, index: Int) {
        let dataParse = data[index]
        let selectedId = dataSelect.map({$0.id})
        if selectedId.contains(dataParse.id) {
            if let index = selectedId.firstIndex(of: dataParse.id) {
                dataSelect.remove(at: index)
            }
        } else {
            dataSelect.append(BASmartIdInfo(id: dataParse.id))
        }
        
        tableView.reloadData()
    }
}
