//
//  TradeVM.swift
//  Star
//
//  Created by 杜进新 on 2018/7/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class TradeVM: BaseViewModel {
    
    //交易记录
    lazy var tradeListEntity: TradeListEntity = {
        let entity = TradeListEntity()
        return entity
    }()
    //交易详情
    lazy var tradeDetailEntity: TradeDetailEntity = {
        let entity = TradeDetailEntity()
        return entity
    }()
    var detailList = Array<CustomDetailEntity>()
    
    //交易记录列表
    func tradeRecord(pageSize:Int = 10,pageNo:Int,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.tradeList.rawValue, param: ["pageSize":pageSize,"pageNo":pageNo], success: { (data, msg) in
            
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
                if pageNo == 1 {
                    self.tradeListEntity.listArray.removeAll()
                }
                self.tradeListEntity.total = total
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = TradeEntity()
                    entity.setValuesForKeys(dict)
                    self.tradeListEntity.listArray.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    /// 交易详情
    func tradeDetails(_ id: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.tradeDetail.rawValue, param: ["id":id], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.tradeDetailEntity.setValuesForKeys(dict)
            self.customList()
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func customList() {
        
        if let entity = self.entity(key: "title") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "tradeTime") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "tradeAmount") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "tradeHash") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "blockHeight") {
            self.detailList.append(entity)
        }
    }
    
    func entity(key: String?) -> CustomDetailEntity? {
        guard let key = key, key.isEmpty == false else {
            return nil
        }
        let entity = CustomDetailEntity()
        switch key {
//        case "author":
//            entity.title = "交易hash"
//            entity.content = self.tradeDetailEntity.tradeHash ?? "上链中..."
        case "title":
            entity.title = "论文标题"
            entity.content = self.tradeDetailEntity.title
        case "tradeTime":
            entity.title = "交易时间"
            entity.content = self.tradeDetailEntity.tradeTime
        case "tradeAmount":
            entity.title = "交易金额"
            entity.content = "\(self.tradeDetailEntity.tradeAmount) IPE"
        case "tradeHash":
            entity.title = "交易地址"
            entity.content = self.tradeDetailEntity.tradeHash ?? "上链中..."
        case "blockHeight":
            entity.title = "区块高度"
            entity.content = "\(self.tradeDetailEntity.blockHeight)"
        default:
            return nil
        }
        return entity
    }
}
