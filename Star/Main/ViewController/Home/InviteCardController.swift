//
//  InviteCardController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class InviteCardController: BaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var entity : InviteEntity = InviteEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.codeImageView.image = self.code(self.entity.inviteCode!)
        
        self.codeLabel.text = self.entity.inviteCode
        
        let attributeStr = NSMutableAttributedString.init(string: "我是\(self.entity.nickname ?? "昵称")，我已在这里获得区块链知识产权收益，我在智慧星球等你")
        let rankStr = "\(self.entity.nickname ?? "昵称")"
        
        
        attributeStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0x3b4368)], range: NSRange.init(location: 0, length: 2))
        attributeStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0x1E62CD)], range: NSRange.init(location: 2, length: rankStr.count))
        attributeStr.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0x3b4368)], range: NSRange.init(location: "我是\(self.entity.nickname ?? "昵称")".count, length: 26))
        
        
        self.detailLabel.attributedText = attributeStr
        self.detailLabel.sizeToFit()
        
        self.noticeButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.bottomConstraint.constant = kTabBarHeight - 49 + 20
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
