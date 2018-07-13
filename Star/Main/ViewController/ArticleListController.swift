//
//  ArticleListController.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ArticleListController: JXTableViewController {

    let vm = ArticleVM()
    var page : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "智慧"

        self.tableView?.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.mj_header = MJRefreshHeader(refreshingBlock: {
            self.vm.articleList(pageNo: 1, completion: { (_, msg, isSuc) in
                self.tableView?.mj_header.endRefreshing()
                if isSuc {
                    self.tableView?.reloadData()
                } else {
                    ViewManager.showNotice(msg)
                }
            })
        })
        self.tableView?.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            //FIXME:先使用，成功后再加...待完善，看后台规则再定
            self.page += 1
            self.vm.articleList(pageNo: self.page, completion: { (_, msg, isSuc) in
                self.tableView?.mj_footer.endRefreshing()
                if isSuc {
                    self.tableView?.reloadData()
                } else {
                    ViewManager.showNotice(msg)
                }
            })
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

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.vm.dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ArticleCell

        let entity = self.vm.dataArray[indexPath.row] as! ArticleEntity
        cell.entity = entity
        // Configure the cell...

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = self.vm.dataArray[indexPath.row] as! ArticleEntity
        self.performSegue(withIdentifier: "articleDetail", sender: entity)
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
