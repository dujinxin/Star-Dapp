//
//  TradeListCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TradeListCell: UITableViewCell {

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var payView: UILabel!
    
    var entity : TradeEntity? {
        didSet {
            self.titleView.text = entity?.title
            self.timeView.text = entity?.tradeTime
            self.payView.text = "- \(entity?.tradeAmount ?? 0) IPE"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
