//
//  TaskCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TaskCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageVIew: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var entity: TaskEntity? {
        didSet{
            self.titleLabel.text = entity?.name
            self.numberLabel.text = "智慧值+\(entity?.power ?? 0)"
            
            switch entity?.id {
            case 3:
                if entity?.finishStatus == 1  {
                    self.iconImageVIew.image = UIImage(named: "iconWechat_finished")
                    self.titleLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.text = "已关注+\(entity?.power ?? 0)"
                } else {
                    self.iconImageVIew.image = UIImage(named: "iconWechat")
                }
            case 4:
                if entity?.finishStatus == 1  {
                    self.iconImageVIew.image = UIImage(named: "iconFaceid_finished")
                    self.titleLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.text = "已认证+\(entity?.power ?? 0)"
                } else {
                    self.iconImageVIew.image = UIImage(named: "iconFaceid")
                }
            case 5:
                if entity?.finishStatus == 1  {
                    self.iconImageVIew.image = UIImage(named: "iconWechat_finished")
                    self.titleLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.text = "已创建+\(entity?.power ?? 0)"
                } else {
                    self.iconImageVIew.image = UIImage(named: "iconWechat")
                }
            case 6:
                if entity?.finishStatus == 1  {
                    self.iconImageVIew.image = UIImage(named: "iconWechat_finished")
                    self.titleLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.text = "已备份+\(entity?.power ?? 0)"
                } else {
                    self.iconImageVIew.image = UIImage(named: "iconWechat")
                }
            case 7:
                if entity?.finishStatus == 1  {
                    self.iconImageVIew.image = UIImage(named: "iconHeadPortrait_finished")
                    self.titleLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.textColor = UIColor.rgbColor(rgbValue: 0xc6c6c6)
                    self.numberLabel.text = "已设置+\(entity?.power ?? 0)"
                } else {
                    self.iconImageVIew.image = UIImage(named: "iconHeadPortrait")
                }
            default:
                print("未知任务")
            }
            
        }
    }
}
