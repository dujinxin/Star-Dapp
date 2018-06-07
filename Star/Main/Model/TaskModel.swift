//
//  TaskModel.swift
//  Star
//
//  Created by 杜进新 on 2018/6/6.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class TaskListEntity: BaseModel {
    @objc var id : String?
    @objc var name : String?
    @objc var title : String?
    @objc var power : Int = 0
    @objc var finishStatus : Bool = false
    @objc var statusStr : String?
}
