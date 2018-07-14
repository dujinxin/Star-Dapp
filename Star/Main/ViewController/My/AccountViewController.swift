//
//  AccountViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class AccountViewController: JXTableViewController{
    
    var vm = LoginVM()
    var mobile : String = ""
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 30, y: 0, width: 200, height: 44)
        button.layer.cornerRadius = 5
        button.setTitle("退出登录", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "系统设置"
        
        self.tableView?.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.isScrollEnabled = false
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: 60 * 3)
        self.view.addSubview(self.logoutButton)
        self.logoutButton.frame = CGRect(x: 30, y: (self.tableView?.jxBottom)! + 80, width: kScreenWidth - 30 * 2, height: 44)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: logoutButton.jxWidth, height: logoutButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.logoutButton.layer.addSublayer(gradientLayer)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PersonCell
        if indexPath.row == 0 {
            cell.leftLabel.text = "手机账号"
            cell.rightLabel.text = self.mobile
        } else if indexPath.row == 1 {
            cell.leftLabel.text = "关于我们"
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.leftLabel.text = "版本信息"
            cell.rightLabel.text = kVersion
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 1{
            performSegue(withIdentifier: "AboutUs", sender: nil)
        }else{
            //performSegue(withIdentifier: "modifyPassword", sender: nil)
        }
    }
    
    @objc func logout(_ sender: Any) {
        
        self.vm.logout { (data, msg, isSuccess) in
            if isSuccess {
                self.navigationController?.popToRootViewController(animated: false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: false)
            }else {
                ViewManager.showNotice(msg)
            }
        }
        
    }
}
