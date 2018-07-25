//
//  PaperDetailController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PaperDetailController: JXTableViewController {
    
    let vm = PaperVM()
    
    var id : Int = 0
    
    var process : String = "0/0"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "论文"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        
        self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 44
        //self.tableView?.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: self.page)
        })
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            //FIXME:先使用，成功后再加...待完善，看后台规则再定
            self.page += 1
            self.request(page: self.page)
        })
        self.tableView?.mj_header.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    override func request(page: Int) {
        self.vm.paperDetails(self.id) { (_, msg, isSuc) in
            if page == 1 {
                self.tableView?.mj_header.endRefreshing()
            } else {
                self.tableView?.mj_footer.endRefreshing()
            }
            
            if isSuc {
                self.tableView?.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let entity = self.vm.paperDetailEntity
        //cell.entity = entity
        // Configure the cell...
        
        if indexPath.row == 0 {
            cell.textLabel?.text = entity.title
        } else if indexPath.row == 1 {
            cell.textLabel?.text = entity.author
        } else if indexPath.row == 2 {
            cell.textLabel?.text = entity.downloadUrl
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "购买"
        } else {
            cell.textLabel?.text = "下载"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 3 {
            //购买
            self.vm.paperTrade(self.id) { (_, msg, isSuc) in
                ViewManager.showNotice(msg)
                if isSuc {
                    self.request(page: 1)
                }
            }
        } else if indexPath.row == 4 {
            //下载
            self.vm.paperDownload(self.vm.paperDetailEntity.downloadUrl!, process: { (progress) in
                print(progress.completedUnitCount,"/",progress.totalUnitCount)
            }) { (isSuc) in
                print("download ",isSuc)
            }
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if let entity = sender as? ArticleEntity, identifier == "articleDetail" {
            let vc = segue.destination as! ArticleDetailsController
            vc.articleEntity = entity
        }
    }
    
}
