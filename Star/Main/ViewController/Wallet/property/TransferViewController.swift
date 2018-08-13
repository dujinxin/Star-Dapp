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

class TransferViewController: BaseViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var remarkTextField: UITextField!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var gasSlider: UISlider!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var tradeButton: UIButton!
    
    var propertyArray = Array<WalletPropertyEntity>()
    var currentEntity : WalletPropertyEntity?
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "scanIcon"), for: .normal)
        //leftButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 12, 24)
        leftButton.addTarget(self, action: #selector(goScan), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: leftButton)
        return item
    }()
    lazy var actionView: JXActionView = {
        let v = JXActionView.init(tableViewCell: "JXActionCell", isNib: true)
//        let v = JXActionView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 300), style: .list)
        v.delegate = self
        v.dataSource = self
        v.actions = ["1","2"]
        v.topBarView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 60))
            view.backgroundColor = JX999999Color
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 59.5)
            label.backgroundColor = UIColor.white
            //label.center = view.center
            label.text = "选择"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JX333333Color
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 8.5, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(dismissCoin), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        return v
    }()
    

    var gasPrise : BigUInt = 0
    var password : String?
    var type : Type = .eth
    
    lazy var vm: Web3VM = {
        let vm = Web3VM.init(keystoreBase64Str: WalletManager.manager.walletEntity.keystore)//自己的钱包
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "转账"
        
        self.customNavigationItem.rightBarButtonItem = self.rightBarButtonItem
        ///以太坊节点：192.168.0.129，rpcport：8545
        ///IPT合约地址：0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6
        
        //钱包地址：0xc166ca53567b84f5bdf3bd42b74106ebec574cfe
        //钱包密钥：123456
        
        self.categoryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCoin)))
        
        //self.addressTextField.text = WalletManager.manager.walletEntity.address
        //self.numberTextField.text = "0.000000000000001"
        
        
        self.gasSlider.minimumValue = 25200    // 0.0000252   //21000 * 12 / Gwei
        self.gasSlider.maximumValue = 2520000  //0.0025200
        //self.gasSlider.
        self.gasSlider.value = 42000           //0.000042     //21000 * 2
        
        self.gasLabel.text = "\(self.gasSlider.value / 1000000000) ether"
        
        //bec4df  3b4368
        
        
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: self.tradeButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.tradeButton.layer.insertSublayer(gradientLayer, at: 0)
        self.tradeButton.backgroundColor = UIColor.clear
        
        
        self.requestData()
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
        self.topConstraint.constant = kNavStatusHeight
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TransferSuccessController {
            vc.address = self.addressTextField.text
            vc.name = self.currentEntity?.shortName
            vc.number = self.numberTextField.text
        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    override func requestData() {

        if self.type == .eth {
            DispatchQueue.global().async {
                guard case .success(let gasPriceRinkeby) = self.vm.web3.eth.getGasPrice() else {return}
                print("web3?.eth.getGasPrice() = ",gasPriceRinkeby)
                self.gasPrise = gasPriceRinkeby
            }
        } else {
            DispatchQueue.global().async {
                guard case .success(let gasPriceRinkeby) = self.vm.web3.eth.getGasPrice() else {return}
                print("web3?.eth.getGasPrice() = ",gasPriceRinkeby)
                self.gasPrise = gasPriceRinkeby
            }
        }
        
    }
    @objc func goScan() {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
        vc.hidesBottomBarWhenPushed = true
        vc.callBlock = { (address) in
            self.addressTextField.text = address
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func selectCoin() {
        self.view.endEditing(true)
        self.actionView.show()
    }
    @objc func dismissCoin() {
        self.actionView.dismiss()
    }
    @IBAction func transactionCosts(_ sender: UISlider) {
        //value / Gwei
        self.gasLabel.text = "\(sender.value / 1000000000) ether"
    }
    @IBAction func tradeAction(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let _ = self.currentEntity else {
            ViewManager.showNotice("请先选择币种")
            return
        }
        guard let number = self.numberTextField.text, number.isEmpty == false  else {
            ViewManager.showNotice("请填写转账数量")
            return
        }
        guard let address = self.addressTextField.text, address.isEmpty == false else {
            ViewManager.showNotice("请填写收款人地址")
            return
        }
        
        let alertVC = UIAlertController(title: nil, message: "请输入密码", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "password"
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            
            
            if
                let textField = alertVC.textFields?[0],
                let text = textField.text,
                text.isEmpty == false{
                
                self.password = text
                
                self.showBottomView()
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

    func web3KitGetBalance() {
        
        if self.type == .eth {
            let address = EthereumAddress(WalletManager.manager.walletEntity.address)
            DispatchQueue.global().async {
                let balanceResult = self.vm.web3.eth.getBalance(address: address!)
                guard case .success(let balance) = balanceResult else { return }
                print("balance = ",balance)
            }
        } else {
            let address = EthereumAddress(WalletManager.manager.walletEntity.address)
            let contractAddress = EthereumAddress("0x8553de7f3ce4993adbf02b0d676e4be4c5333398")! // BKX token on Ethereum mainnet
            let contract = self.vm.web3.contract(Web3.Utils.erc20ABI, at: contractAddress, abiVersion: 2)! // utilize precompiled ERC20 ABI for your concenience
            DispatchQueue.global().async {
                guard let bkxBalanceResult = contract.method("balanceOf", parameters: [address] as [AnyObject], options: Web3Options.defaultOptions())?.call(options: nil) else {return} // encode parameters for transaction
                guard case .success(let bkxBalance) = bkxBalanceResult, let bal = bkxBalance["0"] as? BigUInt else {return} // bkxBalance is [String: Any], and parameters are enumerated as "0", "1", etc in order of being returned. If returned parameter has a name in ABI, it is also duplicated
                print(bkxBalance)
                print("BKX token balance = " + String(bal))
            }
        }
    }
    /**
     相关概念
     什么是 gas ，什么是 gas price , 以及 data？
     
     在以太坊上，发送代币或调用智能合约，在区块链上执行写入操作，需要支付矿工计算费用，计费是按照 gas 计算的，gas 使用 ETH 来支付。无论您的调用的方法是成功还是失败，都需要支付计算费用。即使失败，矿工也验证并执行你的交易（计算），因此必须和成功交易一样支付矿工费。
     
     简单的说 gas limit 相当于汽车需要加多少汽油， gas price 相当于每升汽油的价格。
     
     gas limit 之所以称为限额，因为它是你愿意在一笔交易中花费 gas 的最大数量。交易所需的 gas 是通过调用智能合约执行多少代码来定义。 如果你不想花太多的 gas，通过降低 gas limit 将不会有太大的帮助。 因为你必须包括足够的gas 来支付的计算资源，否则由于gas 不够报错 Out of gas。所有未使用的 gas 将在转账结束时退还给您。 所以使用 imToken 发送1 ETH，并设置 gas limit 为 40万，转账结束后你会收到 400000 - 21000 gas 退还。
     
     通过降低 gas price可以节省矿工费用，但是也会减慢矿工打包的速度。矿工会优先打包 gas price 设置高的交易，如果你想加快转账，你可以把 gas price 设置得更高，这样你就可以排队靠前。如果你不急，你只需要设置一个安全的 gas price，矿工也会打包你的交易查看矿工可以接受的最低 gas price : http://ethgasstation.info/
     
     Data 是可选项，用来调用合约。你需要把对应字符串转换成 16进制，工具：http://string-functions.com/string-hex.aspx ，填入十六进制数据（0x 开头）比如 makoshan 转换成 16 进制是 0x6d616b6f7368616e
     */
    func showBottomView() {
        guard let _ = self.currentEntity else {
            ViewManager.showNotice("请先选择币种")
            return
        }
        guard let number = self.numberTextField.text, number.isEmpty == false  else {
            ViewManager.showNotice("请填写转账数量")
            return
        }
        guard let address = self.addressTextField.text, address.isEmpty == false else {
            ViewManager.showNotice("请填写收款人地址")
            return
        }
        //guard let remark = self.remarkTextField.text else { return }
        guard let gas = self.gasLabel.text else { return }
        
        print(address,number,gas)
        self.statusBottomView.customView = self.customViewInit(number: number, address: address, gas: gas, remark: self.remarkTextField.text ?? "无备注")
        self.statusBottomView.show()
    }
    func sendEth(_ psd:String) {
        guard let _ = self.currentEntity else {
            ViewManager.showNotice("请先选择币种")
            return
        }
        guard let number = self.numberTextField.text, number.isEmpty == false  else {
            ViewManager.showNotice("请填写转账数量")
            return
        }
        guard let address = self.addressTextField.text, address.isEmpty == false else {
            ViewManager.showNotice("请填写收款人地址")
            return
        }
        //guard let remark = self.remarkTextField.text else { return }
        guard let gas = self.gasLabel.text else { return }
        
        guard let walletAddress = EthereumAddress(WalletManager.manager.walletEntity.address) else { return }
        guard let toAddress = EthereumAddress(address) else { return }
        var options = Web3Options.init()

        options.gasPrice = self.gasPrise //getGasPrice() =  2000000000
        let v = Int(self.gasSlider.value)
        
        let ether = EthUnit.Ether(Double(v) / Double(10000000))
        let wei = EthUnit.etherToWei(ether: ether)
        
        let gasLimit = BigUInt(wei) / self.gasPrise
        options.gasLimit = BigUInt(gasLimit) // BigUInt(21000) // BigUInt(90000)
        options.from = walletAddress
        options.to = toAddress
        //options.value = Web3.Utils.parseToBigUInt("1.0", units: .eth)
        
        print(ether,wei,gasLimit)
  
        DispatchQueue.global().async {
            //let intermediate = web3?.contract(Web3.Utils.coldWalletABI, at: EthereumAddress(address), abiVersion: 2)?.method(options: options)
            guard let intermediate = self.vm.web3.eth.sendETH(from: walletAddress, to: toAddress, amount: number) else {return}
            
            //web3?.eth.sendETH(to: EthereumAddress("0x50d2cf603b4fa3107396fa49ac01469a3aaf0f79")!, amount: "0.001")
            //guard let intermediate = web3?.eth.sendETH(to: EthereumAddress("0x50d2cf603b4fa3107396fa49ac01469a3aaf0f79")!, amount: "0.001") else {return}
            
            let result = intermediate.send(password: psd, options: options)

            switch result {
            case .success(let res):
                print(res.hash)
                return
            case .failure(let error):
                print(error)
            }
        }
    }
    func sendERC20Token(_ psd:String) {
        guard let _ = self.currentEntity else {
            ViewManager.showNotice("请先选择币种")
            return
        }
        guard let number = self.numberTextField.text, number.isEmpty == false  else {
            ViewManager.showNotice("请填写转账数量")
            return
        }
        guard let address = self.addressTextField.text, address.isEmpty == false else {
            ViewManager.showNotice("请填写收款人地址")
            return
        }
        //guard let remark = self.remarkTextField.text else { return }
        guard let gas = self.gasLabel.text else { return }
        
        print(address,number,gas)
        self.statusBottomView.customView = self.customViewInit(number: number, address: address, gas: gas, remark: self.remarkTextField.text ?? "无备注")
        self.statusBottomView.show()
        
        return
        
        guard let walletAddress = EthereumAddress(WalletManager.manager.walletEntity.address) else { return }
        guard let toAddress = EthereumAddress(address) else { return }
        
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
            let convenienceTokenTransfer = self.vm.web3.eth.sendERC20tokensWithNaturalUnits(tokenAddress: EthereumAddress("0x34a9a46340d0b76e423ea75e5a62b6a81ff35bf6")!, from: walletAddress, to: toAddress, amount: number, options: options)
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
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        
        selectView.topBarView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 260))
            view.backgroundColor = JX999999Color
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 59.5)
            label.backgroundColor = UIColor.white
            //label.center = view.center
            label.text = "确认转账"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JX333333Color
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 8.5, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(closeStatus), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        selectView.isUseCustomTopBar = true
        
        return selectView
    }()
    func customViewInit(number: String, address: String, gas: String, remark: String) -> UIView {
        guard let entity = self.currentEntity else {
            return UIView()
        }
        //
        let width : CGFloat = kScreenWidth - 70
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 288)
        contentView.backgroundColor = UIColor.white
        
        let backView = UIView()
        backView.frame = CGRect(x: 35, y: 0, width: width, height: contentView.jxHeight)
        backView.backgroundColor = UIColor.white
        contentView.addSubview(backView)
        
        
        let leftLabel = UILabel()
        leftLabel.frame = CGRect(x: 35, y: 20, width: width / 2, height: 15)
        leftLabel.text = "\(number) \(entity.shortName ?? "")"
        leftLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        leftLabel.textAlignment = .left
        
        contentView.addSubview(leftLabel)
        
        
        let rightLabel = UILabel()
        rightLabel.frame = CGRect(x: leftLabel.jxRight, y: 20, width: width / 2, height: 15)
        rightLabel.text = "手续费：\(gas) ETH"
        rightLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        rightLabel.font = UIFont.systemFont(ofSize: 14)
        rightLabel.textAlignment = .right
        
        contentView.addSubview(rightLabel)
        
        let line1 = UIView()
        line1.frame = CGRect(x: 35, y: leftLabel.jxBottom + 20, width: width, height: 1)
        line1.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line1)
        
        let addressLabel = UILabel()
        addressLabel.backgroundColor = UIColor.white
        addressLabel.frame = CGRect(x: 35, y: line1.jxBottom + 30, width: width, height: 80)
        addressLabel.text = "\(address)"
        addressLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 0
        
        addressLabel.layer.shadowColor =  UIColor.rgbColor(rgbValue: 0xe2e2e2).cgColor
        addressLabel.layer.shadowOpacity = 0.5
        addressLabel.layer.shadowRadius = 4
        addressLabel.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        
        contentView.addSubview(addressLabel)
        
        let line2 = UIView()
        line2.frame = CGRect(x: 35, y: addressLabel.jxBottom + 30, width: width, height: 1)
        line2.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line2)
        
        let remarkLabel = UILabel()
        remarkLabel.frame = CGRect(x: 35, y: line2.jxBottom + 15, width: width, height: 15)
        remarkLabel.text = remark
        remarkLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        remarkLabel.font = UIFont.systemFont(ofSize: 14)
        remarkLabel.textAlignment = .left
        contentView.addSubview(remarkLabel)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: remarkLabel.jxBottom + 15, width: 114, height: 36)
        button.setTitle("转账", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirmTransfer), for: .touchUpInside)
        contentView.addSubview(button)
        button.center = CGPoint(x: contentView.center.x, y: button.center.y)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 114, height: 36)
        gradientLayer.cornerRadius = 18
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        return contentView
    }
    @objc func confirmTransfer() {
        self.closeStatus()
        
        guard let address = self.addressTextField.text else { return }
        guard let number = self.numberTextField.text else { return }
        guard let remark = self.remarkTextField.text else { return }
        guard let gas = self.gasLabel.text else { return }
        guard let psd = self.password else { return }
        
        print(address,number,remark,gas)

        
        guard let walletAddress = EthereumAddress(WalletManager.manager.walletEntity.address) else { return }
        guard let toAddress = EthereumAddress(address) else {
            ViewManager.showNotice("收款人地址有误")
            return
        }
        
        var options = Web3Options.defaultOptions()
        options.value = BigUInt(0)
        options.from = walletAddress
        options.gasPrice = self.gasPrise //getGasPrice() =  2000000000
        options.gasLimit = BigUInt(self.gasSlider.value)// BigUInt(gasLimit) // BigUInt(21000) // BigUInt(90000)
        print(self.gasSlider.value)
        
        self.showMBProgressHUD()
        
        if self.type == .eth {
            
            options.to = toAddress
            
            //options.value = Web3.Utils.parseToBigUInt(number, units: .eth)
    
            let data = remark.data(using: .utf8) ?? Data()
            
            DispatchQueue.global().async {
                //let intermediate = web3?.contract(Web3.Utils.coldWalletABI, at: EthereumAddress(address), abiVersion: 2)?.method(options: options)
                guard let intermediate = self.vm.web3.eth.sendETH(from: walletAddress, to: toAddress, amount: number, units: Web3.Utils.Units.eth, extraData: data, options: options) else { return }
                //guard let intermediate = self.vm.web3.eth.sendETH(from: walletAddress, to: toAddress, amount: number) else {return}
                
                //web3?.eth.sendETH(to: EthereumAddress("0x50d2cf603b4fa3107396fa49ac01469a3aaf0f79")!, amount: "0.001")
                //guard let intermediate = web3?.eth.sendETH(to: EthereumAddress("0x50d2cf603b4fa3107396fa49ac01469a3aaf0f79")!, amount: "0.001") else {return}
                
                let result = intermediate.send(password: psd, options: options)
                
                DispatchQueue.main.async {
                    self.hideMBProgressHUD()
                    switch result {
                    case .success(let res):
                        print("交易哈希：",res.hash)
                        self.performSegue(withIdentifier: "transferSuccess", sender: nil)
                        return
                    case .failure(let error):
                        ViewManager.showNotice(error.localizedDescription)
                        print(error)
                    }
                }
            }
        } else {
            
            //options.to = toAddress  //交易token不能在此设置地址，不然会默认为交易eth
            //options.value = Web3.Utils.parseToBigUInt(number, units: .eth)
           
            let data = remark.data(using: .utf8) ?? Data()
            guard
                let num = Decimal.init(string: number) else {
                    self.hideMBProgressHUD()
                    ViewManager.showNotice("系统错误")
                    return
            }
            let etherBigInt = BigUInt(EthUnit.etherToWei(ether: num))
            print(etherBigInt)

            DispatchQueue.global().async {
                guard
                    let entity = self.currentEntity,
                    let tokenAddress = EthereumAddress(entity.tokenAddress),
                    //1
                    //let convenienceTokenTransfer = self.vm.web3.eth.sendERC20tokensWithKnownDecimals(tokenAddress: tokenAddress, from: walletAddress, to: toAddress, amount: etherBigInt)
                    //2
                    //let convenienceTokenTransfer = self.vm.web3.eth.sendERC20tokensWithNaturalUnits(tokenAddress: tokenAddress, from: walletAddress, to: toAddress, amount: number, options: options)
                    //3
                    let testToken = self.vm.web3.contract(Web3.Utils.erc20ABI, at: tokenAddress, abiVersion: 2),
                    let convenienceTokenTransfer = testToken.method("transfer", parameters: [toAddress, etherBigInt] as [AnyObject], extraData: data, options: options)
                    else {
                        DispatchQueue.main.async {
                            self.hideMBProgressHUD()
                            ViewManager.showNotice("系统错误")
                        }
                    return
                }
                
                let gasEstimateResult2 = convenienceTokenTransfer.estimateGas(options: nil)
                switch gasEstimateResult2 {
                case .success(let res):
                    options.gasLimit = res
                    print("estimateGas = ",res)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.hideMBProgressHUD()
                        ViewManager.showNotice(error.localizedDescription)
                    }
                    print(error)
                }
//                guard case .success(let gasEstimate2) = gasEstimateResult2 else {
//                    DispatchQueue.main.async {
//                        self.hideMBProgressHUD()
//                        ViewManager.showNotice("系统错误")
//                    }
//                    return
//                }
//                options.gasLimit = gasEstimate2

                let convenienceTransferResult = convenienceTokenTransfer.send(password: psd, options: options)
                DispatchQueue.main.async {
                    self.hideMBProgressHUD()

                    switch convenienceTransferResult {
                    case .success(let res):
                        print("交易哈希：",res.hash)
                        self.performSegue(withIdentifier: "transferSuccess", sender: nil)
                        return
                    case .failure(let error):
                        ViewManager.showNotice(error.localizedDescription)
                        print(error)
                    }
                }
            }
        }
        
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
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
extension TransferViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
extension TransferViewController : JXActionViewDelegate, JXActionViewDataSource {
    
