//
//  ZPTableViewController.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/1.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
//import MJRefresh
import MBProgressHUD

class ZPTableViewController: UITableViewController {

    //MARK: - custom NavigationBar
    //自定义导航栏
    lazy var customNavigationBar : JXNavigationBar = {
        let navigationBar = JXNavigationBar(frame:CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight))
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .blackTranslucent
        navigationBar.barTintColor = UIColor.orange//导航条颜色
        navigationBar.tintColor = UIColor.white //item图片文字颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)]//标题设置
        return navigationBar
    }()
    lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem()
        return item
    }()
    //重写title的setter方法
    override var title: String?{
        didSet {
            customNavigationItem.title = title
        }
    }
    var pageCount : Int = 1
    
    var backBlock : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let image = UIImage(named: "nav_back")
//        self.navigationController?.navigationBar.backIndicatorImage = image
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image?.withRenderingMode(.alwaysOriginal)
//        self.navigationItem.leftItemsSupplementBackButton = false;
//        let backBarButtonItem = UIBarButtonItem.init(title:"", style: .plain, target: nil, action: nil)
//        self.navigationItem.backBarButtonItem = backBarButtonItem
////        self.navigationController?.navigationBar.barTintColor = JXMainColor//导航条颜色
//        self.navigationController?.navigationBar.tintColor = JX333333Color //item图片文字颜色
////        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white/*,NSFontAttributeName:UIFont.systemFont(ofSize: 19)*/]//标题设置
        
        
        setCustomNavigationBar()
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: view.bounds.height - kNavStatusHeight)
        
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
            self.tableView?.contentInset = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)//有tabbar时下为49，iPhoneX是88
            self.tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


}
extension ZPTableViewController {
    func setCustomNavigationBar() {
        //隐藏navigationBar
        //1.自定义view代替NavigationBar,需要自己实现手势返回;
        //2.自定义navigatioBar代替系统的，手势返回不用自己实现
        view.addSubview(customNavigationBar)
        customNavigationBar.items = [customNavigationItem]
        
    }
}
extension ZPTableViewController {
    func showMBProgressHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.backgroundView.color = UIColor.black
        //        hud.contentColor = UIColor.black
        //        hud.bezelView.backgroundColor = UIColor.black
        //        hud.label.text = "加载中..."
        
    }
    func hideMBProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    /// request data
    func requestData() {
        
    }
    
    /// request data
    ///
    /// - Parameter withPage: load data for page,
    func request(with page:Int) {
        
    }
}
