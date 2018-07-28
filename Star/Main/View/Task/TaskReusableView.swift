//
//  TaskReusableView.swift
//  Star
//
//  Created by 杜进新 on 2018/7/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TaskReusableView: UICollectionReusableView {

    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var klLable: UILabel!
    @IBOutlet weak var recordBackView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomBackgroundView1: UIView!
    
    var powerRecordBlock : (()->())?
    typealias DayTaskBlock = (()->())?
    var dayArticleBlock : DayTaskBlock
    var dayPaperBlock : DayTaskBlock
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.recordBackView.backgroundColor = JXFfffffColor
        self.recordBackView.alpha = 0.12
        self.recordBackView.layer.cornerRadius = 8
        self.recordBackView.layer.masksToBounds = true
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 272 + kNavStatusHeight - 60)
        self.topBackgroundView.layer.insertSublayer(gradientLayer, at: 0)

        
        self.topConstraint.constant = kNavStatusHeight + 20
        self.bottomBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dayArticleTask)))
        self.bottomBackgroundView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dayPaperTask)))
    }
    @IBAction func record(_ sender: Any) {
        if let block = self.powerRecordBlock {
            block()
        }
    }
    @objc func dayArticleTask() {
        if let block = dayArticleBlock {
            block()
        }
    }
    @objc func dayPaperTask() {
        if let block = dayPaperBlock {
            block()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
