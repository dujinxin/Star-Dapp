//
//  String+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/29.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation
import UIKit

enum  RegularExpression : String{
    case none   =    ""          //
    
    case phone  =    "^1\\d{10}$"//手机号，只做1开头11位的基本校验
    case identityCard  =  "^(\\d{14}|\\d{17})(\\d|[xX])$"//身份证号
    case number = "[0-9]*" //数字
    case letter = "[a-zA-Z]*" //字母
    case chinese = "[\\u4e00-\\u9fa5]+"  //汉字
    case numberOrNumber = "[a-zA-Z0-9]*" //数字或字母
    case code4 = "^[0-9]{4}+$" //四位验证码
    case code6 = "^[0-9]{6}+$" //六位验证码
//    case number = ""
    
}

extension String {
    
    /// 字符串校验
    ///
    /// - Parameters:
    ///   - string: 需要校验的字符串
    ///   - type: 类型
    /// - Returns: 结果
    func validate(type:RegularExpression) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return predicate.evaluate(with: self)
    }
    static func validate(_ string:String, type:RegularExpression) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return predicate.evaluate(with: string)
    }
    /// 手机号，只做1开头11位的基本校验
    ///
    /// - Parameter tel: 手机号码
    /// - Returns: 返回是否符合校验
    static func validateTelephone(tel:String) -> Bool {
        //手机号以13， 15，18开头，八个 \d 数字字符
        //NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        //只做1开头，11位的校验，其他详细的交给后台来做
        let phoneRegex = "^1\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: tel)
    }
    ///身份证号
    static func validateID(id:String) -> Bool {
        
        let passWordRegex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: id)
    }
    //用户名 6-16位只含有汉字、数字、字母、下划线，下划线位置不限
//    func validateUserName(name:String) -> Bool {
//        let userNameRegex = "^[a-zA-Z0-9_\u4e00-\u9fa5]{2,12}+$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
//        return predicate.evaluate(with: name)
//    }
    //密码  8-16位数字或字母 ^[a-zA-Z0-9]{8,16}+$
    // 数字和密码的组合，不能纯数字或纯密码 ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$
    static func validatePassword(passWord:String) -> Bool {
        
        let passWordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: passWord)
    }
    static func validateVerficationCode(code:String) -> Bool {
        
        let passWordRegex = "^[0-9]{4}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: code)
    }
    static func validateCode(code:String) -> Bool {
        
        let passWordRegex = "^[0-9]{12}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: code)
    }
    static func validateFootCode(code:String) -> Bool {
        
        let passWordRegex = "^[0-9]{8}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: code)
    }
    /// 纯数字
    ///
    /// - Parameter string: 要检验的字符串
    /// - Returns: 返回结果true/false
    static func validateNumber(string:String) -> Bool {
        
        let passWordRegex = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: string)
    }
    /// 纯字母
    ///
    /// - Parameter string: 要检验的字符串
    /// - Returns: 返回结果true/false
    static func validateLetter(string:String) -> Bool {
        
        let passWordRegex = "[a-zA-Z]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: string)
    }
    /// 纯汉字
    ///
    /// - Parameter string: 要检验的字符串
    /// - Returns: 返回结果true/false
    static func validateChinese(string:String) -> Bool {
        
        let passWordRegex = "[\\u4e00-\\u9fa5]+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: string)
    }
    /// 字母或数字
    ///
    /// - Parameter string: 要检验的字符串
    /// - Returns: 返回结果true/false
    static func validateNumberOrLetter(string:String) -> Bool {
        
        let passWordRegex = "[a-zA-Z0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        return predicate.evaluate(with: string)
    }
    
    static func validate(_ string:String?,type:RegularExpression,emptyMsg:String?,formatMsg:String) -> Bool{
        guard let str = string, str.isEmpty == false else {
            ViewManager.showNotice(emptyMsg ?? formatMsg)
            return false
        }
        if type == .none {
            return true
        }
        if !self.validate(str, type: type) {
            ViewManager.showNotice(formatMsg)
            return false
        } else {
            return true
        }
    }
}
//MARK:计算
extension String {
    
    func calculate(width: CGFloat,fontSize:CGFloat,lineSpace:CGFloat = -1) -> CGSize {
        
        if self.isEmpty {
            return CGSize()
        }
        
        let ocText = self as NSString
        var attributes : Dictionary<NSAttributedStringKey, Any>
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = lineSpace
        
        if lineSpace < 0 {
            attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize)]
        }else{
            attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize),NSAttributedStringKey.paragraphStyle:paragraph]
        }
        
        let rect = ocText.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading,.usesDeviceMetrics], attributes: attributes, context: nil)
        
        let height : CGFloat
        if rect.origin.x < 0 {
            height = abs(rect.origin.x) + rect.height
        }else{
            height = rect.height
        }
        
        return CGSize(width: width, height: height)
    }
}
//MARK:加密
extension String {
    func md5(string:String) -> String {
        return MD5.encode(string)
    }
    func base64encode(string:String) -> String? {
        return Base64.stringDecode(string)
    }
    func base64decode(string:String) -> String? {
        return Base64.stringDecode(string)
    }
}