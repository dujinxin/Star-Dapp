//
//  HomeVM.swift
//  Star
//
//  Created by 杜进新 on 2018/6/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class HomeVM: BaseViewModel {
    
    //首页
    lazy var homeEntity: HomeEntity = {
        let entity = HomeEntity()
        return entity
    }()
    var homeReusableVM : HomeReusableVM?
    //资产记录
    lazy var propertyRecordEntity: PropertyRecordEntity = {
        let entity = PropertyRecordEntity()
        return entity
    }()
    //邀请
    lazy var inviteEntity: InviteEntity = {
        let entity = InviteEntity()
        return entity
    }()
    
    func home(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.home.rawValue, param: [:], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.homeEntity.setValuesForKeys(result)
            if let coinRank = result["coinRank"] as? Array<Dictionary<String, Any>> {
                for i in 0..<coinRank.count {
                    let entity = CoinRankEntity()
                    let dict = coinRank[i]
                    if let ipe = dict["ipe"] as? Double {
                        entity.ipe = ipe
                    }
                    if let user = dict["user"] as? Dictionary<String,Any> {
                        let userEntity = HomeUserEntity()
                        userEntity.setValuesForKeys(user)
                        entity.user = userEntity
                    }
                    self.homeEntity.coinRankArray.append(entity)
                }
            }
            if let mineralInfo = result["mineralInfo"] as? Dictionary<String, Any> {
                if let award = mineralInfo["award"] as? Array<String> {
                    award.forEach({ (str) in
                        self.homeEntity.mineralInfoArray.append(str)
                        let diamondEntity = DiamondEntity()
                        diamondEntity.diamondId = str
                        diamondEntity.type = "award"
                        let components = str.components(separatedBy: "_")
                        if components.count > 1 {
                            diamondEntity.diamondNumber = components[1]
                        }
                        self.homeEntity.diamondArray.append(diamondEntity)
                    })
                }
                if let mineral = mineralInfo["mineral"] as? Array<String> {
                    mineral.forEach({ (str) in
                        self.homeEntity.mineralInfoArray.append(str)
                        let diamondEntity = DiamondEntity()
                        diamondEntity.diamondId = str
                        diamondEntity.type = "mineral"
                        let components = str.components(separatedBy: "_")
                        if components.count > 1 {
                            diamondEntity.diamondNumber = components[1]
                        }
                        self.homeEntity.diamondArray.append(diamondEntity)
                    })
                }
            }
            self.homeReusableVM = HomeReusableVM.init(entity: self.homeEntity)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func powerRank(limit:Int,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.powerRank.rawValue, param: ["limit":limit], success: { (data, msg) in
            
            guard let array = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.homeEntity.powerRankArray.removeAll()
            for i in 0..<array.count {
                let entity = PowerRankEntity()
                let dict = array[i]
                if let power = dict["power"] as? Int {
                    entity.power = power
                }
                if let user = dict["user"] as? Dictionary<String,Any> {
                    let userEntity = HomeUserEntity()
                    userEntity.setValuesForKeys(user)
                    entity.user = userEntity
                }
                self.homeEntity.powerRankArray.append(entity)
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func coinRank(limit:Int,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.propertyRank.rawValue, param: ["limit":limit], success: { (data, msg) in
            
            guard let array = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.homeEntity.coinRankArray.removeAll()
            for i in 0..<array.count {
                let entity = CoinRankEntity()
                let dict = array[i]
                if let ipe = dict["power"] as? Double {
                    entity.ipe = ipe
                }
                if let user = dict["user"] as? Dictionary<String,Any> {
                    let userEntity = HomeUserEntity()
                    userEntity.setValuesForKeys(user)
                    entity.user = userEntity
                }
                self.homeEntity.coinRankArray.append(entity)
            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func harvestDiamond(id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.harvestDiamond.rawValue, param: ["id":id], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    func propertyRecord(type: Int = 0, pageSize: Int = 20, pageNo: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.propertyRecord.rawValue, param: ["type": type,"pageSize": pageSize,"pageNo": pageNo], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let total = dict["total"] as? Int
                else{
                    completion(nil, self.message, false)
                    return
            }
            if total > 0 {
                guard
                    let list = dict["coinRecord"] as? Array<Dictionary<String, Any>>
                    else{
                        completion(nil, self.message, false)
                        return
                }
                if pageNo == 1 {
                    self.propertyRecordEntity.coinRecord.removeAll()
                }
                self.propertyRecordEntity.total = total
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = PropertyEntity()
                    entity.setValuesForKeys(dict)
                    self.propertyRecordEntity.coinRecord.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }

    func inviteInfo(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.inviteInfo.rawValue, param: [:], success: { (data, msg) in
            guard let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.inviteEntity.setValuesForKeys(dict)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
/*
军团名：神集逆苍穹（简称：逆苍穹）15519807255

军团介绍：军团成立于游戏开服之初，得益于游戏的一开始的火爆，大量玩家的涌入，军团也成立了逆水寒，逆天行两个分盟。随着游戏的进行，策略游戏么，大家都知道，人员逐渐流失比较严重，加上天美无节制的开服，还有就是一些恩怨之类的这里就不提了，总之，大浪淘沙之后，一些军团没落了，甚至解散了，包括大家熟知的黑十字，西凉，征战，还有很多已经叫不上名的，能够留下来的就剩下现在排名靠前的一些，以及后来商人自建的一些联盟，有幸的是直到昨天，逆苍穹，逆水寒，逆天行还都傲立在20区。

    昨天迎来了20区最大规模的一次空降，特别是一些军团整体加入20区，为了20区的繁荣，确实有人做了很多努力，为你们点赞，虽然我们立场不同。
    介绍下目前的状况：从排行可以看出来，吉祥，韩信接收了90%空降高战，军团整体实力一下子较原来上升了10%-20%。
    吉祥系：
    吉祥殿：帝王高战入驻，散人高战，吉祥低战分流（大部分加入了如意），
    如意殿：帝王当家，大部分帝王系加上吉祥部分人入驻，如意殿一下子从原来濒临解散的状况跃升到第四；
    龙凤殿：原如意人员大部分被分出去，重建龙凤殿，这样已经解散良久的龙凤殿死灰复燃；
    开泰殿：还有就是多了开泰殿（三羊开泰）应该也是吉祥系的吧
    韩信系：
    真韩信：战丶家族加入真韩信，低战分流加入了战三国（原逆天行，现已改名，为韩信二团）
    战三国：战家族当家，吸收部分韩信低战
     XXX ：筹建中
    逆苍穹：保密...
    逆水寒：灭世家族
    慢慢玩：小明治下的活跃军团
    神龙谷：太子领导下的活跃军团
    大汉盟：新加入空降军团
      .
      .
      .
    好了，看了上文，圈友们是不是对20区的军团有了个大致的了解了，那么言归正传，为了营造一个活跃的，有激情的大区，我们也希望为此出一份力，现在面向全服招募有志之士，欢迎喜欢激情喜欢热闹的你，你们。无论你是团体还是个人，20区逆苍穹都欢迎你们的加入，有意向的可以随时联系。
    咳！本着宁缺毋滥的原则，说下要求：散人玩家：27堡，5000w战以上（当前标准）；团体欢迎私聊，如果有团体不愿意分开的，我们愿意提供帮助，帮你们快速组建军团发展！
 
*/

/*
 20区【逆苍穹】详解暨招募帖之二
     有关军团历史及简介，前文已经有过介绍，这里就不赘述了（详见【20区逆苍穹招募帖】），今天呢着重介绍下军团目前的现状。
     开始介绍之前还是有别要提一下20区目前的形式，目前纸面上的实力来看：吉祥系排第一，韩信系排第二，逆苍穹第三，神龙系第四，慢慢玩
 军团第五...当然具体情况还要看实际大战情况，爆个料，这周末有好戏好上演哦，各位主公记得关注！！！
     之所以有目前的这样的现状，其实是有很多原因的，大环境下的外部因素就不说了，最主要是分盟疏于管理，低战人员流失严重...还有就是
 我们一直秉承的原则就是宁缺毋滥，只招募真心玩游戏的兄弟。墙头草、心态不好、妖言惑众、动摇军心的等等之类坚决不留，低贡献、只种地不参
 与活动者也同样在我们这里待不长。
     说到这里那就不得不说说我们待遇了，作为一个从开区一直到现在的大盟，我们的军团福利待遇不能说最好，但绝对出不了前二，从每次的活
 动就可以看出来，当然我本人没在其他大团待过，不做评价，这里仅介绍我们军团：
     1.军团满级：皇城、都城都有基地，6、7级资源丰富
     2.军团科技：发展资源系满级，军团建筑科技加速每天开启，集体吃鸡~~~
     3.军团活动：这是最有爱的，也是我本人最看重的，我们的集体活动从来没出过前二，大佬管理参与度100%的军团，大佬在线时长比成员在线时间都长。
     4.集体荣誉感：从军团活动可以看出我们的活跃，就可以看出我们的团结，我们绝对是最团结最认真的一群人，举个列子：从刚刚开放转区以来，不少人都选择了出去转转，旅游也好、定居也罢，这些都无所谓，我想说的是我们先后出去了10多个人，无一例外都回来了，为你们点赞@无伤@思念@水墨...
     5.团结坚强：前文说过了，军团管理大佬是比成员还活跃的存在，所以我们从来不怕被欺负，失去的东西我们会一起拿回来！
          .
          .
          .
    太多了，对于军团的未来，我相信也是各位主公最看重的，当然这也是我们最关心的，虽然这两天我们的动作有些落后吉祥韩信，一下子被拉开
 了差距，但这只是暂时的，6.8马上要有新的区开放转区了，各位主公拭目以待吧。
    透漏个消息！我们的寻欢大佬走了...走了...关注苍穹的一定很好奇，去哪里了？友情提示一下26区名聚，去干啥？自己猜...
    最后还是贴上我们的需求：
 散人玩家：27堡，5000w战以上（当前标准）；团体欢迎私聊@几多沧桑（微信：15519807255），如果有团体不愿意分开的，我们愿意提供帮
 助，帮你们快速组建军团发展！
    记住，我们招募的是，能长玩的，一起游戏的兄弟、追梦者，不是短驻的旅者，也不是四处转悠的流浪汉！
 
 */
