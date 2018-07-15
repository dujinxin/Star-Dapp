//
//  HomeReusableView.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import AVFoundation

class HomeReusableView: UICollectionReusableView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var diamondTotalLabel: UILabel!
    @IBOutlet weak var powerTotalLabel: UILabel!
    
    @IBOutlet weak var diamondContentView: UIView!
    
    @IBOutlet weak var itemContentView: UIView!
    @IBOutlet weak var myPropertyButton: UIButton!
    
    
    @IBOutlet weak var switchContentView: UIView!
    @IBOutlet weak var diamondTitleLabel: UILabel!
    @IBOutlet weak var diamondLabel: UILabel!
    @IBOutlet weak var diamondRankButton: UIButton!
    @IBOutlet weak var powerRankButton: UIButton!
    
    
    @IBOutlet weak var infoContentView: UIView!
    @IBOutlet weak var infoTitleLabel: UILabel!
    
    
    var helpBlock : (()->())?
    var fetchPowerBlock : (()->())?
    var myPropertyBlock : (()->())?
    var inviteBlock : (()->())?
    var diamondRankBlock : (()->())?
    var powerRankBlock : (()->())?
    
    var fetchDiamondBlock : ((_ id:String)->())?//收取水晶
    
    
    lazy var whiteImage: UIImage = {
        return self.imageWithColor(UIColor.white)
    }()
    lazy var grayImage: UIImage = {
        return self.imageWithColor(UIColor.rgbColor(from: 213, 221, 234))
    }()
    
    var buttonArray = Array<UIView>()
    var titleArray = Array<String>() //["0.00912","0.01232","0.01333","0.02245","0.02175","0.02587","0.02709","0.01933"]
    
    var entity: HomeEntity? {
        didSet{
            self.diamondTotalLabel.text = "\(entity?.ipe ?? 0)"
            self.powerTotalLabel.text = "\(entity?.power ?? 0)"
            
            self.diamondLabel.text = "\(entity?.ipe ?? 0)"
            
//            if oldValue?.mineralInfoArray.count == entity?.mineralInfoArray.count {
//                print("不做处理")
//            } else {
                print("重新布局",entity?.mineralInfoArray)
                self.setTitleArray()
//            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.topConstraint.constant = kStatusBarHeight
        
        self.infoContentView.backgroundColor = UIColor.rgbColor(from: 250, 250, 250)
        
        self.diamondRankButton.setBackgroundImage(self.whiteImage, for: .selected)
        self.diamondRankButton.setBackgroundImage(self.grayImage, for: .normal)
        self.diamondRankButton.clipsToBounds = true
        self.diamondRankButton.layer.cornerRadius = 7.5
        self.diamondRankButton.layer.borderColor = UIColor.rgbColor(from: 207, 210, 225).cgColor
        self.diamondRankButton.layer.borderWidth = 0.7
        self.diamondRankButton.isSelected = true
        self.diamondRankButton.setTitleColor(JXTextColor, for: .normal)
        
        
        self.powerRankButton.setBackgroundImage(self.whiteImage, for: .selected)
        self.powerRankButton.setBackgroundImage(self.grayImage, for: .normal)
        self.powerRankButton.clipsToBounds = true
        self.powerRankButton.layer.cornerRadius = 7.5
        self.powerRankButton.layer.borderColor = UIColor.rgbColor(from: 207, 210, 225).cgColor
        self.powerRankButton.layer.borderWidth = 0.7
        self.powerRankButton.setTitleColor(JXTextColor, for: .normal)
        
        
//        let subArray = ["0.00912","0.01232","0.01333","0.02245","0.02175","0.02587","0.02709","0.01933"]
//        self.random(subArray)
//        self.animate()

    }

    @IBAction func help(_ sender: Any) {
        if let block = self.helpBlock {
            block()
        }
    }
    @IBAction func fetchPower(_ sender: Any) {
        if let block = self.fetchPowerBlock {
            block()
        }
    }
    @IBAction func myProperty(_ sender: Any) {
        if let block = self.myPropertyBlock {
            block()
        }
    }
    @IBAction func invite(_ sender: Any) {
        if let block = self.inviteBlock {
            block()
        }
    }
    @IBAction func diamondRank(_ sender: Any) {
        if let block = self.diamondRankBlock {
            self.diamondRankButton.isSelected = true
            self.powerRankButton.isSelected = false
            self.diamondLabel.text = "\(entity?.ipe ?? 0)"
            self.diamondTitleLabel.text = "水晶值"
            self.infoTitleLabel.text = "收益"
            block()
        }
    }
    @IBAction func powerRank(_ sender: Any) {
        if let block = self.powerRankBlock {
            self.diamondRankButton.isSelected = false
            self.powerRankButton.isSelected = true
            self.diamondLabel.text = "\(entity?.power ?? 0)"
            self.diamondTitleLabel.text = "智慧值"
            self.infoTitleLabel.text = "智慧"
            block()
        }
    }
    func imageWithColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    //由于同一个视图在动画过程中不响应点击事件，这里的做法是给父视图添加点击事件，而给子视图添加动画
    func randomDiamonds(_ array:Array<String>) {
        self.buttonArray.removeAll()
        self.diamondContentView.removeAllSubView()
        
        let imageHeight : CGFloat = 52 * 167 / 156
        let labelHeight : CGFloat = 20
        let superWidth : CGFloat = 52
        let superHeight = imageHeight + 20
        
        //origin可随机区域 width = contentView.width - superView.width - animateWidth
        let width = self.diamondContentView.bounds.width - superWidth - 5 * 2
        //origin可随机区域 width = contentView.height - superView.height - animateHeight
        let height = self.diamondContentView.bounds.height - superHeight - 5 * 2
        
        for title in array {
            
            let superView = UIView()
            //superView.backgroundColor = UIColor.randomColor
            superView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
            
            let superView1 = UIView()
            superView1.backgroundColor = UIColor.clear
            superView.addSubview(superView1)
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: "imgDiamond")
            imageView.isUserInteractionEnabled = true
            superView1.addSubview(imageView)
            
            let label = UILabel()
            let components = title.components(separatedBy: "_")
            if components.count > 1 {
                label.text = components[1]
            }
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .center
            label.sizeToFit()
            superView1.addSubview(label)
            
  
            var isIntersects = true
            repeat{
                
                let x = arc4random_uniform(UInt32(width))
                //let y = UInt32(kNavStatusHeight) + 5 + arc4random_uniform(UInt32(height))
                let y = arc4random_uniform(UInt32(height))
                superView.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: superWidth, height: superHeight)
                superView1.frame = CGRect(x: 0, y: 0, width: superWidth, height: superHeight)
                imageView.frame = CGRect(x: 0, y: 0, width: superWidth, height: imageHeight)
                label.frame = CGRect(x: 0, y: imageHeight, width: superWidth, height: labelHeight)
                if self.buttonArray.count == 0 {
                    //print("第一个视图一定没有交集")
                    isIntersects = false
                } else {
                    isIntersects = false
                    for subView in self.buttonArray {
                        //与已存在的子视图没有交集，方可添加
                        if subView.frame.intersects(superView.frame) == true {
                            //print("有交集")
                            isIntersects = true
                            break
                        }
                    }
                }
                
            }while(isIntersects)
            //print("没有交集")
            self.buttonArray.append(superView)
            self.diamondContentView.addSubview(superView)
        }
    }
    func defaultDiamond() {
        self.diamondContentView.removeAllSubView()
        
        let imageHeight : CGFloat = 52 * 167 / 156
        let labelHeight : CGFloat = 20
        let superWidth : CGFloat = 52
        let superHeight = imageHeight + 20
        
        let superView = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgDiamond")
        imageView.isUserInteractionEnabled = true
        superView.addSubview(imageView)
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "挖矿中..."
        label.sizeToFit()
        superView.addSubview(label)
        
        superView.frame = CGRect(x: 0, y: 0, width: superWidth, height: superHeight)
        imageView.frame = CGRect(x: 0, y: 0, width: superWidth, height: imageHeight)
        label.frame = CGRect(x: 0, y: imageHeight, width: superWidth, height: labelHeight)
        
        self.diamondContentView.addSubview(superView)
        superView.center = CGPoint(x: self.diamondContentView.center.x, y: self.diamondContentView.bounds.height / 2)
    }
    func animate() {
        for v1 in self.buttonArray {
            guard let v = v1.subviews.first else{
                return
            }
            let animation = CAKeyframeAnimation.init(keyPath: "position")
            let path = CGMutablePath.init()
            
            path.move(to: CGPoint(x: v.center.x, y: v.center.y))//设置起始点
            path.addLine(to: CGPoint(x: v.center.x, y: v.center.y + 5))//终点
            path.addLine(to: CGPoint(x: v.center.x, y: v.center.y))//终点
            path.addLine(to: CGPoint(x: v.center.x, y: v.center.y - 5))//终点
            path.addLine(to: CGPoint(x: v.center.x, y: v.center.y))//终点
            
//            let transform = CGAffineTransform.init(translationX: -v.bounds.origin.x, y: -v.bounds.origin.y)
//            transform.scaledBy(x: 1, y: 0.2)
//            transform.translatedBy(x: v.bounds.origin.x, y: v.bounds.origin.y)
//
//            let center = CGPoint(x: v.jxOrigin.x + 44 / 2, y: v.jxOrigin.y + 64 / 2)
//            path.addArc(center: center, radius: 5, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true,transform:transform)
            
            animation.path = path
            
            animation.isRemovedOnCompletion = false
            animation.repeatCount =  Float.greatestFiniteMagnitude
            //animation.repeatDuration = 3
            let index = self.buttonArray.index(of: v1)
            
            animation.beginTime = 0.5 * Double(index!)
            animation.duration = 5
            animation.autoreverses = false
            animation.fillMode = kCAFillModeForwards
            animation.calculationMode = kCAAnimationPaced
            
            v.layer.add(animation, forKey: nil)
            
            //            UIView.animate(withDuration: 3, delay: 3.1, options: [.repeat,.curveEaseInOut], animations: {
            //                var frame = button.frame
            //                frame.origin.y += 10
            //                button.frame = frame
            //            }) { (finish) in
            //                if finish == true {
            //                    UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
            //                        var frame = button.frame
            //                        frame.origin.y -= 10
            //                        button.frame = frame
            //                    }) { (finish1) in
            //                        if finish1 == true {
            //                            print("done1")
            //                        } else {
            //                            print("animating1")
            //                        }
            //                    }
            //                    print("done")
            //                } else {
            //                    print("animating")
            //                }
            //            }
        }
    }
    @objc func tap(tap:UITapGestureRecognizer) {
        guard let subView = tap.view else {
            return
        }
        let index = self.buttonArray.index(of: subView)
        self.buttonArray.remove(at: index!)
        
        print(subView.frame)
        //动画
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            var frame = subView.frame
            let x : CGFloat = 25 + 30 + 54
            let y = self.diamondContentView.jxHeight + 20
            //我的资产图标中心点
            let point = CGPoint(x: x, y: y)
            
            frame.origin = point
            subView.frame = frame
//            print("myPropertyButton center = ",point)
//            print("animation frame = ",subView.frame)
        }) { (finish) in
            if finish {
                subView.removeFromSuperview()
            }
        }
        //声音
        if let file = Bundle.main.path(forResource: "diamond", ofType: "mp3")
        //Bundle.main.url(forResource: "ding.mp3", withExtension: nil)
        {
            
            let fileUrl = URL(fileURLWithPath: file)
            //print("fileUrl = ",fileUrl)
            var systemSoundID : SystemSoundID = 0
            AudioServicesCreateSystemSoundID(fileUrl as CFURL, &systemSoundID)
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
//            if session.category != AVAudioSessionCategoryPlayback {
//                try? session.setCategory(AVAudioSessionCategoryPlayback)
//                try? session.setActive(true)
//                try? session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
//            }
            if #available(iOS 9.0, *) {
                AudioServicesPlaySystemSoundWithCompletion(systemSoundID) {
                    print("播放完成")
                }
            } else {
                AudioServicesPlaySystemSound(systemSoundID)
            }
        }
        if let block = self.fetchDiamondBlock {
            let id = self.titleArray[index!]
            self.titleArray.remove(at: index!)
            if self.titleArray.count == 0 {
                self.setTitleArray()
            }
            let components = id.components(separatedBy: "_")
            if
                components.count > 1 ,
                let a = Double(components[1]){
                
                self.entity?.ipe += a
                self.diamondTotalLabel.text = "\(self.entity?.ipe ?? 0)"
                self.diamondTitleLabel.text = "水晶值"
                if self.diamondTitleLabel.text == "水晶值" {
                    self.diamondLabel.text = "\(self.entity?.ipe ?? 0)"
                }
            }
            block(id)
        }
    }
    func setTitleArray() {
        self.titleArray.removeAll()
        if let array = entity?.mineralInfoArray.prefix(8),array.count > 0 {
            for s in array {
                titleArray.append(s)
            }
            entity?.mineralInfoArray.removeSubrange(0..<array.count)
            self.randomDiamonds(titleArray)
            self.animate()
        } else {
            self.defaultDiamond()
        }
    }
}
