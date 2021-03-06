//
//  TaskVM.swift
//  Star
//
//  Created by 杜进新 on 2018/6/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class TaskVM: BaseViewModel {
    
    var taskListEntity = TaskListEntity()
    var powerRecordEntity = PowerRecordEntity()
    
    var finishTaskPower : Double = 0
    
    
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
            self.taskListEntity.power = power
            self.taskListEntity.tasks.removeAll()
            for i in 0..<list.count{
                let dict = list[i]
                let entity = TaskEntity()
                entity.setValuesForKeys(dict)
                self.taskListEntity.tasks.append(entity)
                
            }
 
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func powerRecord(pageSize:Int = 20,pageNo:Int,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.powerRecord.rawValue, param: ["pageSize":pageSize,"pageNo":pageNo], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>
//                ,
//                let total = dict["total"] as? Int
                else{
                    completion(nil, self.message, false)
                    return
            }
//            if total > 0 {
                guard
                    let list = dict["powerRecord"] as? Array<Dictionary<String, Any>>
                    else{
                        completion(nil, self.message, false)
                        return
                }
                if pageNo == 1 {
                    self.powerRecordEntity.powerRecordArray.removeAll()
                }
//                self.powerRecordEntity.total = total
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = PowerEntity()
                    entity.setValuesForKeys(dict)
                    self.powerRecordEntity.powerRecordArray.append(entity)
                }
//            }
            
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
            guard let dict = data as? Dictionary<String, Any>,let power = dict["power"] as? Double
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.finishTaskPower = power
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
