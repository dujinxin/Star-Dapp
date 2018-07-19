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
    
    var homeReusableVM : HomeReusableVM? {
        didSet{
            self.diamondTotalLabel.text = "\(homeReusableVM?.ipe ?? 0)"
            self.powerTotalLabel.text = "\(homeReusableVM?.power ?? 0)"
            
            self.diamondLabel.text = "\(homeReusableVM?.ipe ?? 0)"
            
            self.setDiamondsViewFrames(array: homeReusableVM?.frameArray ?? [], diamonds: homeReusableVM?.diamondArray ?? [])
        }
    }
    //屏幕当前剩余水晶
    var remainDiamonds : Int = 0
    
    
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
        
        self.setRandomDiamonds(count: 8)

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
            self.diamondLabel.text = "\(homeReusableVM?.ipe ?? 0)"
            self.diamondTitleLabel.text = "水晶值"
            self.infoTitleLabel.text = "收益"
            block()
        }
    }
    @IBAction func powerRank(_ sender: Any) {
        if let block = self.powerRankBlock {
            self.diamondRankButton.isSelected = false
            self.powerRankButton.isSelected = true
            self.diamondLabel.text = "\(homeReusableVM?.power ?? 0)"
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

        let imageHeight : CGFloat = 52 * 167 / 156
        //let labelHeight : CGFloat = 20
        //水晶+数字 宽高
        let crystalViewWidth : CGFloat = 52
        let crystalViewHeight = imageHeight + 20
        
        for i in 0..<count {
            
            let diamondView = DiamondView(frame: CGRect(x: 0, y: 0, width: crystalViewWidth, height: crystalViewHeight))
            diamondView.tag = i
            diamondView.isHidden = true
            self.buttonArray.append(diamondView)
            self.diamondContentView.addSubview(diamondView)
            
            diamondView.tapBlock = { v in
                self.tapClick(subView: v)
            }
            
            //diamondView.beginAnimate(time: Double(i) * 0.5)
        }
    }
    func setDiamondsViewFrames(array:Array<CGRect>, diamonds:Array<DiamondEntity>) {
        
        self.remainDiamonds = array.count
        
        if array.count == 0 {
            let v = self.diamondContentView.subviews[0] as? DiamondView
            v?.isHidden = false
            v?.titleView.text = "挖矿中..."
            v?.center = CGPoint(x: self.diamondContentView.center.x, y: self.diamondContentView.bounds.height / 2)
            
            return
        }
        
        for i in 0..<array.count {
            let v = self.diamondContentView.subviews[i] as? DiamondView
            v?.frame = array[i]
            v?.isHidden = false
            v?.beginAnimate(time: Double(i) * 0.5)
            if diamonds.count > i {
                v?.entity = diamonds[i]
            } else {
                print("error: 数组越界")
            }
        }
    }

    func tapClick(subView:UIView) {
        
        let index = subView.tag
        let durationTime = 0.5
        guard
            let diamondView = subView as? DiamondView,
            let diamondEntity = diamondView.entity else{
            return
        }
        
        //动画
        UIView.animate(withDuration: durationTime, delay: 0, options: [.curveEaseOut], animations: {
            var frame = subView.frame
            let x : CGFloat = 25 + 30 + 54
            let y = self.diamondContentView.jxHeight + 20
            //我的资产图标中心点
            let point = CGPoint(x: x, y: y)
            
            frame.origin = point
            subView.frame = frame
    
        }) { (finish) in
            if finish {
                subView.isHidden = true
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
            
            if let str = diamondEntity.diamondNumber, let a = Double(str) {
                
                self.homeReusableVM?.ipe += a
                self.diamondTotalLabel.text = "\(self.homeReusableVM?.ipe ?? 0)"
                self.diamondTitleLabel.text = "水晶值"
                if self.diamondTitleLabel.text == "水晶值" {
                    self.diamondLabel.text = "\(self.homeReusableVM?.ipe ?? 0)"
                }
            }
            //做减员处理
            self.remainDiamonds -= 1
            //删除原始水晶数据
            let originIndex = self.homeReusableVM?.diamondArray.index(of: diamondEntity)
            self.homeReusableVM?.diamondArray.remove(at: originIndex!)
            
            if self.remainDiamonds == 0 {
                if
                    let diamondArray = self.homeReusableVM?.diamondArray,
                    let subDiamondArray = self.homeReusableVM?.diamondArray.prefix(8) {
                    //要重置初始数组
                    self.homeReusableVM?.randomRect(number:subDiamondArray.count)
                    //等移动动画结束再重新布局，不然重新布局的视图会被上边的结束动画隐藏掉
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + durationTime) {
                        self.setDiamondsViewFrames(array: self.homeReusableVM?.frameArray ?? [], diamonds: diamondArray)
                    }
                }
            }
            //block(id)
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
    
    var entity: DiamondEntity? {
        didSet{
            self.titleView.text = entity?.diamondNumber
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.contentView)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleView)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageHeight : CGFloat = 52 * 167 / 156
        let labelHeight : CGFloat = 20
        //水晶+数字 宽高
        //let crystalViewWidth : CGFloat = 52
        //let crystalViewHeight = imageHeight + 20

        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: imageHeight)
        titleView.frame = CGRect(x: 0, y: imageHeight, width: frame.width, height: labelHeight)
    }
    @objc func tap(tap:UITapGestureRecognizer) {
        if let block = tapBlock {
            block(self)
        }
    }
    
    func beginAnimate(time:CFTimeInterval = 0) {
        
        let v = self.contentView
        

        let animation = CAKeyframeAnimation.init(keyPath: "position")
        let path = CGMutablePath.init()
        
        path.move(to: CGPoint(x: v.center.x, y: v.center.y))//设置起始点
        path.addLine(to: CGPoint(x: v.center.x, y: v.center.y + 5))//终点
        path.addLine(to: CGPoint(x: v.center.x, y: v.center.y))//终点
        path.addLine(to: CGPoint(x: v.center.x, y: v.center.y - 5))//终点
        path.addLine(to: CGPoint(x: v.center.x, y: v.center.y))//终点
        
        animation.path = path
        
        animation.isRemovedOnCompletion = false
        animation.repeatCount =  Float.greatestFiniteMagnitude
        //animation.repeatDuration = 3
        animation.beginTime = time
        animation.duration = 5
        animation.autoreverses = false
        animation.fillMode = kCAFillModeForwards
        animation.calculationMode = kCAAnimationPaced
        
        v.layer.add(animation, forKey: nil)
    }
}
