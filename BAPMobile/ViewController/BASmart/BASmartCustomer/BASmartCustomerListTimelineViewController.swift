//
//  BASmartCustomerListTimelineViewController.swift
//  BAPMobile
//
//  Created by Emcee on 1/21/21.
//

import UIKit

protocol AddNewDiaryDelegate {
    func addNewDiary()
}

class BASmartCustomerListTimelineViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [BASmartCustomerTimelineData]()
    var sectionHeaderTitle = [String]()
    var numberOfItem = [Int]()
    var objectId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "BASmartCustomerInformationTimelineTableViewCell", bundle: nil), forCellReuseIdentifier: "BASmartCustomerInformationTimelineTableViewCell")
        
        title = "LỊCH SỬ TƯƠNG TÁC"
        let addBarButton = UIBarButtonItem(image: UIImage(named: "ic_add")?.resizeImage(targetSize: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(addBarButtonTap))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func getData() {
        sectionHeaderTitle = [String]()
        numberOfItem = [Int]()
        Network.shared.BASmartGetCustomerTimeline(objectId: objectId) { [weak self] (data) in
            self?.data = data ?? [BASmartCustomerTimelineData]()
            var sectionCondition = ""
            
            //Add array of section name
            data?.forEach({ (item) in
                if item.group != sectionCondition {
                    sectionCondition = item.group ?? ""
                    self?.sectionHeaderTitle.append(sectionCondition)
                }
            })
            
            //Add number of item in section
            self?.sectionHeaderTitle.forEach({ (item) in
                self?.numberOfItem.append(data?.filter({$0.group == item}).count ?? 0)
            })
            self?.tableView.reloadData()
        }
    }
    
    @objc func addBarButtonTap() {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "BASmartCustomerListTimelineAddNewViewController") ?? UIViewController()) as! BASmartCustomerListTimelineAddNewViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: view.frame.width - 20, height: 480)
        popoverContent.objectId = objectId
        popoverContent.delegate = self
        popoverContent.blurDelegate = self
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: 10, y: 350, width: 0, height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
}

extension BASmartCustomerListTimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            return 0
        } else {
            return numberOfItem[section]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitle.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = BASmartCustomerTimelineSection()
        headerView.labelTitle.text = sectionHeaderTitle[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BASmartCustomerInformationTimelineTableViewCell", for: indexPath) as! BASmartCustomerInformationTimelineTableViewCell
        if tableView.isLast(for: indexPath) {
            cell.dotView.isHidden = true
        }
        //Get the index
        var index = indexPath.row
        if indexPath.section > 0 {
            for i in 0..<indexPath.section {
                index += numberOfItem[i]
            }
        }
        
        let dataPaste = data[index]
        cell.setupData(time: dataPaste.edit_time ?? 0,
                       content: dataPaste.quote ?? "",
                       title: dataPaste.title ?? "",
                       contact: dataPaste.contact ?? "",
                       phone: dataPaste.phone ?? "",
                       icon: dataPaste.icon ?? "",
                       objectId: dataPaste.id ?? 0,
                       kindId: BASmartKindId.timeline.id)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension BASmartCustomerListTimelineViewController: AddNewDiaryDelegate {
    func addNewDiary() {
        getData()
    }
}

extension BASmartCustomerListTimelineViewController: BASmartGetPhoneNumberDelegate {
    func getPhoneNumber(objectId: Int, kindId: Int) {
        showListPhoneNumber(objectId: objectId, kindId: kindId)
    }
}
