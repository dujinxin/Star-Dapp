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
    
    func loadNewMainData(append:Bool = false,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        
        JXRequest.request(url: ApiString.exposureList.rawValue, param: Dictionary(), success: { (data, msg) in
            
            guard let array = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.dataArray.removeAll()
            for i in 0..<array.count{
                let model = BaseModel()
                let dict = array[i]
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
