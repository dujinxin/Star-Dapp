//
//  TradeRecordController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TradeRecordController: JXTableViewController {
    
    var vm = TradeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(UINib(nibName: "PropertyCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.estimatedRowHeight = 44
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.vm.tradeRecord(pageNo: self.page) { (_, msg, isSuc) in
                self.tableView?.mj_header.endRefreshing()
                if isSuc {
                    self.tableView?.reloadData()
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        })
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.vm.tradeRecord(pageNo: self.page) { (_, msg, isSuc) in
                self.tableView?.mj_footer.endRefreshing()
                if isSuc {
                    self.tableView?.reloadData()
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        })
        self.tableView?.mj_header.beginRefreshing()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.tradeListEntity.listArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PropertyCell
        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
        
        cell.propertyTitleLabel.text = entity.title
        cell.timeLabel.text = entity.tradeTime
        cell.numberLabel.text = "- \(entity.tradeAmount) IPE"
        cell.numberLabel.textColor = UIColor.rgbColor(from: 4, 187, 103)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
        
        self.vm.tradeDetails(entity.id ?? "") { (_, msg, isSuc) in
            
        }
    }
}
