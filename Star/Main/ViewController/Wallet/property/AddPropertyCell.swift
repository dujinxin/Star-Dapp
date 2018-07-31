//
//  AddPropertyCell.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class AddPropertyCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinShortNameLabel: UILabel!
    @IBOutlet weak var coinWholeNameLabel: UILabel!
    @IBOutlet weak var coinAddressLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var clickBlock : (()->())?
    
    @IBAction func addProperty(_ sender: Any) {
        let button = sender as! UIButton
        button.isEnabled = false
        button.setTitle("已添加", for: .normal)
        
        if let block = clickBlock {
            block()
        }
    }
    var entity: WalletPropertyEntity? {
        didSet {
            if (entity?.isAdded)! {
                self.addButton.setTitle("已添加", for: .normal)
                self.addButton.isEnabled = false
            } else {
                self.addButton.setTitle("添加", for: .normal)
                self.addButton.isEnabled = true
            }
            self.coinShortNameLabel.text = entity?.shortName
            self.coinWholeNameLabel.text = entity?.wholeName
            self.coinAddressLabel.text = entity?.address
            self.coinImageView.backgroundColor = UIColor.green
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
