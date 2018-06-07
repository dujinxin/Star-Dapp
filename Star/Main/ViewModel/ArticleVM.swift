//
//  ArticleVM.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class ArticleVM : BaseViewModel{
    var orderCount : Int = 0
    
    /// 文章列表
    func articleList(append:Bool = false,pageSize:Int = 20,pageNo:Int,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.articleList.rawValue, param: ["pageSize":pageSize,"pageNo":pageNo], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let total = dict["total"] as? Int
                else{
                    completion(nil, self.message, false)
                    return
            }
            if total > 0 {
                guard
                    let list = dict["list"] as? Array<Dictionary<String, Any>>
                    else{
                        completion(nil, self.message, false)
                        return
                }
                self.dataArray.removeAll()
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = ArticleListEntity()
                    entity.setValuesForKeys(dict)
                    self.dataArray.append(entity)
                }
            }

            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 文章详情
    func articleDetails(_ articleId:String,articleHash:Int,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.articleDetails.rawValue, param: ["id":articleId,"artHashIndex":articleHash], success: { (data, msg) in

            guard let array = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, self.message, false)
                    return
            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 阅读文章
    func articleRead(_ articleId:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.articleRead.rawValue, param: [:], success: { (data, msg) in
            
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
