//
//  CommentCell.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var entity: CommentListEntity? {
        didSet {
            self.nickNameLabel.text = entity?.user?.nickname
            self.contentLabel.text = entity?.commentRepl
            self.userImageView.backgroundColor = UIColor.randomColor
            if let str = entity?.user?.avatar,let url = URL(string: str) {
                self.userImageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
            } else {
                self.userImageView.image = nil
            }
            if entity?.topStatus == 2 {
                self.statusLabel.text = "精"
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
