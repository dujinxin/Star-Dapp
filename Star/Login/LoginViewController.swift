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
    @IBOutlet weak var contentSize_heightConstraint: NSLayoutConstraint!
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
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        
        loginButton.backgroundColor = UIColor.clear
        //loginButton.alpha = 0.4
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
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
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.contentSize_heightConstraint.constant = kScreenHeight
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

        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号未填写", formatMsg: "手机号填写错误") == true else { return }
        guard String.validate(codeImageTextField.text, type: .none, emptyMsg: "图形验证码未填写", formatMsg: "") == true else { return }
      
        self.showMBProgressHUD()
        self.vm.sendMobileCode(mobile: userTextField.text!, method: "login", validateCode: codeImageTextField.text!) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
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
        
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号未填写", formatMsg: "手机号填写错误") == true else { return }
        guard String.validate(codeWordTextField.text, type: .code4, emptyMsg: "短信验证码未填写", formatMsg: "短信验证码填写错误") == true else { return }
        

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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == userTextField {
//            self.mainScrollView.contentOffset = CGPoint(x: 0, y: -60)
//        } else if textField == codeImageTextField{
//            self.mainScrollView.contentOffset = CGPoint(x: 0, y: -60 * 2)
//        } else if textField == codeWordTextField{
//            self.mainScrollView.contentOffset = CGPoint(x: 0, y: -60 * 2)
//        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeImageTextField {
            self.codeWordTextField.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            //self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
            return true
        }
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
