//
//  KeepingDetailViewController.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 17/03/2022.
//

import UIKit

class KeepingDetailViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableDetail: UITableView!
    var dataTask =  TimeKeepingItem()
    
    //var dataDetail:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableDetail.allowsSelection  = false
        tableDetail.separatorStyle = .none
        tableDetail.estimatedRowHeight = 140
        tableDetail.rowHeight = UITableView.automaticDimension
        tableDetail.dataSource = self
        tableDetail.delegate = self
        tableDetail.register(UINib(nibName: "KeepingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "KeepingDetailTableViewCell")
        bgImage.downloaded(from: (dataTask.imageSrc ?? ""), contentMode: .scaleAspectFill)
        lblTitle.text = dataTask.quoteStr
        getData()
    }
    
    func setupData(item: TimeKeepingItem){
        dataTask = item
    }
    func getData(){
        
    }
}
extension KeepingDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KeepingDetailTableViewCell", for: indexPath) as! KeepingDetailTableViewCell
        
        return cell
    }
    
}
