//
//  CommentModel.swift
//  Star
//
//  Created by 杜进新 on 2018/6/6.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class CommentListEntity: BaseModel {
    @objc var id : String?
    @objc var topStatus : Int = 0
    @objc var showStatus : Int = 0
    @objc var commentRepl : String?
    @objc var createDateStr : String?
    @objc var user : UserEntity1?
}
