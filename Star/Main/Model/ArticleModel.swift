//
//  ArticleModel.swift
//  Star
//
//  Created by 杜进新 on 2018/6/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class ArticleListEntity: BaseModel {
    @objc var artHashIndex : Int = 0
    @objc var artStatus : Int = 0
    @objc var coverImg : String?
    @objc var cdnUrl : String?
    @objc var id : String?
    @objc var title : String?
    @objc var releaseTime : String?
}
