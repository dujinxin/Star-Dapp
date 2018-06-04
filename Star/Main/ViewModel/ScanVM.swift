//
//  ScanVM.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ScanVM: NSObject {

    //注册
    func scanResult(codeId:String,scanMobile:String?,longitude:String,latitude:String,model:String?,country:String?,province:String?,city:String?,district:String?,address:String?,street:String?,number:String?,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.scanResult.rawValue, param: ["codeId":codeId,"scanMobile":scanMobile,"longitude":longitude,"latitude":latitude,"model":model ?? "","country":country ,"province":province,"city":city,"district":district,"address":address,"street":street,"number":number], success: { (data, message) in
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
}
