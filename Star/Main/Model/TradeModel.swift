
//
//  TradeModel.swift
//  Star
//
//  Created by 杜进新 on 2018/7/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class TradeListEntity: BaseModel {
    @objc var total : Int = 0
    @objc var listArray = Array<TradeEntity>()
}

class TradeEntity: BaseModel {
    @objc var id : String?
    @objc var fileId : Int = 0
    @objc var title : String?
    @objc var tradeAmount : Double = 0
    @objc var tradeTime : String?
}

class TradeDetailEntity: BaseModel {
    @objc var id : String?
    @objc var fileId : Int = 0
    @objc var title : String?
    @objc var url : String?
    @objc var blockHash : String?
    @objc var blockStatus : Int = 0
    @objc var blockHeight : Int = 0//
    @objc var tradeAmount : Double = 0
    @objc var tradeTime : String?
    @objc var tradeHash : String?
}
