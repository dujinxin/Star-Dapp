//
//  TransferViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift

import BigInt

enum Type : Int{
    case eth
    case erc20
}

class TransferViewController: UITableViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var remarkTextField: UITextField!
    @IBOutlet weak var gasSlider: UISlider!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tradeButton: UIButton!
    
    let address1 = "0xc166ca53567b84f5bdf3bd42b74106ebec574cfe"
    let address2 = "0x3D971de18eA1aa15087e612d8f0D16199380563a"
    
    var gasPrise : BigUInt = 0
    
    var type : Type = .eth
    
    lazy var vm1: Web3VM = {
        let vm = Web3VM.init(keystoreBase64Str: WalletManager.manager.walletEntity.keystore)//自己的钱包
        return vm
    }()
    lazy var vm2: Web3VM = {
        let vm = Web3VM.init(keystoreData: WalletManager.manager.getKeystoreData()!)      //测试钱包
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        ///以太坊节点：192.168.0.129，rpcport：8545
        ///IPT合约地址：0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6
        
        //钱包地址：0xc166ca53567b84f5bdf3bd42b74106ebec574cfe
        //钱包密钥：123456
        
        self.addressTextField.text = WalletManager.manager.walletEntity.address
        self.numberTextField.text = "0.000000000000001"
        
        self.gasSlider.minimumValue = 252  // 0.0000252
        self.gasSlider.maximumValue = 25200//0.0025200
        //self.gasSlider.
        self.gasSlider.value = 252//0.0000252
        
        self.gasLabel.text = "\(self.gasSlider.minimumValue / 10000000) ether"
        
        self.web3KitGetBalance()
        
        DispatchQueue.global().async {
            guard case .success(let gasPriceRinkeby) = self.vm1.web3.eth.getGasPrice() else {return}
            print("web3?.eth.getGasPrice() = ",gasPriceRinkeby)
            self.gasPrise = gasPriceRinkeby
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func transactionCosts(_ sender: UISlider) {
        self.gasLabel.text = "\(sender.value / 10000000) ether"
    }
    @IBAction func next(_ sender: Any) {
        let alertVC = UIAlertController(title: nil, message: "请输入密码", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.text = "123456"
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            
            
            if
                let textField = alertVC.textFields?[0],
                let text = textField.text,
                text.isEmpty == false{
                
                
                if self.type == .eth {
                    self.sendEth(text)
                } else {
                    self.sendERC20Token(text)
                }
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func tradeRecord(_ sender: Any) {
        //WalletManager.manager.web3?.eth.getTransactionDetails(<#T##txhash: String##String#>)
        
    }

    func web3KitGetBalance() {
        
        if self.type == .eth {
            let address = EthereumAddress(WalletManager.manager.walletEntity.address)
            //let address = EthereumAddress(self.address1)
            DispatchQueue.global().async {
                let balanceResult = self.vm1.web3.eth.getBalance(address: address!)
                guard case .success(let balance) = balanceResult else { return }
                print("balance = ",balance)
            }
        } else {
            //let address = EthereumAddress(self.address1)
            let address = EthereumAddress(WalletManager.manager.walletEntity.address)
            let contractAddress = EthereumAddress("0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6")! // BKX token on Ethereum mainnet
            let contract = self.vm2.web3.contract(Web3.Utils.erc20ABI, at: contractAddress, abiVersion: 2)! // utilize precompiled ERC20 ABI for your concenience
            DispatchQueue.global().async {
                guard let bkxBalanceResult = contract.method("balanceOf", parameters: [address] as [AnyObject], options: Web3Options.defaultOptions())?.call(options: nil) else {return} // encode parameters for transaction
                guard case .success(let bkxBalance) = bkxBalanceResult, let bal = bkxBalance["0"] as? BigUInt else {return} // bkxBalance is [String: Any], and parameters are enumerated as "0", "1", etc in order of being returned. If returned parameter has a name in ABI, it is also duplicated
                print(bkxBalance)
                print("BKX token balance = " + String(bal))
            }
        }
    }
    func sendEth(_ psd:String) {
        guard let address = self.addressTextField.text else { return }
        guard let number = self.numberTextField.text else { return }
        guard let remark = self.remarkTextField.text else { return }
        guard let gas = self.gasLabel.text else { return }
        
        print(address,number,remark,gas)
        //self.testMethod()

        var options = Web3Options.init()  //Web3Options.defaultOptions()
        // public var to: EthereumAddress? = nil - to what address transaction is aimed
        // public var from: EthereumAddress? = nil - form what address it should be sent (either signed locally or on the node)
        // public var gasLimit: BigUInt? = BigUInt(90000) - default gas limit
        // public var gasPrice: BigUInt? = BigUInt(5000000000) - default gas price, quite small
        // public var value: BigUInt? = BigUInt(0) - amount of WEI sent along the transaction
        options.gasPrice = self.gasPrise // BigUInt("5000000000", radix: 10)!
        let v = Int(self.gasSlider.value)
        
        let ether = EthUnit.Ether(Double(v) / Double(10000000))
        let wei = EthUnit.etherToWei(ether: ether)
        
        let gasLimit = BigUInt(wei) / self.gasPrise
        options.gasLimit = BigUInt(gasLimit) // BigUInt(21000) // BigUInt(90000)
        options.from = EthereumAddress(self.address1)
        options.to = EthereumAddress(address)
        //options.value = Web3.Utils.parseToBigUInt("1.0", units: .eth)
        
        print(ether,wei,gasLimit)
  
        DispatchQueue.global().async {
            //let intermediate = web3?.contract(Web3.Utils.coldWalletABI, at: EthereumAddress(address), abiVersion: 2)?.method(options: options)
            guard let intermediate = self.vm2.web3.eth.sendETH(from: EthereumAddress(self.address1)!, to: EthereumAddress(address)!, amount: number) else {return}
            
            //web3?.eth.sendETH(to: EthereumAddress("0x50d2cf603b4fa3107396fa49ac01469a3aaf0f79")!, amount: "0.001")
            //guard let intermediate = web3?.eth.sendETH(to: EthereumAddress("0x50d2cf603b4fa3107396fa49ac01469a3aaf0f79")!, amount: "0.001") else {return}
            
            let result = intermediate.send(password: psd, options: options)
            
            //options.from = allAddresses[0]
            //let intermediate = contract?.method("fallback", options: options)
            //guard let result = intermediate?.send(password: "123456") else {return}
            switch result {
            case .success(let res):
                print(res.hash)
//                let result1 = WalletManager.manager.web3?.eth.getTransactionDetails(res.hash)
//                switch result1 {
//                case .success(let r)?:
//                    print(r)
//                    return
//                case .failure(let err)?:
//                    print(err)
//                case .none:
//                    print("none")
//                }
                self.web3KitGetBalance()
                return
            case .failure(let error):
                print(error)
            }
        }
 
//        web3?.eth.getTransactionCount(address: EthereumAddress(address1)!, callback: { (result) in
//            switch result {
//            case .success(let nouce):
//                print(nouce)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        })
        
        //testSendETH()
    }
    func sendERC20Token(_ psd:String) {
        guard let address = self.addressTextField.text else { return }
        guard let number = self.numberTextField.text else { return }
        guard let remark = self.remarkTextField.text else { return }
        guard let gas = self.gasLabel.text else { return }
        
        print(address,number,remark,gas)
//        var decimals = BigUInt(0)
//        let intDecimals = Int(decimals)
//        guard let value = Web3.Utils.parseToBigUInt("0.00001", decimals: intDecimals) else {return}
//
        var options = Web3Options.init()  //Web3Options.defaultOptions()
        options.gasPrice = self.gasPrise // BigUInt("5000000000", radix: 10)!
        let v = Int(self.gasSlider.value)
        
        let ether = EthUnit.Ether(Double(v) / Double(10000000))
        let wei = EthUnit.etherToWei(ether: ether)
        
        let gasLimit = BigUInt(wei) / self.gasPrise
        //options.gasLimit = BigUInt(gasLimit) // BigUInt(21000) // BigUInt(90000)
//        options.gasLimit = BigUInt(21000) // BigUInt(90000)
//        options.from = EthereumAddress(self.address1)
//        options.to = EthereumAddress(address)
        //options.value = Web3.Utils.parseToBigUInt("10", units: .eth)
        options.value = BigUInt(0)
        print(ether,wei,gasLimit)
        
//        guard let keystoreData = WalletManager.manager.getKeystoreData() else {return}
//        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreData) else {return}
//        let privateKey = try! keystoreV3.UNSAFE_getPrivateKeyData(password: "123456", account: EthereumAddress("0xc166ca53567b84f5bdf3bd42b74106ebec574cfe")!).toHexString()
//        print("privateKey = ",privateKey)
        
        DispatchQueue.global().async {
            let convenienceTokenTransfer = self.vm2.web3.eth.sendERC20tokensWithNaturalUnits(tokenAddress: EthereumAddress("0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6")!, from: EthereumAddress(self.address1)!, to: EthereumAddress(address)!, amount: "0.1", options: options)
            let gasEstimateResult2 = convenienceTokenTransfer!.estimateGas(options: nil)
            guard case .success(let gasEstimate2) = gasEstimateResult2 else {return}
            options.gasLimit = gasEstimate2
            let convenienceTransferResult = convenienceTokenTransfer!.send(password: psd, options: options)
            switch convenienceTransferResult {
            case .success(let res):
                print("Token transfer successful = ",convenienceTransferResult.value)
                print(res)
            case .failure(let error):
                print(error)
            }
        }
        
        
        
//        DispatchQueue.global().async {
//            guard let intermediate = WalletManager.manager.web3?.eth.sendETH(from: EthereumAddress(self.address1)!, to: EthereumAddress(address)!, amount: number) else {return}
//
//            let result = intermediate.send(password: psd, options: options)
//
//            switch result {
//            case .success(let res):
//                print(res.hash)
//                self.web3KitGetBalance()
//                return
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    func testMethod() {

        DispatchQueue.global().async {
            guard case .success(let allAddresses)? = WalletManager.manager.web3?.wallet.getAccounts() else {return}
            print("web3?.wallet.getAccounts() = ",allAddresses)
        }
        DispatchQueue.global().async {
            guard case .success(let allAddresses)? = WalletManager.manager.web3?.wallet.getCoinbase() else {return}
            print("web3?.wallet.getCoinbase() = ",allAddresses)
        }
        DispatchQueue.global().async {
            guard case .success(let allAddresses)? = WalletManager.manager.web3?.eth.getAccounts() else {return}
            print("web3?.eth.getAccounts() = ",allAddresses)
        }
        DispatchQueue.global().async {
            guard case .success(let gasPriceRinkeby)? = WalletManager.manager.web3?.eth.getGasPrice() else {return}
            print("web3?.eth.getGasPrice() = ",gasPriceRinkeby)
        }
        DispatchQueue.global().async {
            guard let gasPriceRinkeby = WalletManager.manager.web3?.eth.getAccountsPromise() else {return}
            
            print("web3?.eth.getAccountsPromise() = ",gasPriceRinkeby)
        }
    }
    
    
    func testSendETH() {
        guard let keystoreData = WalletManager.manager.getKeystoreData() else {return}
        //guard let keystoreV3 = BIP32Keystore.init(keystoreData) else {return}
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreData) else {return}
        let web3Rinkeby = Web3.new(URL(string: "http://192.168.0.129:8545")!)
        let keystoreManager = KeystoreManager.init([keystoreV3])
        web3Rinkeby?.addKeystoreManager(keystoreManager)
        guard case .success(let gasPriceRinkeby)? = web3Rinkeby?.eth.getGasPrice() else {return}
        let sendToAddress = EthereumAddress(WalletManager.manager.walletEntity.address)!
        guard let intermediate = web3Rinkeby?.eth.sendETH(to: sendToAddress, amount: "0.001") else {return}
        var options = Web3Options.defaultOptions()
        if keystoreV3.addresses?.first != nil{
            options.from = keystoreV3.addresses?.first
        } else {
           // options.from =
        }
        
        options.gasPrice = gasPriceRinkeby
        let result = intermediate.send(password: "123456", options: options)
        switch result {
        case .success(let res):
            print(res)
        case .failure(let error):
            print(error)
        }
    }
    
}

//林更新，种地，豆腐乳，海草，中根，
