//
//  SettingViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    lazy var vm: Web3VM = {
        let vm = Web3VM.init(keystoreBase64Str: WalletManager.manager.walletEntity.keystore)//自己的钱包
        return vm
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "walletList", sender: nil)
        } else {
            
           // self.vm.web3?.eth.getTransactionDetails(<#T##txhash: String##String#>)

        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
