//
//  TaskViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/6/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TaskViewController: UITableViewController {

    let taskVM = TaskVM()
    let vm = IdentifyVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.taskVM.taskList { (_, msg, isSuc) in
            //
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                print("0")
            case 1:
                self.taskVM.createWallet { (_, msg, _) in
                    ViewManager.showNotice(msg)
                }
            case 2:
                self.taskVM.backupWallet { (_, msg, _) in
                    ViewManager.showNotice(msg)
                }
            case 3:
                self.taskVM.weChat("123456") { (_, msg, _) in
                    ViewManager.showNotice(msg)
                }
            case 4:
                self.identifyUserLiveness()
            default:
                self.performSegue(withIdentifier: "ModifyImage", sender: nil)
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
            self.vm.identifyInfo(param: [:], completion: { (_, msg, isSuc) in
                ViewManager.showNotice(msg)
                if isSuc {
                    let _ = UIImage.delete(name: "facePhoto.jpg")
                }
                self.dismiss(animated: true, completion: nil)
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
