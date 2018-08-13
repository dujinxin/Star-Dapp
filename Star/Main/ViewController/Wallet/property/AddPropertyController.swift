//
//  AddPropertyController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift

class AddPropertyController: UITableViewController {

    var dataArray = Array<WalletPropertyEntity>()
    var backBlock : ((_ entity:WalletPropertyEntity) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "AddPropertyCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        
        let entity = WalletPropertyEntity()
        entity.shortName = "ZC"
        entity.wholeName = "智慧币"
        entity.tokenAddress = "0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6"
        self.dataArray.append(entity)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! AddPropertyCell
        cell.selectionStyle = .none
        
        let entity = dataArray[indexPath.row]
        cell.entity = entity
        cell.clickBlock = {
            if let block = self.backBlock {
                block(entity)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let dict = dataArray[indexPath.row]
//        self.performSegue(withIdentifier: "walletDetail", sender: dict)
        
        
        guard
            let keystoreData = Data.init(base64Encoded: WalletManager.manager.walletEntity.keystore, options: .ignoreUnknownCharacters),
            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
                return
        }
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreStr) else {return }
        let keystoreManager = KeystoreManager.init([keystoreV3])
        WalletManager.manager.web3?.addKeystoreManager(keystoreManager)
        
        guard let ethereumAddress = EthereumAddress(WalletManager.manager.walletEntity.address) else {
            return
        }
        DispatchQueue.global().async {
            let balanceResult = WalletManager.manager.web3?.eth.getBalance(address: ethereumAddress)
            guard case .success(let balance)? = balanceResult else { return }
            print("balance = ",balance)
            DispatchQueue.main.async {
                let ether = EthUnit.weiToEther(wei: EthUnit.Wei(balance))
                print(ether)
            }
        }
        
    }

}
