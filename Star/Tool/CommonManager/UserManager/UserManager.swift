//
//  UserManager.swift
//  ZPSY
//
//  Created by 杜进新 on 2017/9/22.
//  Copyright © 2017年 zhouhao. All rights reserved.
//

import Foundation

private let userPath = NSHomeDirectory() + "/Documents/userAccound.json"

class UserEntity: BaseModel {
    
    @objc var authStatus : Int = 1 //用户认证状态，1未认证，2已认证，3已活体认证（人脸识别）
    @objc var smart_sid : String = ""//
    @objc var rank : Int = 0 
}

class UserManager : NSObject{
    
    static let manager = UserManager()
    
    //登录接口获取
    var userEntity = UserEntity()
    //
    var userDict = Dictionary<String, Any>()
    
    var isLogin: Bool {
        get {
            return !self.userEntity.smart_sid.isEmpty
        }
    }
    
    override init() {
        super.init()
        
        let pathUrl = URL(fileURLWithPath: userPath)
        
        guard
            let data = try? Data(contentsOf: pathUrl),
            let dict = try? JSONSerialization.jsonObject(with: data, options: [])else {
                print("该地址不存在用户信息：\(userPath)")
                return
        }
        self.userDict = dict as! [String : Any]
        self.userEntity.setValuesForKeys(dict as! [String : Any])
        print(dict)
        print("用户地址：\(userPath)")
        
    }
    
    /// 保存用户信息
    ///
    /// - Parameter dict: 用户信息字典
    /// - Returns: 保存结果
    func saveAccound(dict:Dictionary<String, Any>) -> Bool {
        let entity = UserEntity()
        entity.setValuesForKeys(dict)
        self.userEntity.authStatus = entity.authStatus
        self.userEntity.rank = entity.rank
        self.userEntity.smart_sid = entity.smart_sid

//        self.userEntity = UserEntity()
//        self.userEntity.setValuesForKeys(dict)
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
            else {
                return false
        }
        try? data.write(to: URL.init(fileURLWithPath: userPath))
        print("保存地址：\(userPath)")
        
        return true
    }
    /// 删除用户信息
    func removeAccound() {
        self.userEntity = UserEntity()
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: userPath)
    }
    
}
