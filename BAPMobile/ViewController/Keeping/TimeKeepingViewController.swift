//
//  TimeKeepingViewController.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 14/03/2022.
//

import UIKit

class TimeKeepingViewController: BaseViewController {
    @IBOutlet weak var yearView: DateHorizontal!
    @IBOutlet weak var keepingTableView: UITableView!
    var data = TimeKeepingData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CHẤM CÔNG NHÂN VIÊN"
        imagePickDelegate = self
        
        keepingTableView.dataSource = self
        keepingTableView.delegate = self
        keepingTableView.register(UINib(nibName: "KeepingTableViewCell", bundle: nil), forCellReuseIdentifier: "KeepingTableViewCell")
        yearView.delegate  = self
        yearView.setType(type: .year)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_timekeeping.png")?.resizeImage(targetSize: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(checkInCheckout))
        
    }
    @objc func checkInCheckout(){
        getImage(fromSourceType: .camera)
    }
    func getData(year: Int){
        
        Network.shared.getTimekeeping(monthStart: year * 12 + 1, monthEnd: year * 12 + 12) { [weak self] (data) in
            self?.data = data?.data ?? TimeKeepingData()
            self?.keepingTableView.reloadData()
        }
    }
}
extension TimeKeepingViewController: IDateDelegate{
    func selectDateDelegate(date: Date) {
        getData(year: date.getComponents().year ?? 0)
    }
}
extension TimeKeepingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.taskList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KeepingTableViewCell", for: indexPath) as! KeepingTableViewCell
        cell.setupView(item: data.taskList?[indexPath.row] ?? TimeKeepingItem())
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "KeepingDetailViewController") ?? UIViewController()) as! KeepingDetailViewController
        let item = data.taskList?[indexPath.row] ?? TimeKeepingItem()
        vc.setupData(item: item)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension TimeKeepingViewController: ImagePickerFinishDelegate {
    func imagePickerFinish(image: UIImage) {
        let popoverContent = (storyboard?.instantiateViewController(withIdentifier: "CheckInCheckoutViewController") ?? UIViewController()) as! CheckInCheckoutViewController
        popoverContent.imgContent = image
        popoverContent.reTakeImageDelete = self
        //popoverContent.retakeAction = checkInCheckout
        let nav = UINavigationController(rootViewController: popoverContent)
        
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .coverVertical
        
        self.present(nav, animated: true, completion: nil)
    }
}
extension TimeKeepingViewController: IRetakeImageKeeping{
    func retakeImageDelegate() {
        checkInCheckout()
    }
    
    
}
