//
//  PropertyModel.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PropertyModel: BaseModel {

}

class WalletPropertyEntity: PropertyModel {
    
    @objc var shortName : String?
    @objc var wholeName : String?
    @objc var address   : String?
    @objc var isAdded   : Bool = false
    @objc var image     : String?
    
    @objc var coinNum   : String?
    
}
