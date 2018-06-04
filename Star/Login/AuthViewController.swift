//
//  AuthViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var identifyCardTextField: UITextField!
    @IBOutlet weak var ocrButton: UIButton!
    @IBOutlet weak var commitButton: UIButton!
    
    var aipCardVC : UIViewController?
    
    var vm = OcrVM()
    var loginVM = LoginVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.aipCardVC = nil
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
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        self.loginVM.identifyAuth(name: name, idNumber: idNumber) { (authStatus, msg, isSuccess) in
            ViewManager.showNotice(msg)
            if isSuccess {
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: true)
                })
            }
        }
        
        //self.identifyUserLiveness()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
