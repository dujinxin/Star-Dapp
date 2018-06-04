//
//  LoginVM.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/23.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
import AFNetworking

class LoginVM: JXRequest {


    lazy var userModel = UserModel()
    
    var dataArray = [[String:AnyObject]]()
    //获取图片验证码 & 改为直接拼接URL展示
    func getImageCode(type:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.getImageCode.rawValue, param: ["method":type], success: { (data, message) in
            
            guard let _ = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //注册
    func register(mobile:String,inviteCode:String?,mobileCode:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.register.rawValue, param: ["mobile":mobile,"inviteCode":inviteCode ?? "","mobileValidateCode":mobileCode], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            print(dict)
            let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //实名认证
    func identifyAuth(name:String,idNumber:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.identityAuth.rawValue, param: ["name":name,"idNumber":idNumber], success: { (data, message) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let authStatus = dict["authStatus"] as? Int
                else{
                    completion(nil,message,false)
                    return
            }
            if authStatus == 2 {
                UserManager.manager.userDict["authStatus"] = 2
                let _ = UserManager.manager.saveAccound(dict: UserManager.manager.userDict)
                completion(authStatus,dict["message"] as! String,true)
            } else {
                completion(authStatus,dict["message"] as! String,false)
            }
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //发送验证码
    func sendMobileCode(mobile:String,method:String = "register",validateCode:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        var url = ApiString.sendMobileCodeRegister.rawValue
        if method == "register" {
            url = ApiString.sendMobileCodeRegister.rawValue + "?deviceId=\(UIDevice.current.uuid)"
        } else {
            url = ApiString.sendMobileCodeLogin.rawValue + "?deviceId=\(UIDevice.current.uuid)"
        }
        JXRequest.request(url: url, param: ["mobile":mobile,"method":method,"validateCode":validateCode], success: { (data, message) in
            
            guard let _ = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    
    
    func login(userName:String, code:String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(url: ApiString.login.rawValue, param: ["username":userName,"mobileValidateCode":code], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            print(dict)
            let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }

    func personInfo(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.personInfo.rawValue, param: Dictionary(), success: { (data, message) in
            
            guard let dict = data as? Dictionary<String, Any>
                else{
                completion(data,message,false)
                return
            }
            
//            UserManager.manager.userEntity.name = dict["name"] as? String
//            UserManager.manager.userEntity.idCard = dict["idCard"] as? String
//            UserManager.manager.userEntity.validStatus = dict["validStatus"] as! Int
            
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
        
    }
    func modify(nickName:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.modifiyNickName.rawValue, param: ["nickname":nickName], success: { (data, message) in
            
            UserManager.manager.userDict["nickname"] = nickName
            //UserManager.manager.userEntity.nickname = nickName
            
            let _ = UserManager.manager.saveAccound(dict: UserManager.manager.userDict)
            
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
        
    }

    
    func modifyPassword(old:String,new:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) {
        JXRequest.request(url: ApiString.modifiyPwd.rawValue, param: ["oldPassword":old,"newPassword":new], success: { (data, message) in
            
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
        
    }
    func logout(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) {
        JXRequest.request(url: ApiString.logout.rawValue, param: Dictionary(), success: { (data, message) in
            
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
}

class IdentifyVM: JXRequest {
    
    var userData = Data()
    var frontImage = UIImage()
    var backImage = UIImage()
    
    var imageArray : Array<String> = ["facePhoto","idCardFront","idCardBack"]
    
    
    //识别
    func zpsyIdentifyInfo(param:Dictionary<String,Any> ,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        IdentifyVM.request(url: ApiString.identifyInfo.rawValue, param: param, success: { (data, message) in
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    override func customConstruct() -> JXBaseRequest.constructingBlock? {
        return {(_ formData : AFMultipartFormData) -> () in
            let format = DateFormatter()
            format.dateFormat = "yyyyMMddHHmmss"
            let timeStr = format.string(from: Date.init())
            
            for obj in self.imageArray {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] + "/\(obj)"
                if obj == "facePhoto"{
                    
                    let pathUrl = URL.init(fileURLWithPath: path)
                    guard let data = try? Data(contentsOf: pathUrl) else{
                        return
                    }
                    let stream = InputStream.init(data: data)
                    formData.appendPart(with: stream, name: obj, fileName: "\(obj)\(timeStr)", length: Int64(data.count), mimeType: "image/jpeg")
                    print(data)
                }else{
                    let pathUrl = URL.init(fileURLWithPath: path + ".jpg")
                    guard let data = try? Data(contentsOf: pathUrl) else{
                        return
                    }
                    let stream = InputStream.init(data: data)
                    formData.appendPart(with: stream, name: obj, fileName: "\(obj)\(timeStr).jpg", length: Int64(data.count), mimeType: "image/jpeg")
                    print(data)
                }
                
            }
            
        }
    }
}
