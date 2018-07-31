//
//  WalletHeadCell.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/1.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletHeadCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var codeButton: UIButton!
    
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
