//
//  AuthViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class AuthViewController: BaseViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var identifyCardTextField: UITextField!
    @IBOutlet weak var ocrButton: UIButton!
    @IBOutlet weak var commitButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var aipCardVC : UIViewController?
    
    var vm = OcrVM()
    var loginVM = LoginVM()
    var alert : JXSelectView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.aipCardVC = nil
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 授权方法2（更安全）： 下载授权文件，添加至资源
        /* 活体认证调用后台接口
        guard
            let licenseFile = Bundle.main.path(forResource: "aip", ofType: "license"),
            let licesseData = try? Data.init(contentsOf: URL(fileURLWithPath: licenseFile), options: [])else {
            return 
        }
        AipOcrService.shard().auth(withLicenseFileData: licesseData)
        AipOcrService.shard().getTokenSuccessHandler({ (msg) in
            print("get token success = ",msg)
        }) { (error) in
            print("get token error = ",error?.localizedDescription)
        }
        self.vm.getAccessToken(apiKey: FACE_API_KEY, secretKey: FACE_SECRET_KEY) { (data, msg, isSuccess) in
            //
            print("token = ",self.vm.accessToken)
        }
        */
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 60, height: commitButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.commitButton.layer.addSublayer(gradientLayer)
        commitButton.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTextField.resignFirstResponder()
        self.identifyCardTextField.resignFirstResponder()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "result" {
            let vc = segue.destination as? AuthResultViewController
            guard
                let dict = sender as? Dictionary<String,Any>,
                let isSucc = dict["isSucc"] as? Bool,
                let tip = dict["tip"] as? String,
                let score = dict ["score"] as? String
                else {
                    vc?.isSucc = false
                    vc?.tip = "参数错误"
                    vc?.score = "0"
                return
            }
            vc?.isSucc = isSucc
            vc?.tip = tip
            vc?.score = score
        }
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
    }
    @IBAction func useOcr(_ sender: UIButton) {
        
        
        aipCardVC = AipCaptureCardVC.viewController(with: .localIdCardFont) { (image) in
            print("image = ",image)
            if let image = image {
                
                self.aipCardVC?.dismiss(animated: true, completion: nil)
                
                AipOcrService.shard().detectIdCardFront(from: image, withOptions: nil, successHandler: { (result) in
                    print("result = ",result)
                    //UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
                    guard
                        let result = result as? Dictionary<String,Any>,
                        let words_results = result["words_result"] as? Dictionary<String,Any>
                    else {
                        return
                    }
                    guard
                        let idNumberDict = words_results["公民身份号码"] as? Dictionary<String,Any>,
                        let idNumberStr = idNumberDict["words"] as? String
                    else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.identifyCardTextField.text = idNumberStr
                    }
                    
                    guard
                        let nameDict = words_results["姓名"] as? Dictionary<String,Any>,
                        let nameStr = nameDict["words"] as? String
                    else {
                        return
                    }
                    DispatchQueue.main.async(execute: {
                        self.nameTextField.text = nameStr
                    })
                    
                    OperationQueue.main.addOperation({
                        var message = String()
                        if words_results.count > 0 {
                            words_results.forEach({ (key,value) in
                                if
                                    let dic = value as? Dictionary<String,Any>,
                                    let words = dic["words"] as? String {
                                    message = message.appendingFormat("%@: %@", key,words)
                                }
                            })
                        }
                        let alert = UIAlertController(title: "身份证信息", message: message, preferredStyle: .alert)
                        let action = UIAlertAction(title: "确定", style: .cancel, handler: { (ac) in
                            self.identifyUserLiveness()
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    })
                }, failHandler: { (error) in
                    print("error = ",error)
                })
            }
        }
        self.present(aipCardVC!, animated: true, completion: nil)
    }
    
    @IBAction func commit(_ sender: UIButton) {

        guard let name = self.nameTextField.text else { return }
        guard let idNumber = self.identifyCardTextField.text else { return }
        
        self.showMBProgressHUD()
        self.loginVM.identifyAuth(name: name, idNumber: idNumber) { (authStatus, msg, isSuccess) in
            self.hideMBProgressHUD()
            if isSuccess {
                self.showResult()
            } else {
                ViewManager.showNotice(msg)
            }
        }
        
        //self.identifyUserLiveness()
    }
    func showResult() {
        let width : CGFloat = kScreenWidth - 70
        
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 280)
        contentView.backgroundColor = UIColor.clear
        
        let backView = UIView()
        backView.frame = CGRect(x: 35, y: 0, width: width, height: 280)
        backView.backgroundColor = UIColor.white
        contentView.addSubview(backView)
        
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 35, y: 20, width: width, height: 20)
        titleLabel.text = "领取成功"
        titleLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        
        
        let line = UIView()
        line.frame = CGRect(x: 35, y: titleLabel.jxBottom + 20, width: width, height: 1)
        line.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line)
        
        
        let attributeStr = NSMutableAttributedString.init(string: "你是智慧星球第\(UserManager.manager.userEntity.rank)位世界知识产权贡献者！")
        let rankStr = "\(UserManager.manager.userEntity.rank)"
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing =  10
        paragraph.paragraphSpacing = 10
        paragraph.alignment = .center
        
        attributeStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0x979ebf),NSAttributedStringKey.paragraphStyle:paragraph], range: NSRange.init(location: 0, length: 7))
        attributeStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 22),NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0x3B4368),NSAttributedStringKey.paragraphStyle:paragraph], range: NSRange.init(location: 7, length: rankStr.count))
        attributeStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0x979ebf),NSAttributedStringKey.paragraphStyle:paragraph], range: NSRange.init(location: "你是智慧星球第\(UserManager.manager.userEntity.rank)".count, length: 11))
        
        let detailLabel = UILabel()
        detailLabel.frame = CGRect(x: 80, y: line.jxBottom + 44, width: width - 90, height: 67)
