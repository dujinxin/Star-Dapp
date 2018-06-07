
//
//  ApiEnum.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/9.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import Foundation

enum ApiString : String {
    
    case getImageCode =              "/smart/validateCode" // 获取图片验证码 注册、登录时发送短信验证码需要
    case sendMobileCodeRegister =    "/smart/register/sendMobileCode"    //发送短信验证码
    case sendMobileCodeLogin   =     "/smart/login/sendMobileCode"    //登录时发送短信验证码
    case login =                     "/smart/login"     //用户登录
    case logout =                    "/smart/logout"    //用户登出
    case register =                  "/smart/register/doRegister"    //用户注册
    case identityAuth =              "/smart/register/identityAuth"    //身份证+姓名认证
    
    case home =                      "/smart/index"             //显示首页挖矿、资产、算力、排行等信息
    case powerRank =                 "/smart/home/powerRank"    //智慧值（算力）排行
    case propertyRank =              "/smart/home/coinRank"     //智果值（ipe）排行
    case inviteInfo =     "/smart/fixedTask/inviteInfo"         //邀请好友页面，包含我的邀请码，累计获得ipe数量等
    case taskList =     "/smart/user/powerTask"                 //提升智慧页面,包含未完成任务
    case taskRecord =    "/smart/fixedTask/record"             //固定任务完成记录
    
    case liveAuth =                 "/smart/fixedTask/faceAuth"           //人脸身份识别
    case modifyAvatar  =            "/smart/fixedTask/updateAvatar"       //修改头像
    case modifyNickName  =          "/smart/user/updateNickname"          //修改昵称
    case weChat =                   "/smart/fixedTask/wechatSubscribe"    //关注公众号验证码验证
    case createWallet =             "/smart/fixedTask/createWallet"       //创建链上钱包
    case copyWallet  =              "/smart/fixedTask/backupWallet"       //备份链上钱包
    case profileInfo =              "/smart/my/baseInfo"                  //我的基础信息 ，昵称，头像，注册排行
    case myProperty  =              "/smart/my/asset"                     //我的资产
    case myIdentity  =              "/smart/my/identity"                  //我的实名信息
    
    
    case articleList =              "/smart/article/list"    //文章列表
    case articleDetails  =          "/smart/article/detail"    //文章详情
    case articleLike =    "/smart/article/like"    //文章点赞，不允许取消
    case articleComment =           "/smart/article/comment"    //评论文章
    case articleRead =    "/smart/article/read"    //阅读任务
    case articleCommentList =    "/smart/article/commentList"    //评论列表
    case articelQueryByBlockChain =    "/smart/article/queryByChain"    //查看文章上链信息
    
    
    case modifiyPwd       = "/user/updatePassword"
    case personInfo       = "/user/realInfo"
    
    
    case property         = "/wallet/getMyCoin"

}
