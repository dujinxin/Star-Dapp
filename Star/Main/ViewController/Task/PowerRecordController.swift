//
//  PowerRecordController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/12.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PowerRecordController: JXTableViewController{
    
    var vm = TaskVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = JXF1f1f1Color
        self.title = "智慧记录"
        
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
            self.tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView?.register(UINib(nibName: "PropertyCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.vm.powerRecord(pageNo: self.page) { (_, msg, isSuc) in
                self.tableView?.mj_header.endRefreshing()
                if isSuc {
                    self.tableView?.reloadData()
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        })
//        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//            self.page += 1
//            self.vm.powerRecord(pageNo: self.page) { (_, msg, isSuc) in
//                self.tableView?.mj_footer.endRefreshing()
//                if isSuc {
//                    self.tableView?.reloadData()
//                } else {
//                    ViewManager.showNotice(msg)
//                }
//            }
//        })
        self.tableView?.mj_header.beginRefreshing()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        return self.vm.powerRecordEntity.powerRecordArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PropertyCell
        let entity = self.vm.powerRecordEntity.powerRecordArray[indexPath.row]
        
        cell.propertyTitleLabel.text = entity.categoryInfo
        cell.timeLabel.text = entity.time
        cell.numberLabel.text = "+\(entity.power)"
        cell.numberLabel.textColor = UIColor.rgbColor(from: 30, 98, 205)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
