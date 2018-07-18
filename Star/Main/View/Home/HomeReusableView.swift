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
    var homeReusableVM : HomeReusableVM? {
        didSet{
            //self.setDiamondsViewFrames()
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
        
        //self.setRandomDiamonds(count: 8)

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
    
    func setRandomDiamonds(count:Int) {
//        self.buttonArray.removeAll()
//        self.diamondContentView.removeAllSubView()
        
        for _ in 0..<count {
            let diamondView = DiamondView()
            diamondView.isHidden = true
            self.buttonArray.append(diamondView)
            self.diamondContentView.addSubview(diamondView)
        }
    }
//    func setDiamondsViewFrames(array:Array<CGRect>) {
//        for i in self.diamondContentView.subviews {
//            <#code#>
//        }
//    }
    //389d920717dcfe2e2db29f71eebc12934766bf2c
    //由于同一个视图在动画过程中不响应点击事件，这里的做法是给父视图添加点击事件，而给子视图添加动画
    /// 水晶随机分布在一个固定矩形区域,水晶带有上下移动的动画
    ///
    /// - Parameter array: 水晶数组
    func randomDiamonds(_ array:Array<String>) {
        self.buttonArray.removeAll()
        self.diamondContentView.removeAllSubView()
        
        let imageHeight : CGFloat = 52 * 167 / 156
        let labelHeight : CGFloat = 20
        //水晶+数字 宽高
        let crystalViewWidth : CGFloat = 52
        let crystalViewHeight = imageHeight + 20
        
        //动画区域
        let animateWidth :CGFloat = 0
        let animateHeight :CGFloat = 5 + 5 //上下各5
        
        //margin
        let marginLeft : CGFloat  = 30
        let marginRight : CGFloat = 30
        let marginTop : CGFloat = 0
        let marginBottom : CGFloat = 0

        //origin可随机区域 width = contentView.width - crystalView.width - animateWidth - marginLeft - marginRight
        let origin_x = self.diamondContentView.bounds.width - crystalViewWidth - animateWidth - marginLeft - marginRight
        //origin可随机区域 width = contentView.height - crystalView.height - animateHeight - marginTop - marginBottom
        let origin_y = self.diamondContentView.bounds.height - crystalViewHeight - animateHeight - marginTop - marginBottom
        
        for title in array {
            
            let crystalView = UIView()
            //superView.backgroundColor = UIColor.randomColor
            crystalView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
            
            let superView = UIView()
            superView.backgroundColor = UIColor.clear
            crystalView.addSubview(superView)
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: "imgDiamond")
            imageView.isUserInteractionEnabled = true
            superView.addSubview(imageView)
            
            let label = UILabel()
            let components = title.components(separatedBy: "_")
            if components.count > 1 {
                label.text = components[1]
            }
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .center
            label.sizeToFit()
            superView.addSubview(label)
            
  
            var isIntersects = true
            repeat{
                
                let x = arc4random_uniform(UInt32(origin_x))
                let y = arc4random_uniform(UInt32(origin_y))
                crystalView.frame = CGRect(x: CGFloat(x) + marginLeft , y: CGFloat(y) + marginTop, width: crystalViewWidth, height: crystalViewHeight)
                superView.frame = CGRect(x: 0, y: 0, width: crystalViewWidth, height: crystalViewHeight)
                imageView.frame = CGRect(x: 0, y: 0, width: crystalViewWidth, height: imageHeight)
                label.frame = CGRect(x: 0, y: imageHeight, width: crystalViewWidth, height: labelHeight)
                if self.buttonArray.count == 0 {
                    //print("第一个视图一定没有交集")
                    isIntersects = false
                } else {
                    isIntersects = false
                    for subView in self.buttonArray {
                        //与已存在的子视图没有交集，方可添加
                        if subView.frame.intersects(crystalView.frame) == true {
                            //print("有交集")
                            isIntersects = true
                            break
                        }
                    }
                }
                
            }while(isIntersects)
            //print("没有交集")
            self.buttonArray.append(crystalView)
            self.diamondContentView.addSubview(crystalView)
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
            //删除临时水晶数据
            let id = self.titleArray[index!]
            self.titleArray.remove(at: index!)
            //删除原始水晶数据
            let diamondIndex = self.entity?.mineralInfoArray.index(of: id)
            self.entity?.mineralInfoArray.remove(at: diamondIndex!)
            //重新布局
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
            self.randomDiamonds(titleArray)
            self.animate()
        } else {
            self.defaultDiamond()
        }
    }
}
class DiamondView: UIView {
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imgDiamond")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    var tapBlock : ((_ view:DiamondView)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.contentView)
        addSubview(self.imageView)
        addSubview(self.titleView)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tap(tap:UITapGestureRecognizer) {
        if let block = tapBlock {
            block(self)
        }
    }
}