    func actionView(_ actionView: JXActionView, heightForRowAt index: Int) -> CGFloat {
        return 60
    }
    func numberOfRow(in actionView: JXActionView) -> Int {
        return self.propertyArray.count
    }
    func actionView(_ actionView: JXActionView, listCell: UITableViewCell, cellForRowAt index: Int) -> UITableViewCell{
        let cell = listCell as! JXActionCell
        let entity = self.propertyArray[index]
        cell.coinNameLabel.text = entity.shortName
        let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
        cell.coinNumberLabel.text = "\(EthUnit.decimalNumberHandler(ether))"
        cell.worthLabel.text = "≈￥" + entity.CNY
        
        return cell
    }
    
    func actionView(_ actionView: JXActionView, clickButtonAtIndex index: Int) {
        
        let entity = self.propertyArray[index]
        self.currentEntity = entity
        self.categoryLabel.text = entity.shortName
        
        if entity.shortName == "ETH" {
            self.type = .eth
           // 查询余额
            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
            let formatEther = EthUnit.decimalNumberHandler(ether, scale: 4)
            self.balanceLabel.text = "余额:\(formatEther) \(entity.shortName ?? "")"
        } else {
            self.type = .erc20
            
            let ether = EthUnit.weiToEther(wei: EthUnit.Wei(entity.coinNum))
            let formatEther = EthUnit.decimalNumberHandler(ether, scale: 4)
            self.balanceLabel.text = "余额:\(formatEther) \(entity.shortName ?? "")"
        }
        actionView.dismiss()
    }
}
