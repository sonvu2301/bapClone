//
//  NotificationViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/4/20.
//

import UIKit

class NotificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: MainTabBarDelegate?
    var data: [NotifyList] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.view.showBlurLoader()
        getNotification()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupView() {
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        navigationItem.title = "Thông Báo"
        let imageLeftBarButton = UIImage(named: "ic_back")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: imageLeftBarButton, style: .plain, target: self, action: #selector(tapLeftBarButton(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(tapRightBarButton))
    }
    
    private func getNotification() {
        Network.shared.getNotification(time: 0) { [weak self] (item) in
            self?.data = item?.data.notify_list ?? [NotifyList]()
            self?.view.removeBlurLoader()
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    @objc func tapLeftBarButton(sender: UIBarButtonItem) {
        delegate?.changeIndex(index: 0)
    }
    
    @objc func tapRightBarButton() {
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getNotification()
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.titleLabel.text = data[indexPath.row].title_str
        cell.contentLabel.text = data[indexPath.row].data_str
        cell.dateLabel.text = Date().millisecToDate(time: data[indexPath.row].time_unix)
        return cell
    }
}
