//
//  MyVM.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MyVM: NSObject {
    
    var ipe : Double = 0
    
    
//    //注册
//    func scanResult(codeId:String,scanMobile:String?,longitude:String,latitude:String,model:String?,country:String?,province:String?,city:String?,district:String?,address:String?,street:String?,number:String?,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
//        JXRequest.request(url: ApiString.scanResult.rawValue, param: ["codeId":codeId,"scanMobile":scanMobile,"longitude":longitude,"latitude":latitude,"model":model ?? "","country":country ,"province":province,"city":city,"district":district,"address":address,"street":street,"number":number], success: { (data, message) in
//            completion(data,message,true)
//        }) { (message, code) in
//            completion(nil,message,false)
//        }
//    }
    
    func property(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.property.rawValue, param: Dictionary(), success: { (data, message) in
            guard let dict = data as? Dictionary<String, Any>,
                let zcoinBalance = dict["ipe"] as? Double
                else{
                    completion(nil,message,false)
                    return
            }
            print(zcoinBalance)
            self.ipe = zcoinBalance
            
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
        
    }
}
