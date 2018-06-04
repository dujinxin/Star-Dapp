//
//  PropertyCell.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PropertyCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var coinType: UILabel!
    @IBOutlet weak var coinNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
