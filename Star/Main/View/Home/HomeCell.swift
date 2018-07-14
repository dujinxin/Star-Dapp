//
//  HomeCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {


    @IBOutlet weak var subContentView: UIView!
    @IBOutlet weak var indexButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    var coinEntity: CoinRankEntity? {
        didSet{
            self.titleLabel.text = coinEntity?.user?.nickname
            self.numberLabel.text = "\(coinEntity?.ipe ?? 0)"
        }
    }
    var powerEntity: PowerRankEntity? {
        didSet{
            self.titleLabel.text = powerEntity?.user?.nickname
            self.numberLabel.text = "\(powerEntity?.power ?? 0)"
        }
    }
    var indexPath : IndexPath? {
        didSet{
            self.indexButton.setTitle("\((indexPath?.row ?? 0) + 1)", for: .normal)
            if (indexPath?.item)! % 2 == 0 {
                self.subContentView.backgroundColor = UIColor.rgbColor(from: 250, 250, 250)
            } else {
                self.subContentView.backgroundColor = UIColor.rgbColor(from: 241, 242, 247)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.indexButton.layer.cornerRadius = 10
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 149, 104, 252).cgColor,UIColor.rgbColor(from:143,201,255).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: indexButton.jxWidth, height: indexButton.jxHeight)
        gradientLayer.cornerRadius = 10
        self.indexButton.layer.addSublayer(gradientLayer)
        
    }

}