//        detailLabel.text = "你是智慧星球第\(UserManager.manager.userEntity.rank)位世界知识产权贡献者！"
//        detailLabel.textColor = UIColor.rgbColor(rgbValue: 0x979ebf)
        detailLabel.textAlignment = .center
//        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.attributedText = attributeStr
        detailLabel.numberOfLines = 2
        contentView.addSubview(detailLabel)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: detailLabel.jxBottom + 30, width: 114, height: 36)
        button.setTitle("我已收到", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        contentView.addSubview(button)
        button.center = CGPoint(x: detailLabel.center.x, y: button.center.y)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 114, height: 36)
        gradientLayer.cornerRadius = 18
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        self.alert = JXSelectView.init(frame: CGRect(), customView: contentView)
        self.alert?.position = .middle
        self.alert?.delegate = self
        self.alert?.show()
        
    }
    @objc func backTo() {
        self.alert?.dismiss(animate: false)
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: true)
        })
    }
    func identifyUserLiveness() {
        
        
        let licenseFile = Bundle.main.path(forResource: FACE_LICENSE_NAME, ofType: FACE_LICENSE_SUFFIX)
        if let filePath = licenseFile, FileManager.default.fileExists(atPath: filePath) == true {
            print("liveness = ",FaceSDKManager.sharedInstance().canWork())
            FaceSDKManager.sharedInstance().setLicenseID(FACE_LICENSE_ID, andLocalLicenceFile: filePath)
        }
        
        let vc = LivenessViewController()
        let model = LivingConfigModel()
        vc.livenesswithList(model.liveActionArray as! [Any]?, order: model.isByOrder, numberOfLiveness: model.numOfLiveness)
        vc.completion = {(images,image) in
            guard let imageDict = images else { return }
            let bestImage = imageDict["bestImage"] as? Array<Any>
            
            //let data = Data(base64Encoded: bestImage?.last, options:Data.Base64DecodingOptions.ignoreUnknownCharacters)
            var data = UIImageJPEGRepresentation(image!, 0.6)
            if data == nil {
                data = UIImagePNGRepresentation(image!)
            }
            let imageStr = data?.base64EncodedString(options: .endLineWithLineFeed)
            
            self.vm.ocr(name: self.nameTextField.text ?? "", idNumber: self.identifyCardTextField.text ?? "", imageStr: imageStr ?? "", completion: { (data, msg, isSuccess) in
                
                DispatchQueue.main.async(execute: {
                    var isSucc = false
                    var tip = "验证分数"
                    var score = "0"
                    if isSuccess {
                        guard
                            let dict = data as? Dictionary<String,Any>
                            else{
                            return
                        }
                        if
                            let result = dict["result"] as? Dictionary<String,Any>,
                            let s = result["score"] as? Double{
                            score = String(format: "%.4f", s)
                            if s > 80.0 {
                                isSucc = true
                            }
                        } else if
                            let i = dict["error_code"] as? Int, let message = dict["error_msg"] as? String{
//                            if i == 216600 {
//                                tip = "身份证号码错误"
//                            } else if i == 216601 {
//                                tip = "身份证号码与姓名不匹配"
//                            }
                            tip = message
                        } else {
                            
                        }

                    } else {

                    }
                    let dict = ["isSucc":isSucc,"tip":tip,"score":score] as [String:Any]
                    self.performSegue(withIdentifier: "result", sender: dict)
                })
                
            })
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        self.present(nvc, animated: true, completion: nil)
        
    }
    @objc func image(image:UIImage,didFinishSavingWithError error:Error?,contextInfo:AnyObject?) {
        if error != nil {
            //
            print("保存成功")
        }else{
            print("保存失败")
        }
    }
    @objc func textDidChange(notify:NSNotification) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == identifyCardTextField {
            if range.location > 17 {
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            self.identifyCardTextField.becomeFirstResponder()
            return false
        } else {
            return textField.resignFirstResponder()
        }
    }

    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
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
extension AuthViewController : JXSelectViewDelegate {
    func jxSelectView(jxSelectView: JXSelectView, didSelectRowAt row: Int, inSection section: Int) {
        
    }
    
    func jxSelectView(jxSelectView: JXSelectView, clickButtonAtIndex index: Int) {
        jxSelectView.dismiss(animate: false)
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: true)
        })
    }
}
