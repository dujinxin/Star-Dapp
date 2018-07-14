//
//  InviteViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/12.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
//import JXFoundation

class InviteViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentSize_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var inviteNumLabel: UILabel!
    @IBOutlet weak var powerNumLabel: UILabel!
    @IBOutlet weak var inviteCodeLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var setCardButton: UIButton!
    
    
    let homeVM = HomeVM()
    
    //MARK: - custom NavigationBar
    //自定义导航栏
    lazy var customNavigationBar : PropertyNavigationBar = {
        let navigationBar = PropertyNavigationBar(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNavStatusHeight))
        navigationBar.barTintColor = UIColor.groupTableViewBackground
        navigationBar.tintColor = UIColor.black
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]
        return navigationBar
    }()
    lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem()
        return item
    }()
    
    //重写title的setter方法
    override var title: String?{
        didSet {
            customNavigationItem.title = title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .default
        self.view.backgroundColor = UIColor.groupTableViewBackground
        if #available(iOS 11.0, *) {
            self.scrollView?.contentInsetAdjustmentBehavior = .never
            self.scrollView?.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.topConstraint.constant = kNavStatusHeight
        
        setCustomNavigationBar()
        
        self.title = "邀请好友"
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "imgBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
        leftButton.tintColor = UIColor.black
        leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
        self.copyButton.backgroundColor = UIColor.clear
        self.setCardButton.backgroundColor = UIColor.clear
        
        self.copyButton.layer.addSublayer(self.setGradientColor(size: self.copyButton.jxSize))
        self.setCardButton.layer.addSublayer(self.setGradientColor(size: CGSize(width: kScreenWidth - 90, height: 44)))
        
        
        self.homeVM.inviteInfo { (_, msg, isSuc) in
            if isSuc == false {
                ViewManager.showNotice(msg)
            } else {
                self.inviteNumLabel.text = self.homeVM.inviteEntity.inviteCount
                self.powerNumLabel.text = "\(self.homeVM.inviteEntity.invitePower)"
                self.inviteCodeLabel.text = self.homeVM.inviteEntity.inviteCode
            }
        }
    }
    func setGradientColor(size:CGSize) -> CAGradientLayer{
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.cornerRadius = size.height / 2
        return gradientLayer
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
        self.contentSize_heightConstraint.constant = kScreenHeight - kNavStatusHeight
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setCustomNavigationBar() {
        //隐藏navigationBar
        self.navigationController?.navigationBar.isHidden = true
        //1.自定义view代替NavigationBar,需要自己实现手势返回;
        //2.自定义navigatioBar代替系统的，手势返回不用自己实现
        view.addSubview(self.customNavigationBar)
        customNavigationBar.items = [customNavigationItem]
    }
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func copyCode(_ sender: Any) {
        let string = self.inviteCodeLabel.text
        
        let pals = UIPasteboard.general
        pals.string = string
        
        ViewManager.showNotice("复制成功")
    }
    @IBAction func exportCard(_ sender: Any) {
        
        let image = UIImage(named: "base")
        var width : CGFloat = 0
        guard let imageWidth = image?.size.width else {
            return
        }
        print(imageWidth)
        if imageWidth > kScreenWidth {
            width = kScreenWidth
        } else {
            width = imageWidth
        }
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 498)
        //contentView.backgroundColor = UIColor.yellow
        //contentView.alpha = 0.25
        
        
        
        let backImageView = UIImageView()
        backImageView.frame = CGRect(origin: CGPoint(x: (kScreenWidth - width) / 2, y: 0), size: CGSize(width: width, height: 498))
        //let image = self.image(originalImage: UIImage(named: "base"), to: kScreenWidth - 40, to: 498)
        
        backImageView.image = image
        //backImageView.contentMode = .scaleAspectFill
        contentView.addSubview(backImageView)
        
        let logoImageView = UIImageView()
        logoImageView.frame = CGRect(origin: CGPoint(x: 0, y: 25), size: CGSize(width: 110, height: 133))
        logoImageView.image = #imageLiteral(resourceName: "imgLogo")
        contentView.addSubview(logoImageView)
        var point = logoImageView.center
        point.x = contentView.center.x
        logoImageView.center = point
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: logoImageView.jxBottom + 20, width: contentView.jxWidth, height: 20)
        titleLabel.text = "智慧星球"
        titleLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4368)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        
        let detailLabel = UILabel()
        detailLabel.frame = CGRect(x: 0, y: titleLabel.jxBottom + 5, width: contentView.jxWidth, height: 20)
        detailLabel.text = "以区块链技术，实现全球IP共享全球"
        detailLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4368)
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(detailLabel)
        
        let line = UIView()
        line.frame = CGRect(x: (kScreenWidth - width) / 2 + 15, y: detailLabel.jxBottom + 23, width: width - 30, height: 1)
        line.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line)
        
        
        let infoLabel = UILabel()
        infoLabel.frame = CGRect(x: 50, y: line.jxBottom + 14, width: contentView.jxWidth - 100, height: 40)
        infoLabel.text = "我是\(self.homeVM.inviteEntity.nickname ?? "昵称")，我已在这里获得区块链 知识产权收益，我在智慧星球等你"
        infoLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4368)
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 15)
        infoLabel.numberOfLines = 2
        contentView.addSubview(infoLabel)
        
        
        let line1 = UIView()
        line1.frame = CGRect(x:  (kScreenWidth - width + 10) / 2 + 15, y: 321 - 7, width: width - 10 - 30, height: 1)
        line1.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line1)
        
        
        let codeImageView = UIImageView()
        codeImageView.frame = CGRect(origin: CGPoint(x: 54, y: line1.jxBottom + 42), size: CGSize(width: 101, height: 101))
        //codeImageView.image = #imageLiteral(resourceName: "imgLogo")
        contentView.addSubview(codeImageView)
        
        codeImageView.image = self.code(self.homeVM.inviteEntity.inviteCode!)
        
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: codeImageView.jxRight + 32, y: line1.jxBottom + 54, width: 120, height: 17)
        myLabel.text = "我的二维码"
        myLabel.textColor = UIColor.rgbColor(rgbValue: 0x979ebf)
        myLabel.font = UIFont.systemFont(ofSize: 12)
        myLabel.textAlignment = .left
        
        contentView.addSubview(myLabel)
        
        let codeLabel = UILabel()
        codeLabel.frame = CGRect(x: myLabel.jxLeft, y: myLabel.jxBottom , width: 120, height: 33)
        codeLabel.text = self.homeVM.inviteEntity.inviteCode
        codeLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4368)
        codeLabel.font = UIFont.systemFont(ofSize: 23)
        codeLabel.textAlignment = .left
        
        contentView.addSubview(codeLabel)
        
        
        let button = UIButton()
        button.frame = CGRect(x: myLabel.jxLeft, y: codeLabel.jxBottom + 7, width: 100, height: 18)
        button.setTitle("注意截屏保存", for: .normal)
        button.setTitleColor(UIColor.rgbColor(rgbValue: 0x1296db), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(#imageLiteral(resourceName: "Shape"), for: .normal)
        button.contentHorizontalAlignment = .left
        contentView.addSubview(button)
        
        let alert = JXSelectView.init(frame: CGRect(), customView: contentView)
        alert.position = .middle
        alert.show()
    }
    func image(originalImage:UIImage? ,to scaledWidth:CGFloat,to scaledHeight:CGFloat) -> UIImage? {
        guard let image = originalImage else {
            return UIImage.init()
        }

        let width = scaledWidth
        let height = scaledHeight
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
      
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func code(_ string:String) -> UIImage {
        //二维码滤镜
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        //设置滤镜默认属性
        filter?.setDefaults()
        
        let data = string.data(using: .utf8)
        
        //设置内容
        filter?.setValue(data, forKey: "inputMessage")
        //设置纠错级别
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        //获取滤镜输出图像
        guard let outImage = filter?.outputImage else{
            return UIImage()
        }
        //转换CIIamge为UIImage,并放大显示
        guard let image = self.createNonInterpolatedUIImage(outImage, size: CGSize(width: 101, height: 101)) else {
            return UIImage()
        }
        return image
    }
    func createNonInterpolatedUIImage(_ ciImage : CIImage,size:CGSize) -> UIImage? {
        let a = size.height
        
        let extent = ciImage.extent.integral
        let scale = min(a / extent.size.width, a / extent.size.height)
        //创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cs = CGColorSpaceCreateDeviceGray()
        guard let bitmapRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }
        let context = CIContext.init()
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else {
            return nil
        }
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        //保存bitmap到图片
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        let image = UIImage.init(cgImage: scaledImage)
        return image
    }
}

