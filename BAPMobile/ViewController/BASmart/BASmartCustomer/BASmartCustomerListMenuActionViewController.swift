//
//  BASmartCustomerListMenuActionViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/21/21.
//

import UIKit

enum MenuActionDropdown {
    case edit, delete, checkin, create, photo, history
    
    var id: Int {
        switch self {
        case .edit:
            return 2
        case .delete:
            return 8
        case .checkin:
            return 65
        case .create:
            return 66
        case .photo:
            return 129
        case .history:
            return 130
        }
    }
    
    var vc: UIViewController {
        switch self {
        case .edit:
            return UIViewController()
        case .delete:
            return UIViewController()
        case .checkin:
            return UIViewController()
        case .create:
            return UIViewController()
        case .photo:
            return UIViewController()
        case .history:
            return UIViewController()
        }
    }
}


class BASmartCustomerListMenuActionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartDetailMenuDetail]()
    var cellTypes = [MenuActionDropdown]()
    var delegate: BASmartCustomerMainMenuActionDelegate?
    var blurDelegate: BlurViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.isHidden = true
        data = data.filter({$0.id != BASmartMenuAction.edit.id &&
                            $0.id != BASmartMenuAction.delete.id &&
                            $0.id != BASmartMenuAction.diary.id})
        
        data.forEach { [weak self] (item) in
            switch item.id {
            case 2:
                self?.cellTypes.append(.edit)
            case 8:
                self?.cellTypes.append(.delete)
            case 65:
                self?.cellTypes.append(.checkin)
            case 66:
                self?.cellTypes.append(.create)
            case 129:
                self?.cellTypes.append(.photo)
            case 130:
                self?.cellTypes.append(.history)
            default:
                break
            }
        }
    }
}

extension BASmartCustomerListMenuActionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerListMenuActionTableViewCell", for: indexPath) as! BASmartCustomerListMenuActionTableViewCell
        let dataPaste = data[indexPath.row]
        cell.setupData(urlImage: dataPaste.icon ?? "",
                       title: dataPaste.name ?? "")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        var type = BASmartMenuAction.none
        
        switch data[indexPath.row].id {
        case 2:
            type = .edit
        case 8:
            type = .delete
        case 65:
            type = .checkin
        case 66:
            type = .create
        case 97:
            type = .tb
        case 98:
            type = .ba
        case 129:
            type = .photoList
        case 130:
            type = .history
        case 131:
            type = .diary
        case 67:
            type = .tranfer
        default:
            break
        }
        
        delegate?.mainMenuAction(type: type)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}


