//
//  LoginViewController.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/22.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
//import JXFoundation

class LoginViewController: BaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var codeImageTextField: UITextField!
    @IBOutlet weak var codeWordTextField: UITextField!
    @IBOutlet weak var fetchImageButton: UIButton!
    @IBOutlet weak var fetchWordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
   
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
        
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            self.mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        
        loginButton.backgroundColor = UIColor.clear
        //loginButton.alpha = 0.4
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 60, height: loginButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.loginButton.layer.addSublayer(gradientLayer)
        
        
        fetchWordButton.layer.borderColor = UIColor.rgbColor(from: 21, 106, 206).cgColor
        fetchWordButton.layer.borderWidth = 1
        fetchWordButton.layer.cornerRadius = 13.3
        fetchWordButton.setTitleColor(JXTextColor, for: .normal)
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=login&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        fetchImageButton.sd_setImage(with: url, for: .normal, completed: nil)
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
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
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func fetchCodeImage(_ sender: UIButton) {
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=login&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        fetchImageButton.sd_setImage(with: url, for: .normal, completed: nil)
    }
    @IBAction func fetchCodeWord(_ sender: UIButton) {

        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号不能为空", formatMsg: "手机号格式错误") == true else { return }
        guard String.validate(codeImageTextField.text, type: .none, emptyMsg: "图片验证码不能为空", formatMsg: "") == true else { return }
      
        
        self.vm.sendMobileCode(mobile: userTextField.text!, method: "login", validateCode: codeImageTextField.text!) { (_, msg, isSuc) in
            ViewManager.showNotice(msg)
            if isSuc {
                CommonManager.countDown(timeOut: 60, process: { (currentTime) in
                    UIView.beginAnimations(nil, context: nil)
                    self.fetchWordButton.setTitle(String(format: "%d", currentTime), for: .normal)
                    UIView.commitAnimations()
                    self.fetchWordButton.isEnabled = false
                }) {
                    self.fetchWordButton.setTitle("获取验证码", for: .normal)
                    self.fetchWordButton.isEnabled = true
                }
            }
        }
    }

    @IBAction func logAction(_ sender: Any) {
        
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号不能为空", formatMsg: "手机号格式错误") == true else { return }
        guard String.validate(codeWordTextField.text, type: .code4, emptyMsg: "验证码不能为空", formatMsg: "请检查验证码位数") == true else { return }
        

        self.showMBProgressHUD()
        
        self.vm.login(userName: userTextField.text!, code: codeWordTextField.text!) { (data, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                if UserManager.manager.userEntity.authStatus == 1 {
                    //未实名
                    self.performSegue(withIdentifier: "auth", sender: nil)
                } else {
                    //已实名
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: true)
                    })
                }
            }else{
                ViewManager.showNotice(msg)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == userTextField {
            if range.location > 10 {
                //let s = textField.text! as NSString
                //let str = s.substring(to: 10)
                //textField.text = str
                //ViewManager.showNotice(notice: "字符个数为11位")
                return false
            }
        }
        return true
    }
    func textChange(notify:NSNotification) {
        
    }
//    @objc func keyboardWillShow(notify:Notification) {
//
//        guard
//            let userInfo = notify.userInfo,
//            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
//            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
//            else {
//                return
//        }
//
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.frame = CGRect(x: 0, y: keyWindowHeight - self.topBarHeight - self.keyboardRect.height, width: keyWindowWidth, height: self.topBarHeight)
//            self.tapControl.alpha = 0.2
//        }) { (finish) in
//            //
//        }
//    }
//    @objc func keyboardWillHide(notify:Notification) {
//        print("notify = ","notify")
//        guard
//            let userInfo = notify.userInfo,
//            let _ = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
//            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
//            else {
//                return
//        }
//        UIView.animate(withDuration: animationDuration, animations: {
//            //如果为iPhoneX，则把底部的34空间让出来
//            let h : CGFloat = self.topBarHeight + additionalBottomHeight
//            if self.style == .bottom {
//                self.frame = CGRect.init(x: 0, y: keyWindowHeight - h, width: keyWindowWidth, height: h)
//            } else {
//                self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: h)
//            }
//            self.tapControl.alpha = 0
//        }) { (finish) in
//            if self.style == .hidden {
//                self.clearInfo()
//            } else if self.style == .bottom{
//
//            } else {
//                self.clearInfo()
//            }
//        }
//    }
}
