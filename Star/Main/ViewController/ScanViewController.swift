//
//  ScanViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scanImageView: UIImageView!
    
    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint!
    
    var session = AVCaptureSession()
    
    var callBlock : ((_ address: String?)->())?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton.tintColor = UIColor.white
        self.scanImageView.tintColor = UIColor.blue
        self.topView.alpha = 0.5
        self.leftView.alpha = 0.5
        self.rightView.alpha = 0.5
        self.bottomView.alpha = 0.5
        
        self.controlButton.setImage(#imageLiteral(resourceName: "off"), for: .normal)
        self.controlButton.setImage(#imageLiteral(resourceName: "on"), for: .selected)
        
        
        guard
            let device = AVCaptureDevice.default(for: .video),   //创建摄像设备
            let input = try? AVCaptureDeviceInput(device: device)//创建输入流
            else{
            return
        }
        
        let output = AVCaptureMetadataOutput()                   //创建输出流
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        
        let x = self.leftViewWidthConstraint.constant
        let width = view.bounds.width - 2 * self.leftViewWidthConstraint.constant
        let height = width
        let y = (view.bounds.height - height) / 2

        output.rectOfInterest = self.getScanCrop(rect: CGRect(x: x, y: y, width: width, height: height), readerViewBounds: view.bounds)
        
        session.sessionPreset = .high                           //高质量采集率
        session.addInput(input)
        session.addOutput(output)
        
        //先添加输出流 才可以设置格式，不然报错
        output.metadataObjectTypes = [.qr,.ean13,.ean8,.code128]//设置扫码支持的编码格式(设置条形码和二维码兼容)
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.layer.bounds
        view.layer.insertSublayer(layer, at: 0)

        session.startRunning()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kStatusBarHeight + 7
    }
    func getScanCrop(rect: CGRect,readerViewBounds bounds:CGRect) -> CGRect {
        
        let x,y,width,height : CGFloat
        x = rect.origin.y / bounds.height
        y = rect.origin.x / bounds.width
        width = rect.size.height / bounds.height
        height = rect.size.width / bounds.width
        return CGRect(x: x, y: y, width: width, height: height)
    }
    @IBAction func backEvent(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func switchButton(_ sender: UIButton) {
        guard
            let device = AVCaptureDevice.default(for: .video),
            device.hasTorch == true else {
                ViewManager.showNotice("闪光灯故障")
            return
        }
        sender.isSelected = !sender.isSelected
        if  device.torchMode == .on{
            try? device.lockForConfiguration()
            device.torchMode = .off
            try? device.unlockForConfiguration()
        } else {
            try? device.lockForConfiguration()
            device.torchMode = .on
            try? device.unlockForConfiguration()
        }
    }
}
extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            guard
                let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
                let codeStr = metadataObject.stringValue
            else {
                return
            }
            session.stopRunning()
            ViewManager.showNotice(codeStr)
            if self.validate(code: codeStr) == false {
                
            } else {
                if let block = callBlock {
                    block(codeStr)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    func validate(code: String) -> Bool {
        if code.count != 42 {
            return false
        }
        if code.hasPrefix("0x") == false{
            return false
        }
        return true
    }
}
