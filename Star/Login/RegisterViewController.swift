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
    @IBOutlet weak var contentView: UIView!
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

        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            self.mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        loginButton.backgroundColor = UIColor.clear
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 60, height: loginButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.loginButton.layer.addSublayer(gradientLayer)
        
        fetchButton.layer.borderColor = UIColor.rgbColor(from: 21, 106, 206).cgColor
        fetchButton.layer.borderWidth = 1
        fetchButton.layer.cornerRadius = 13.3
        fetchButton.setTitleColor(JXTextColor, for: .normal)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=register&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        lookButton.sd_setImage(with: url, for: .normal, completed: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count > 1 {
                self.navigationController?.viewControllers.remove(at: 0)
            }
        }

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
        NotificationCenter.default.removeObserver(self)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
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
        self.showMBProgressHUD()
        self.vm.sendMobileCode(mobile: userTextField.text!, method: "register", validateCode: passwordTextField.text!) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                CommonManager.countDown(timeOut: 60, process: { (currentTime) in
                    UIView.beginAnimations(nil, context: nil)
                    self.fetchButton.setTitle(String(format: "%d", currentTime), for: .normal)
                    UIView.commitAnimations()
                    self.fetchButton.isEnabled = false
                }) {
                    self.fetchButton.setTitle("获取验证码", for: .normal)
                    self.fetchButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func logAction(_ sender: Any) {
        
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号不能为空", formatMsg: "手机号格式错误") == true else { return }
        guard String.validate(codeTextField.text, type: .code4, emptyMsg: "验证码不能为空", formatMsg: "请检查验证码位数") == true else { return }

        self.showMBProgressHUD()

        self.vm.register(mobile: userTextField.text!, inviteCode: inviteTextField.text ?? "", mobileCode: codeTextField.text!) { (_, msg, isSuccess) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuccess {
                if UserManager.manager.userEntity.authStatus == 1 {
                    //未实名
                    self.performSegue(withIdentifier: "auth", sender: nil)
                } else {
                    //已实名
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: true)
                    })
                }
            } 
        }
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            self.codeTextField.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
        
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
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        
        //print(rect)//226
        UIView.animate(withDuration: animationDuration, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 160)
            
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","notify")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }) { (finish) in
            
        }
    }
}
