//
//  MyModel.swift
//  Star
//
//  Created by 杜进新 on 2018/6/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class IndentifyInfoEntity: BaseModel {
    @objc var idNumber : String?
    @objc var name : String?
    @objc var mobile : String?
    @objc var faceAuth : Int = 0
}

class ProfileInfoEntity: BaseModel {
    @objc var nickname : String?
    @objc var rank : Int = 0
    @objc var avatar : String?
    @objc var mobile : String?
}

class PropertyRecordEntity: BaseModel {
    @objc var coinRecord = Array<PropertyEntity>()
    @objc var total : Int = 0
}
class PropertyEntity: BaseModel {
    @objc var categoryInfo : String?
    @objc var id : Int = 0
    @objc var ipe : Double = 0
    @objc var time : String?
}
