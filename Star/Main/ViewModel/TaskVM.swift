//
//  TaskVM.swift
//  Star
//
//  Created by 杜进新 on 2018/6/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class TaskVM: BaseViewModel {
    var totalPower : Int = 0
    
    func taskList(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.taskList.rawValue, param: Dictionary(), success: { (data, msg) in
            guard
                let dict = data as? Dictionary<String, Any>,
                let power = dict["power"] as? Int
                else{
                    completion(nil, self.message, false)
                    return
            }
           
            guard
                let list = dict["tasks"] as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.totalPower = power
            self.dataArray.removeAll()
            for i in 0..<list.count{
                let dict = list[i]
                let entity = TaskListEntity()
                entity.setValuesForKeys(dict)
                self.dataArray.append(entity)
            }
 
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func createWallet(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.createWallet.rawValue, param: Dictionary(), success: { (data, msg) in
            
            //            guard let array = data as? Array<Dictionary<String, Any>>
            //                else{
            //                    completion(nil, self.message, false)
            //                    return
            //            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func backupWallet(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.copyWallet.rawValue, param: Dictionary(), success: { (data, msg) in
     
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func weChat(_ validateCode:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.weChat.rawValue, param: ["validateCode":validateCode], success: { (data, msg) in
            
            //            guard let array = data as? Array<Dictionary<String, Any>>
            //                else{
            //                    completion(nil, self.message, false)
            //                    return
            //            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
