//
//  PaperModel.swift
//  Star
//
//  Created by 杜进新 on 2018/7/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

/// 论文列表
/**
 "commentList": [
         {
         "id": "2",
         "author": "toni,mary",
         "title": "论文标题2号",
         "issue": "2017年第2期",
         "source": "中国青年",
         "tradeCount": 0
         },
  "total": 2
 */
class PaperListEntity: BaseModel {
    var total : Int = 0
    @objc var list : Array<PaperEntity> = Array()
}

/// 论文详情
/**
     "id": "1",
     "author": "toni,mary",
     "title": "论文标题1号",
     "issue": "2018年第3期",
     "office": "国务院",
     "fund": "天使基金",
     "keyword": "ssm,Spring",
     "doi": "aaa",
     "source": "中国青年",
     "tradePrice": 0.01,
     "tradeCount": 2,
     "publishTime": "2018-07-23",
     "thesisAbstract": "这是一个摘要",
     "downloadUrl": "http://p9klrvbyx.bkt.clouddn.com/Fhkiec3QEkLLtvDvd3g0OkfBM5kO",
     "payed": true
 */
class PaperEntity: BaseModel {
    @objc var id : Int = 0 //列表共用，下同
    @objc var author : String?//
    @objc var title : String?//
    @objc var issue : String?//
    @objc var office : String?
    @objc var fund : String?
    @objc var keyword : String?
    @objc var doi : String?
    @objc var source : String?//
    @objc var tradePrice : Double = 0
    @objc var tradeCount : Int = 0//
    @objc var publishTime : String?
    @objc var thesisAbstract : String?
    @objc var downloadUrl : String?
    @objc var payed : Int = 0
}


