//
//  OcrVM.swift
//  Star
//
//  Created by 杜进新 on 2018/5/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

let BASE_URL = "https://aip.baidubce.com"
let ACCESS_TOEKN_URL = String(format: "%@/oauth/2.0/token", BASE_URL)
let LIVENESS_VS_IDCARD_URL = String(format: "%@/rest/2.0/face/v3/person/verify", BASE_URL)

class OcrVM: JXRequest {

    var accessToken : String = ""
    
    override func handleResponseResult(result: Any?) {
        var msg = "请求失败"
        var netCode : JXNetworkError = .kResponseUnknow
        var data : Any? = nil
        var isSuccess : Bool = false
        
        print("requestParam = \(String(describing: param))")
        print("requestUrl = \(String(describing: requestUrl))")
        
        if result is Dictionary<String, Any> {
            
            let jsonDict = result as! Dictionary<String, Any>
            print("responseData = \(jsonDict)")
            isSuccess = true
            data = result
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

    override func handleResponseResult(result:Any?,message:String,code:JXNetworkError,isSuccess:Bool) {
        
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


    /// 获取access_token
    /*
     向授权服务地址https://aip.baidubce.com/oauth/2.0/token发送请求（推荐使用POST），并在URL中带上以下参数：
     
     grant_type：    必须参数，固定为client_credentials；
     client_id：     必须参数，应用的API Key；
     client_secret： 必须参数，应用的Secret Key；
     成功
     {
        "refresh_token": "25.b55fe1d287227ca97aab219bb249b8ab.315360000.1798284651.282335-8574074",
        "expires_in": 2592000, //Access Token的有效期(秒为单位，一般为1个月)
        "scope": "public wise_adapt",
        "session_key": "9mzdDZXu3dENdFZQurfg0Vz8slgSgvvOAUebNFzyzcpQ5EnbxbF+hfG9DQkpUVQdh4p6HbQcAiz5RmuBAja1JJGgIdJI",
        "access_token": "24.6c5e1ff107f0e8bcef8c46d3424a0e78.2592000.1485516651.282335-8574074",
        "session_secret": "dfac94a3489fe9fca7c3221cbf7525ff"
     }
     失败
     {
         "error": "invalid_client",
         "error_description": "unknown client id"
     }
     error             error_description               解释
     
     invalid_client    unknown client id               API Key不正确
     invalid_client    Client authentication failed    Secret Key不正确
    */
    ///
    /// - Parameter completion: 回调
    func getAccessToken(apiKey:String,secretKey:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        OcrVM.request(url: ACCESS_TOEKN_URL, param: ["grant_type":"client_credentials","client_id":apiKey,"client_secret":secretKey], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>,
                let access_token = dict["access_token"] as? String
                else{
                    completion(nil,message,false)
                    return
            }
            self.accessToken = access_token
            print(dict)
            
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    ///返回值
    /*
     {
     cached = 0;
     "error_code" = 0;
     "error_msg" = SUCCESS;
     "log_id" = 2837662859;
     result =  {
          score = "93.97930907999999";
     };
     timestamp = 1527232847;
     }
     */
    /// 身份验证
    ///
    /// - Parameters:
    ///   - name: 姓名（注：需要进行utf8编码）
    ///   - idNumber: 身份证号码
    ///   - imageStr: 图片信息(总数据大小应小于10M)，图片上传方式根据image_type来判断
    ///   - image_type: 图片类型 BASE64:图片的base64值，base64编码后的图片数据，需urlencode，编码后的图片大小不超过2M；URL:图片的 URL地址( 可能由于网络等原因导致下载图片时间过长)**；FACE_TOKEN: 人脸图片的唯一标识，调用人脸检测接口时，会为每个人脸图片赋予一个唯一的FACE_TOKEN，同一张图片多次检测得到的FACE_TOKEN是同一个。
    ///   - quality_control: 图片质量控制 NONE: 不进行控制,LOW:较低的质量要求,NORMAL: 一般的质量要求,HIGH: 较高的质量要求,默认 NONE
    ///   - liveness_control: 活体检测控制 NONE: 不进行控制,LOW:较低的活体要求(高通过率 低攻击拒绝率),NORMAL: 一般的活体要求(平衡的攻击拒绝率, 通过率),HIGH: 较高的活体要求(高攻击拒绝率 低通过率),默认NONE
    ///   - completion: 回调
    func ocr(name:String,idNumber:String,imageStr:String,image_type:String = "BASE64",quality_control:String = "NONE",liveness_control:String = "NONE",completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) {
        OcrVM.request(url: String(format: "%@?access_token=%@", LIVENESS_VS_IDCARD_URL,self.accessToken),
                          param: ["name":name,
                                  "image":imageStr,
                                  "id_card_number":idNumber,
                                  "quality_control":quality_control,
                                  "liveness_control":liveness_control,
                                  "image_type":image_type
                        
            ], success: { (data, msg) in
                completion(data,msg,true)
        }, failure: { (msg, code) in
            print(msg,code)
            completion(nil,msg,false)
        })
    }
}
