//
//  RegisterViewController.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/22.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {


    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var inviteTextField: UITextField!
    @IBOutlet weak var fetchButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var lookButton: UIButton!
   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint!
    
    var vm = LoginVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //textFieldTopConstraint.constant = CGFloat(333) * kPercent - 80
        
//        var font = UIFont.systemFont(ofSize: 13)
//
//        if kScreenWidth < 375 {
//            self.leadingConstraints.constant = 15
//            self.trailingConstraints.constant = 15
//            font = UIFont.systemFont(ofSize: 12)
//        }
//
//        let attributeString1 = NSMutableAttributedString.init(string: "中国大陆")
//        attributeString1.addAttributes([NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0xd0cece)], range: NSRange.init(location: 0, length: attributeString1.length))
//        userTextField.attributedPlaceholder = attributeString1
//
//        let attributeString2 = NSMutableAttributedString.init(string: "如果忘记密码，请联系管理员")
//        attributeString2.addAttributes([NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0xd0cece)], range: NSRange.init(location: 0, length: attributeString2.length))
//        passwordTextField.attributedPlaceholder = attributeString2
//
//
//        lookButton.setImage(UIImage(named:"look_normal"), for: .normal)
//        lookButton.setImage(UIImage(named:"look_highlight"), for: .highlighted)
//        lookButton.isSelected = false
        
        loginButton.backgroundColor = UIColor.rgbColor(from: 153, 153, 153)
        loginButton.layer.cornerRadius = 22
        //loginButton.alpha = 0.4
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        //userTextField.text = "13477831123"
        //passwordTextField.text = "12345678a"
        //codeTextField.text = "996687"
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=register&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        lookButton.sd_setImage(with: url, for: .normal, completed: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func awakeFromNib() {
        //
    }
    
    @IBAction func backLoginVC(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func changePasswordText(_ sender: UIButton) {
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=register&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        lookButton.sd_setImage(with: url, for: .normal, completed: nil)
        
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            passwordTextField.isSecureTextEntry = false
//        }else{
//            passwordTextField.isSecureTextEntry = true
//        }
        
    }

    @IBAction func fetchCode(_ sender: UIButton) {
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号不能为空", formatMsg: "手机号格式错误") == true else { return }
        guard String.validate(passwordTextField.text, type: .none, emptyMsg: "图片验证码不能为空", formatMsg: "") == true else { return }
//        guard let imageCode = passwordTextField.text,imageCode.isEmpty == false else {
//            ViewManager.showNotice("图片验证码不能为空")
//            return
//        }
        CommonManager.countDown(timeOut: 10, process: { (currentTime) in
            UIView.beginAnimations(nil, context: nil)
            self.fetchButton.setTitle(String(format: "%d", currentTime), for: .normal)
            UIView.commitAnimations()
            self.fetchButton.isUserInteractionEnabled = false
        }) {
            self.fetchButton.setTitle("获取验证码", for: .normal)
            self.fetchButton.isUserInteractionEnabled = true
        }
  
        self.vm.sendMobileCode(mobile: userTextField.text!, method: "register", validateCode: passwordTextField.text!) { (_, msg, _) in
            ViewManager.showNotice(msg)
        }
    }
    
    @IBAction func logAction(_ sender: Any) {
        
//        performSegue(withIdentifier: "auth", sender: nil)
//
//        return
        
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号不能为空", formatMsg: "手机号格式错误") == true else { return }
        guard String.validate(codeTextField.text, type: .code4, emptyMsg: "验证码不能为空", formatMsg: "请检查验证码位数") == true else { return }
        
        self.showMBProgressHUD()
        
        self.vm.register(mobile: userTextField.text!, inviteCode: inviteTextField.text ?? "", mobileCode: codeTextField.text!) { (_, msg, isSuccess) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuccess {
                self.performSegue(withIdentifier: "auth", sender: nil)
            } else {
                
            }
        }
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == userTextField {
            if range.location > 10 {
                return false
            }
        } else if textField == codeTextField {
            if range.location > 3 {
                return false
            }
        }
        return true
    }
    @objc func textChange(notify:NSNotification) {
        guard let textField = notify.object as? UITextField else {
            return
        }
    }
}
