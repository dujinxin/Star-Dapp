//
//  MyViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController {

    var dataArray = [["image":"property","title":"我的资产"],["image":"wallet","title":"我的钱包"],["image":"property","title":"实名信息"],["image":"account","title":"账户信息"]]
    
    
    var vm = LoginVM()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = JXF1f1f1Color
        
        //self.nickNameLabel.text = UserManager.manager.userEntity.nickname
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func edit(_ sender: UIButton) {
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=login&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        
        self.userImageView.sd_setImage(with: url, completed: nil)
        print(url)
        return
        
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
                    self.nickNameLabel.text = text
                })
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                //performSegue(withIdentifier: "property", sender: nil)
                performSegue(withIdentifier: "property_web", sender: nil)
            }else if indexPath.row == 1{
                //performSegue(withIdentifier: "myWallet", sender: nil)
                performSegue(withIdentifier: "myWallet_web", sender: nil)
            }else if indexPath.row == 2{
                performSegue(withIdentifier: "personInfo", sender: nil)
            }else{
                performSegue(withIdentifier: "accound", sender: nil)
            }
        }
    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 260
//    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let contentView = UIView()
//        contentView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 250)
//        contentView.backgroundColor = JXFfffffColor
//
//        let imageView = UIImageView()
//        imageView.frame = CGRect(x: (kScreenWidth - 64.0) / 2, y: 25, width: 64, height: 64)
//        imageView.isUserInteractionEnabled = true
//        imageView.backgroundColor = UIColor.randomColor
//        contentView.addSubview(imageView)
//
//
//        let titleLabel = UILabel()
//        titleLabel.frame = CGRect.init(x: 15, y: imageView.jxBottom + 15, width: view.frame.width - 30, height: 44)
//        titleLabel.text = "昵称"
//        titleLabel.font = UIFont.systemFont(ofSize: 14)
//        titleLabel.textAlignment = .center
//        titleLabel.textColor = JX666666Color
//
//        contentView.addSubview(titleLabel)
//
//        return contentView
//
//    }
}
