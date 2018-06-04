//
//  ArticleListController.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ArticleListController: UITableViewController {

    let vm = ArticleVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 11.0, *) {
//            self.tableView.contentInsetAdjustmentBehavior = .automatic
//            self.tableView.contentInset = UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0)//有tabbar时下为49，iPhoneX是88
//            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0)
//
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = false
//        }

        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
//        self.tableView.mj_header = MJRefreshHeader(refreshingBlock: {
//            //self.vm.loadNewMainData(completion: <#T##((Any?, String, Bool) -> ())##((Any?, String, Bool) -> ())##(Any?, String, Bool) -> ()#>)
//        })
//        self.tableView.mj_header.beginRefreshing()
        
        self.vm.dataArray = [1,1,1,1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.vm.dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ArticleCell

        cell.articleImageView.backgroundColor = UIColor.randomColor
        cell.articleTitleLabel.text = "标题"
        cell.articleTimeLabel.text = "2018-10-19"
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 2 {
            
            let inputTextView = JXInputTextView(frame: CGRect(x: 0, y: self.tableView.frame.height, width: view.bounds.width, height: 60), style: .hidden, completion:nil)
            inputTextView.sendBlock = { (_,object) in
                print("发送block",object)
            }
            inputTextView.limitWords = 1000
            inputTextView.placeHolder = "写下你的评论吧~~🌹🌹🌹"
            inputTextView.show()
        } else {
            self.performSegue(withIdentifier: "articleDetail", sender: nil)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
