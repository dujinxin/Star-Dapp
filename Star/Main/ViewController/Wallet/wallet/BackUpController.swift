//
//  BackUpController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/31.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation
import web3swift

class BackUpController: BaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: JXPlaceHolderTextView!
    
    @IBOutlet weak var unlockButton: UIButton!
    
    var vm : Web3VM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "备份钱包"
        self.view.backgroundColor = UIColor.white
        
        self.textView.text = "*************************"
        self.textView.textAlignment = .center
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: self.unlockButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.unlockButton.layer.insertSublayer(gradientLayer, at: 0)
        self.unlockButton.backgroundColor = UIColor.clear
        
        
        guard let dataArray = WalletDB.shareInstance.selectData() as? Array<Dictionary<String,String>> else{
            return
        }
        let dict = dataArray[0]
        guard let address = dict["address"] else { return }
        guard let ethereumAddress = EthereumAddress(address) else {return}
        guard let keystoreBase64Str = dict["keystore"] else {return}
        self.vm = Web3VM(keystoreBase64Str: keystoreBase64Str)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
        self.bottomConstraint.constant = kBottomMaginHeight
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    @IBAction func unlockCheck(_ sender: Any) {
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
                
                self.validatePassword(text)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    func validatePassword(_ password: String) {
        print("password")
        do {
            try self.vm?.keystore?.regenerate(oldPassword: password, newPassword: password)
        } catch let error {
            print("原钱包密码错误")
            print(error)
            return
        }
        let address = self.vm?.keystore?.addresses![0]
        let privateKey = try! self.vm?.keystore?.UNSAFE_getPrivateKeyData(password: password, account: address!).toHexString()
        print("私钥 = ",privateKey)
    }
}
