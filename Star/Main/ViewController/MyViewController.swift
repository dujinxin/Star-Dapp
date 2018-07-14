//
//  MyViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MyViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var dataArray = [["image":"iconMoney","title":"水晶IPE"],["image":"iconPocket","title":"钱包"],["image":"iconPerson","title":"实名"],["image":"iconGear","title":"系统"]]
    
    var vm = LoginVM()
    @IBOutlet weak var tableView: UITableView!
    
    var nickName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
            self.tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier1")
        self.tableView.register(UINib(nibName: "ImageTitleCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier2")
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.isScrollEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        } else {
            self.vm.personInfo { (data, msg, isSuccess) in
                if isSuccess == true {
                    self.tableView.reloadData()
                } else {
                    ViewManager.showNotice(msg)
                }
            }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accound" {
            if let vc = segue.destination as? AccountViewController,let mobile = sender as? String {
                vc.mobile = mobile
            }
        }
    }
    @IBAction func edit(_ sender: UIButton) {

        let alertVC = UIAlertController(title: "修改昵称", message: nil, preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            //textField.text = UserManager.manager.userEntity.nickname
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            if
                let textField = alertVC.textFields?[0],
                let text = textField.text,
                text.isEmpty == false{
                
                self.vm.modify(nickName: text, completion: { (_, msg, isSuccess) in
                    ViewManager.showNotice(msg)
                    self.vm.profileInfoEntity?.nickname = text
                    self.tableView.reloadData()
                })
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        if indexPath.row == 0 {
            return 200 + kNavStatusHeight
        } else {
            return 64
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier1", for: indexPath) as! MyCell
            if let str = self.vm.profileInfoEntity?.avatar {
                let url = URL.init(string:str)
                cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "portrait_default"), options: [], completed: nil)
                //cell.userImageView.sd_setImage(with: url, completed: nil)
            }
            cell.nickNameLabel.text = self.vm.profileInfoEntity?.nickname
            cell.editButton.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
            cell.rankLabel.text = "智慧星球第\(self.vm.profileInfoEntity?.rank ?? 0)位居民"
            cell.modifyBlock = {
                let storyboard = UIStoryboard(name: "Task", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ModifyImageVC") as! ModifyImageController
                vc.hidesBottomBarWhenPushed = true
                
                vc.avatar = self.vm.profileInfoEntity?.avatar
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier2", for: indexPath) as! ImageTitleCell
            let dict = dataArray[indexPath.row - 1]
            
            cell.iconView.image = UIImage(named: dict["image"]!)
            cell.titleView.text = dict["title"]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            performSegue(withIdentifier: "property", sender: nil)

//                let storyboard = UIStoryboard(name: "Task", bundle: nil)
//                let login = storyboard.instantiateViewController(withIdentifier: "TaskVC") as! TaskViewController
//            self.navigationController?.pushViewController(login, animated: true)
            
        }else if indexPath.row == 2{
            ViewManager.showNotice("敬请期待")
            //performSegue(withIdentifier: "myWallet", sender: nil)
            //performSegue(withIdentifier: "myWallet_web", sender: nil)
        }else if indexPath.row == 3{
            performSegue(withIdentifier: "personInfo", sender: nil)
        }else if indexPath.row == 4{
            performSegue(withIdentifier: "accound", sender: self.vm.profileInfoEntity?.mobile)
        }
    }
}
