//
//  Web3VM.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation
import web3swift

class Web3VM : NSObject{
    //https://mainnet.infura.io/v3/e91a846b69f14dc1a87fbd19a52955ed
    var web3 = Web3.InfuraMainnetWeb3(accessToken: "e91a846b69f14dc1a87fbd19a52955ed")
    
    //var web3 = Web3.new(URL(string: "http://192.168.0.129:8545")!)
    var keystore: EthereumKeystoreV3?
    
    init(keystoreData:Data) {
        super.init()
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreData) else {return}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)
        self.keystore = keystoreV3
    }
    init(keystoreJsonStr:String) {
        super.init()
        let keystoreJsonStr1 = String.convertKeystore(keystoreJsonStr)
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreJsonStr1) else {return}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)
        self.keystore = keystoreV3
    }
    init(keystoreBase64Str:String) {
        super.init()
        guard
            let keystoreData = Data.init(base64Encoded: keystoreBase64Str, options: .ignoreUnknownCharacters),
            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
                return
        }
        let keystoreJsonStr = String.convertKeystore(keystoreStr)
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreJsonStr) else {return}        
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)
        self.keystore = keystoreV3
    }
    
    
//    func convertKeystoreBy(_ keystoreData:String, removePrefix:String = "0x") -> String {
//        guard
//            let result = try? JSONSerialization.jsonObject(with: data, options: []),
//            var dict = result as? [String : Any],
//            let address = dict["address"] as? String
//            else {
//                fatalError("Not format keystoreData!")
//        }
//        if address.hasPrefix("0x"){
//            print("address：\(address)")
//            return data
//        } else {
//            let newAddress = "0x" + address
//            dict["address"] = newAddress
//            print("newAddress：\(newAddress)")
//            return try? JSONSerialization.data(withJSONObject: dict, options: [])
//        }
//    }
    
    func getKeystoreData() -> Data?{
        let pathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/keystore1.json")
        
        guard
            let data = try? Data(contentsOf: pathUrl) else {
                print("该地址不存在keystore文件：\(pathUrl)")
                return nil
        }
        
        guard
            let result = try? JSONSerialization.jsonObject(with: data, options: []),
            var dict = result as? [String : Any],
            let address = dict["address"] as? String
            else {
                print("该地址不存在用户信息：\(pathUrl)")
                return nil
        }
        print("keystore地址：\(pathUrl)")
        if address.hasPrefix("0x"){
            print("getKeystoreData func","address：\(address)")
            return data
        } else {
            let newAddress = "0x" + address
            dict["address"] = newAddress
            print("newAddress：\(newAddress)")
            return try? JSONSerialization.data(withJSONObject: dict, options: [])
        }
        //self.userDict = dict as! [String : Any]
        
        //        return data
    }
}
extension String {
    
    static func convertKeystore(_ keystoreStr:String, addPrefix:String = "0x") -> String {
        
        guard
            let data = keystoreStr.data(using: .utf8),
            let result = try? JSONSerialization.jsonObject(with: data, options: []),
            var dict = result as? [String : Any],
            let address = dict["address"] as? String
            else {
                fatalError("Not format keystoreData!")
        }
        if address.hasPrefix("0x"){
            print("convertKeystore func","address：\(address)")
            return keystoreStr
        } else {
            let newAddress = "0x" + address
            dict["address"] = newAddress
            print("newAddress：\(newAddress)")
            guard
                let newData = try? JSONSerialization.data(withJSONObject: dict, options: []),
                let newKeystoreStr = String.init(data: newData, encoding: .utf8) else {
                    fatalError("convertKeystore error")
            }
            return newKeystoreStr
        }
    }
    static func convertBase64Str(_ str:String) -> String {
        guard
            let keystoreData = Data.init(base64Encoded: str, options: .ignoreUnknownCharacters),
            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
                fatalError("convertString error")
        }
        return keystoreStr
    }
}
