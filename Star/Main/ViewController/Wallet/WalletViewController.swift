//
//  WalletViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/31.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import BigInt

class WalletViewController: JXTableViewController {
    @IBOutlet weak var defaultBackView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var count : Int = 0
    var propertyArray = Array<WalletPropertyEntity>()
    
    var prise : Double = 0
    var totalWorth : Double = 0
    
    var vm : Web3VM!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: self.createButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.createButton.layer.insertSublayer(gradientLayer, at: 0)
        self.createButton.backgroundColor = UIColor.clear
        
        
        
        self.tableView?.register(UINib.init(nibName: "WalletHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHead")
        self.tableView?.register(UINib.init(nibName: "PropertyViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView?.estimatedRowHeight = 70
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.isScrollEnabled = false
        self.tableView?.separatorStyle = .none

        self.resetMainView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 84
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "transfer":
            if let vc = segue.destination as? TransferViewController {
                vc.propertyArray = self.propertyArray
            }
        case "checkWallet":
            if let vc = segue.destination as? BackUpController {
                vc.isBackUp = false
                vc.callBack = {
                    self.resetMainView()
                }
            }
        default:
            print("")
        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    func resetMainView() {
        if WalletManager.manager.isWalletExist == true {
            self.title = WalletManager.manager.walletEntity.name
            self.defaultBackView.isHidden = true
            self.tableView?.isHidden = false
            
            self.requestData()
            
        } else {
            self.title = "钱包"
            self.defaultBackView.isHidden = false
            self.tableView?.isHidden = true
        }
    }
    override func requestData() {
        
        self.showMBProgressHUD()
        self.count = 2
        self.fetchData(count: count) {
            if self.count == 0 {
                self.hideMBProgressHUD()
            }
            self.tableView?.reloadData()
        }
        
    }
    func fetchData(count: Int, completion: @escaping (()->())) {
        self.propertyArray.removeAll()
        self.totalWorth = 0
        for i in 0..<count {
            self.dataInit(index: i, total: count, completion: completion)
        }
    }
    func dataInit(index: Int, total: Int, completion: @escaping (()->())) {
        let entity = WalletPropertyEntity()
        
        self.vm = Web3VM.init(keystoreBase64Str: WalletManager.manager.walletEntity.keystore)
        guard let walletAddress = EthereumAddress(WalletManager.manager.walletEntity.address) else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        //1
        if index == 0 { //eth
            DispatchQueue.global().async {
                let balanceResult = self.vm.web3.eth.getBalance(address: walletAddress)
                guard case .success(let balance) = balanceResult else { return }
                print("balance = ",balance)
                DispatchQueue.main.async {
                    entity.shortName = "ETH"
                    entity.wholeName = "Ethereum"
                    entity.tokenAddress = "0x0000000000000000000000000000000000000000"
                    entity.image = "eth"
                    entity.coinNum = balance
                }
                group.leave()
                print("\(index)-\(index)")
            }
        } else { // token
            let contractAddress = EthereumAddress("0x8553de7f3ce4993adbf02b0d676e4be4c5333398")! // BKX token on Ethereum mainnet
            let contract = self.vm.web3.contract(Web3.Utils.erc20ABI, at: contractAddress, abiVersion: 2)! // utilize precompiled ERC20 ABI for your concenience
            DispatchQueue.global().async {
                guard let bkxBalanceResult = contract.method("balanceOf", parameters: [walletAddress] as [AnyObject], options: Web3Options.defaultOptions())?.call(options: nil) else {return} // encode parameters for transaction
                guard case .success(let bkxBalance) = bkxBalanceResult, let bal = bkxBalance["0"] as? BigUInt else {return} // bkxBalance is [String: Any], and parameters are enumerated as "0", "1", etc in order of being returned. If returned parameter has a name in ABI, it is also duplicated
                print(bkxBalance)
                print("BKX token balance = " + String(bal))
                
                DispatchQueue.main.async {
                    
                    entity.shortName = "IPE"
                    entity.wholeName = "Ipxe"
                                         //0x8553de7f3ce4993adbf02b0d676e4be4c5333398
                    entity.tokenAddress = "0x8553de7f3ce4993adbf02b0d676e4be4c5333398"
                    entity.image = "IPE"
                    entity.coinNum = bal
                    entity.prise = 1
                    
                }
                print("\(index)-\(index)")
                group.leave()
            }
        }
        
        //2
        if index == 0 {
            group.enter()
            let vm = Web3Request()
            vm.getETHPrise { (prise, msg, isSuc) in
                print(prise)
                entity.prise = prise
                
                self.prise = prise
                group.leave()
                print("\(index)-\(index + 1)")
            }
        } else {
            //token暂时不提供价格查询，以1元为基准计算
            print("\(index)-\(index + 1)")
        }
        
        
        //3
        group.notify(queue: DispatchQueue.main) {
            print("\(index)-\(index + 2)")
            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
            let priseDecimal = Decimal.init(entity.prise)
            let worth = ether * priseDecimal
            if let worthDouble = Double(worth.description) {
                entity.CNY = String(format: "%0.2f", worthDouble)
                self.totalWorth += worthDouble
            }
            self.propertyArray.append(entity)
            self.count -= 1
            completion()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.propertyArray.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHead", for: indexPath) as! WalletHeadCell
            cell.accessoryType = .none
            let s = String(format: "%0.2f", self.totalWorth)
            cell.totalNumberLabel.text = "≈￥\(s)"
            cell.transferBlock = {
                self.performSegue(withIdentifier: "transfer", sender: nil)
            }
            cell.receiptBlock = {
                self.performSegue(withIdentifier: "receipt", sender: nil)
            }
            cell.checkBlock = {
                self.performSegue(withIdentifier: "checkWallet", sender: false)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! PropertyViewCell
            let entity = self.propertyArray[indexPath.row - 1]

            cell.coinImagView.image = UIImage(named: entity.image!)
            cell.coinNameLabel.text = entity.shortName
            cell.coinLongNameLabel.text = entity.wholeName
            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
            cell.coinNumberLabel.text = "\(EthUnit.decimalNumberHandler(ether))"
            //cell.coinNumberLabel.text = String.init(format: "%.4f", ether as CVarArg) //"\(ether)"
            cell.worthLabel.text = "≈￥" + entity.CNY
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
