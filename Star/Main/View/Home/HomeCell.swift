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
            if indexPath?.item == 0 {
                self.indexButton.setBackgroundImage(UIImage(named: "indexImg1"), for: .normal)
                self.indexButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xffffff), for: .normal)
            } else if indexPath?.item == 1 {
                self.indexButton.setBackgroundImage(UIImage(named: "indexImg2"), for: .normal)
                self.indexButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xffffff), for: .normal)
            } else if indexPath?.item == 2 {
                self.indexButton.setBackgroundImage(UIImage(named: "indexImg3"), for: .normal)
                self.indexButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xffffff), for: .normal)
            } else {
                self.indexButton.setBackgroundImage(UIImage(), for: .normal)
                self.indexButton.setTitleColor(UIColor.rgbColor(rgbValue: 0x3b4368), for: .normal)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.indexButton.layer.cornerRadius = 10
        
    }

}
