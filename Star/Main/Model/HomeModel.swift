//
//  HomeModel.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class HomeEntity: BaseModel {
    @objc var coinRankArray = Array<CoinRankEntity>()
    @objc var powerRankArray = Array<PowerRankEntity>()
    @objc var mineralInfoArray = Array<String>()
    @objc var diamondArray = Array<DiamondEntity>()
    @objc var dailyLogin : String?
    @objc var power : Int = 0
    @objc var ipe : Double = 0
}
class CoinRankEntity: BaseModel {
    @objc var user : HomeUserEntity?
    @objc var ipe : Double = 0
}
class PowerRankEntity: BaseModel {
    @objc var user : HomeUserEntity?
    @objc var power : Int = 0
}
class HomeUserEntity: BaseModel {
    @objc var nickname : String?
    @objc var mobile : String?
}
class InviteEntity: BaseModel {
    @objc var inviteCount : String?
    @objc var invitePower : Double = 0
    @objc var inviteCode : String?
    @objc var nickname : String?
}
class DiamondEntity: BaseModel {
    @objc var type : String?
    @objc var diamondId : String?
    @objc var diamondNumber : String?
}
