//
//  TabBarViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button = UIButton(type: .custom)
        //button.backgroundColor = UIColor.red
        
        //button.frame = tabBar.frame.insetBy(dx: 2 * (tabBar.bounds.width / (CGFloat(childViewControllers.count) - 1)), dy: 0)
        button.frame = CGRect(x: 2 * tabBar.bounds.width / CGFloat(childViewControllers.count), y: 0, width: tabBar.bounds.width / CGFloat(childViewControllers.count), height: tabBar.bounds.height)
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        tabBar.addSubview(button)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarStatus(notify:)), name: NSNotification.Name(rawValue: NotificationTabBarHiddenStatus), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationLocatedStatus), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationTabBarHiddenStatus), object: nil)
    }

    @objc func buttonClick() {

        //GDLocationManager.manager.startUpdateLocation()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scan = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
        let scanVC = UINavigationController.init(rootViewController: scan)
        
        self.present(scanVC, animated: false, completion: nil)
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            
        }else{
            UserManager.manager.removeAccound()
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            if self.selectedViewController is UINavigationController {
                let selectVC = self.selectedViewController as! UINavigationController
                let topVC = selectVC.topViewController
                if let modelVC = topVC?.navigationController?.visibleViewController {
                    modelVC.dismiss(animated: false, completion: nil)
                }
                topVC?.navigationController?.popToRootViewController(animated: false)
                topVC!.navigationController?.present(loginVC, animated: true, completion: nil)
            }else{
                self.selectedViewController?.navigationController?.present(login, animated: true, completion: nil)
            }
            
            //self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func tabBarStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.tabBar.isHidden = true
        }else{
            self.tabBar.isHidden = false
        }
    }

}
