//
//  TaskModel.swift
//  Star
//
//  Created by 杜进新 on 2018/6/6.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class TaskListEntity: BaseModel {
    @objc var power : Int = 0
    @objc var tasks = Array<TaskEntity>()
}
class TaskEntity: BaseModel {
    @objc var id : Int = 0
    @objc var name : String?
    @objc var title : String?
    @objc var power : Int = 0
    @objc var finishStatus : Int = 0
    @objc var statusStr : String?
}
class PowerRecordEntity: BaseModel {
    @objc var powerRecordArray = Array<PowerEntity>()
    @objc var total : Int = 0
}
class PowerEntity: BaseModel {
    @objc var categoryInfo : String?
    @objc var id : Int = 0
    @objc var power : Int = 0
    @objc var time : String?
}
