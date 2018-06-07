//
//  ArticleCell.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleTimeLabel: UILabel!
    
    
    var entity: ArticleListEntity? {
        didSet {
            self.articleImageView.backgroundColor = UIColor.randomColor
            self.articleTitleLabel.text = entity?.title
            //self.articleTimeLabel.text = "2018-10-19"
            
            if let timeStr = entity?.releaseTime {
                self.articleTimeLabel.text = Date.calculateTimeStringFrom(timeStr)
            }
            
            if entity?.coverImg?.hasPrefix("http") == true {
                self.articleImageView.sd_setImage(with: URL(string: (entity?.coverImg!)!), placeholderImage: nil, options: [], completed: nil)
            }
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
