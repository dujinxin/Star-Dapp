
//
//  JXRequest.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/12.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

class JXRequest: JXBaseRequest {
    

    var construct : constructingBlock? {
        set{
            self.construct = newValue
        }
        get{
            return nil
        }
    }
    override func customConstruct() ->constructingBlock?  {
        return nil
    }
    
    override func requestSuccess(responseData: Any) {
        super.requestSuccess(responseData: responseData)
        
        let isJson = JSONSerialization.isValidJSONObject(responseData)
        print(isJson)
        if responseData is Dictionary<String,Any> {
            print("responseData is Dictionary")
        }else if responseData is Data{
            print("responseData is Data")
        }else if responseData is String{
            print("responseData is String")
        }

//        guard let data = responseData as? Data,
//            let str = String.init(data: data, encoding: .utf8)
//            else{
//                handleResponseResult(result: nil, message: "数据解析失败", code: JXNetworkError.kResponseUnknow, isSuccess: false)
//                return
//        }
        
        
        guard let data = responseData as? Data,
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            else{
                handleResponseResult(result: nil, message: "数据解析失败", code: JXNetworkError.kResponseUnknow, isSuccess: false)
                return
        }
        
        handleResponseResult(result: jsonData)
        
    }
    override func requestFailure(error: Error) {
        print("请求失败:\(error)")
        handleResponseResult(result: error)
    }
    func handleResponseResult(result:Any?) {
        var msg = "请求失败"
        var netCode : JXNetworkError = .kResponseUnknow
        var data : Any? = nil
        var isSuccess : Bool = false
        
        print("requestParam = \(String(describing: param))")
        print("requestUrl = \(String(describing: requestUrl))")
        
        if result is Dictionary<String, Any> {
            
            let jsonDict = result as! Dictionary<String, Any>
            print("responseData = \(jsonDict)")
            
            let message = jsonDict["message"] as? String
            
            guard
                let codeStr = jsonDict["code"] as? Int,
                //let codeNum = Int(codeStr),
                let code = JXNetworkError(rawValue: codeStr)
                else {
                    msg = "状态码未知"
                    handleResponseResult(result: nil, message: message ?? msg, code: .kResponseDataError, isSuccess: isSuccess)
                    return
            }
            
            
            netCode = code
            
            if (code == .kResponseSuccess){
                print("请求成功")
                data = jsonDict["result"]
                msg = message ?? "请求成功"
                isSuccess = true
            }else if code == .kResponseTokenDisabled{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: false)
            }else if code == .kResponseLoginFromOtherDevice{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginFromOtherDevice), object: false)
            }else{
                print("请求失败")
                msg = message ?? "请求失败"
            }
        }else if result is Array<Any>{
            print("Array")
        }else if result is String{
            print("String")
        }else if result is Error{
            print("Error")
            guard let error = result as? NSError,
                let code = JXNetworkError(rawValue: error.code)
                else {
                    handleResponseResult(result: data, message: "Error", code: .kResponseUnknow, isSuccess: isSuccess)
                    return
            }
            netCode = code
            
            switch code {
            case .kRequestErrorCannotConnectToHost,
                 .kRequestErrorCannotFindHost,
                 .kRequestErrorNotConnectedToInternet,
                 .kRequestErrorNetworkConnectionLost,
                 .kRequestErrorUnknown:
                msg = kRequestNotConnectedDomain;
                break;
            case .kRequestErrorTimedOut:
                msg = kRequestTimeOutDomain;
                break;
            case .kRequestErrorResourceUnavailable:
                msg = kRequestResourceUnavailableDomain;
                break;
            case .kResponseDataError:
                msg = kRequestResourceDataErrorDomain;
                break;
            default:
                msg = error.localizedDescription;
                break;
            }
            
        }else{
            print("未知数据类型")
        }
        handleResponseResult(result: data, message: msg, code: netCode, isSuccess: isSuccess)
    }
    func handleResponseResult(result:Any?,message:String,code:JXNetworkError,isSuccess:Bool) {
        
        guard
            let success = self.success,
            let failure = self.failure
            else {
                return
        }
        
        if isSuccess {
            success(result,message)
        }else{
            failure(message,code)
        }
    }

}
