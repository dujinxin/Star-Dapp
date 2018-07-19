//
//  SubRecordController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
enum SubType {
    case whole
    case comeIn
    case payOut
}

class SubRecordController: JXTableViewController{
    
    var vm = HomeVM()
    var type : SubType = .whole
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: kScreenHeight - kNavStatusHeight)
        //self.tableView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: kScreenHeight - kNavStatusHeight - 44)//view.bounds
        self.tableView?.register(UINib(nibName: "PropertyCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        if type != .payOut {
            self.tableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
                self.page = 1
                self.vm.propertyRecord(pageNo: self.page) { (_, msg, isSuc) in
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
                self.vm.propertyRecord(pageNo: self.page) { (_, msg, isSuc) in
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.propertyRecordEntity.coinRecord.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PropertyCell
        let entity = self.vm.propertyRecordEntity.coinRecord[indexPath.row]
        
        cell.propertyTitleLabel.text = entity.categoryInfo
        cell.timeLabel.text = entity.time
        cell.numberLabel.text = "+\(entity.ipe)IPE"
        cell.numberLabel.textColor = UIColor.rgbColor(from: 4, 187, 103)
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
