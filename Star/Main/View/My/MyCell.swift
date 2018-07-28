//
//  MyCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var modifyBlock : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 200 + kNavStatusHeight)
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        self.topConstraint.constant = kNavStatusHeight
        
        self.userImageView.layer.cornerRadius = 40
        self.userImageView.layer.masksToBounds = true
        self.userImageView.clipsToBounds = true
        
        self.userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(modifyImage)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func modifyImage() {
        if let block = modifyBlock {
            block()
        }
    }
}
