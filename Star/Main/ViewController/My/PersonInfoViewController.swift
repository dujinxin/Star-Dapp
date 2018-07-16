//
//  PersonInfoViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PersonInfoViewController: JXTableViewController{
    
    var vm = LoginVM()
    var identifyVM = IdentifyVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的实名"
        
        self.tableView?.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        self.vm.identityInfo { (data, msg, isSuccess) in
            if isSuccess == false {
                ViewManager.showNotice(msg)
            }else {
                self.tableView?.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PersonCell
        if indexPath.row == 0 {
            cell.leftLabel.text = "手机号码"
            cell.rightLabel.text = self.vm.indentifyInfoEntity?.mobile
        } else if indexPath.row == 1 {
            cell.leftLabel.text = "姓名"
            cell.rightLabel.text = self.vm.indentifyInfoEntity?.name
        } else if indexPath.row == 2 {
            cell.leftLabel.text = "身份证号"
            cell.rightLabel.text = self.vm.indentifyInfoEntity?.idNumber
        } else {
            cell.leftLabel.text = "人脸识别"
            if self.vm.indentifyInfoEntity?.faceAuth == 1 {
                //cell.accessoryType = .checkmark
                cell.rightLabel.text = "✔已验证通过"
            } else {
                //cell.accessoryType = .disclosureIndicator
                cell.rightLabel.text = "未识别"
            }
        }

        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 {
            if self.vm.indentifyInfoEntity?.faceAuth == 1 {
                
            } else {
                self.identifyUserLiveness()
            }
        }
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
            //            let imageStr = data?.base64EncodedString(options: .endLineWithLineFeed)
            let _ = UIImage.insert(image: image!, name: "facePhoto.jpg")
            self.identifyVM.identifyInfo(param: [:], completion: { (_, msg, isSuc) in
                ViewManager.showNotice(msg)
                if isSuc {
                    let _ = UIImage.delete(name: "facePhoto.jpg")
                    self.vm.indentifyInfoEntity?.faceAuth = 1
                    self.tableView?.reloadData()
                }
            })
            
            //
            //            self.vm.ocr(imageStr: imageStr ?? "", completion: { (data, msg, isSuccess) in
            //
            //                DispatchQueue.main.async(execute: {
            //                    var isSucc = false
            //                    var tip = "验证分数"
            //                    var score = "0"
            //                    if isSuccess {
            //                        guard
            //                            let dict = data as? Dictionary<String,Any>
            //                            else{
            //                                return
            //                        }
            //                        if
            //                            let result = dict["result"] as? Dictionary<String,Any>,
            //                            let s = result["score"] as? Double{
            //                            score = String(format: "%.4f", s)
            //                            if s > 80.0 {
            //                                isSucc = true
            //                            }
            //                        } else if
            //                            let i = dict["error_code"] as? Int, let message = dict["error_msg"] as? String{
            //                            //                            if i == 216600 {
            //                            //                                tip = "身份证号码错误"
            //                            //                            } else if i == 216601 {
            //                            //                                tip = "身份证号码与姓名不匹配"
            //                            //                            }
            //                            tip = message
            //                        } else {
            //
            //                        }
            //
            //                    } else {
            //
            //                    }
            //                    let dict = ["isSucc":isSucc,"tip":tip,"score":score] as [String:Any]
            //                    self.performSegue(withIdentifier: "result", sender: dict)
            //                })
            //
            //            })
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        self.present(nvc, animated: true, completion: nil)
    }
}
