//
//  PaperVM.swift
//  Star
//
//  Created by 杜进新 on 2018/7/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class PaperVM : BaseViewModel{
    var orderCount : Int = 0
    var articleDetailsEntity = ArticleDetailsEntity()
    var articleChainEntity = ArticleChainEntity()
    
    //论文列表
    lazy var paperListEntity: PaperListEntity = {
        let entity = PaperListEntity()
        return entity
    }()
    //论文详情
    lazy var paperDetailEntity: PaperEntity = {
        let entity = PaperEntity()
        return entity
    }()
    //邀请
    lazy var inviteEntity: InviteEntity = {
        let entity = InviteEntity()
        return entity
    }()
    
    
    /// 论文列表
    func paperList(append: Bool = false, pageSize: Int = 10, pageNo: Int,completion: @escaping ((_ data: Any?, _ msg: String,_ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.paperList.rawValue, param: ["pageSize":pageSize,"pageNo":pageNo], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let total = dict["total"] as? Int
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.paperListEntity.total = total
            if pageNo == 1 {
                self.paperListEntity.list.removeAll()
            }
            if total > 0 {
                guard
                    var list = dict["commentList"] as? Array<Dictionary<String, Any>>
                    else{
                        completion(nil, self.message, false)
                        return
                }
                if pageNo == 1 {
                    
                    for i in 0..<list.count{
                        let j = arc4random_uniform(UInt32(list.count))
                        print(j)
                        let dict = list.remove(at: Int(j)) //list[Int(j)]
                        let entity = PaperEntity()
                        entity.setValuesForKeys(dict)
                        self.paperListEntity.list.append(entity)
                    }
                } else {
                    for i in 0..<list.count{
                        let dict = list[i]
                        let entity = PaperEntity()
                        entity.setValuesForKeys(dict)
                        self.paperListEntity.list.append(entity)
                    }
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 论文详情
    func paperDetails(_ id: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.paperDetail.rawValue, param: ["id":id], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.paperDetailEntity.setValuesForKeys(dict)
          
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 论文购买
    func paperTrade(_ id: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.paperTrade.rawValue, param: ["id":id], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 论文购买
    func paperDownload(_ url: String, named: String = "123", process:@escaping ((_ process: Progress)->()), completion:@escaping ((_ isSuccess:Bool)->())) -> Void{
        JXRequest.download(urlStr: url, destination: { (fileUrl, urlResponse) -> (URL) in
            return URL.init(fileURLWithPath: NSHomeDirectory() + "/Documents/" + (urlResponse.suggestedFilename ?? named))
        }, progress: process) { (urlResponse, fileUrl, error) in
            //print(fileUrl)
            //print(urlResponse.textEncodingName,urlResponse.suggestedFilename)
            if let _ = error {
                completion(false)
            } else {
                completion(true)
            }
            
        }
    }
}
