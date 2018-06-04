//
//  PersonInfoViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PersonInfoViewController: UITableViewController {
    
    @IBOutlet weak var accoundLabel: UILabel!
    @IBOutlet weak var iDcardLabel: UILabel!
    
    var vm = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = JXF1f1f1Color
        
       
        self.vm.personInfo { (data, msg, isSuccess) in
            if isSuccess == false {
                ViewManager.showNotice(msg)
            }else {
                //self.accoundLabel.text = UserManager.manager.userEntity.name
                //self.iDcardLabel.text = UserManager.manager.userEntity.idCard
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
        
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
//        if indexPath.section == 1 {
//            tableView.deselectRow(at: indexPath, animated: true)
//            if indexPath.row == 0 {
//
//            }else if indexPath.row == 1{
//                performSegue(withIdentifier: "AboutUs", sender: nil)
//            }else{
//                performSegue(withIdentifier: "modifyPassword", sender: nil)
//            }
//        }
    }
}
