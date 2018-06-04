//
//  AccountViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var accoundLabel: UILabel!
    var vm = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = JXF1f1f1Color
        
        //accoundLabel.text = UserManager.manager.userEntity.mobile
        logoutButton.layer.cornerRadius = 5
        //logoutButton.backgroundColor = JXGrayColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func logout(_ sender: Any) {
        
        self.vm.logout { (data, msg, isSuccess) in
            if isSuccess {
                self.navigationController?.popToRootViewController(animated: false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: false)
            }else {
                ViewManager.showNotice(msg)
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 80
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
        }else if indexPath.row == 1{
            //performSegue(withIdentifier: "modifyPassword", sender: nil)
        }else{
            
            performSegue(withIdentifier: "aboutUs", sender: nil)
        }
    }
}
