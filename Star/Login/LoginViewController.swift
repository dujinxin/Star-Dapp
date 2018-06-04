//
//  LoginViewController.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/22.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {


    @IBOutlet weak var mainScrollView: UIScrollView!
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
//
//
//        lookButton.setImage(UIImage(named:"look_normal"), for: .normal)
//        lookButton.setImage(UIImage(named:"look_highlight"), for: .highlighted)
//        lookButton.isSelected = false
        
        loginButton.backgroundColor = UIColor.rgbColor(from: 153, 153, 153)
        loginButton.layer.cornerRadius = 22
        //loginButton.alpha = 0.4
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=login&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        fetchImageButton.sd_setImage(with: url, for: .normal, completed: nil)
        
        
        //userTextField.text = "13477831123"
        //passwordTextField.text = "12345678a"
        
        
//        self.vm.getImageCode(type: "login") { (data, msg, isSuccess) in
//            //
//        }
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
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func awakeFromNib() {
        //
    }
    @IBAction func fetchCodeImage(_ sender: UIButton) {
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=login&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        fetchImageButton.sd_setImage(with: url, for: .normal, completed: nil)
    }
    @IBAction func fetchCodeWord(_ sender: UIButton) {
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号不能为空", formatMsg: "手机号格式错误") == true else { return }
        guard String.validate(codeImageTextField.text, type: .none, emptyMsg: "图片验证码不能为空", formatMsg: "") == true else { return }
      
        CommonManager.countDown(timeOut: 10, process: { (currentTime) in
            UIView.beginAnimations(nil, context: nil)
            self.fetchWordButton.setTitle(String(format: "%d", currentTime), for: .normal)
            UIView.commitAnimations()
            self.fetchWordButton.isUserInteractionEnabled = false
        }) {
            self.fetchWordButton.setTitle("获取验证码", for: .normal)
            self.fetchWordButton.isUserInteractionEnabled = true
        }
        
        self.vm.sendMobileCode(mobile: userTextField.text!, method: "login", validateCode: codeImageTextField.text!) { (_, msg, _) in
            ViewManager.showNotice(msg)
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
}
