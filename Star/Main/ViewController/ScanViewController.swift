//
//  ScanViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var controlButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scanImageView: UIImageView!
    
    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint!
    
    var session = AVCaptureSession()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton.tintColor = UIColor.white
        self.scanImageView.tintColor = UIColor.blue
        self.topView.alpha = 0.5
        self.leftView.alpha = 0.5
        self.rightView.alpha = 0.5
        self.bottomView.alpha = 0.5
        
        
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

    func getScanCrop(rect: CGRect,readerViewBounds bounds:CGRect) -> CGRect {
        
        let x,y,width,height : CGFloat
        x = rect.origin.y / bounds.height
        y = rect.origin.x / bounds.width
        width = rect.size.height / bounds.height
        height = rect.size.width / bounds.width
        return CGRect(x: x, y: y, width: width, height: height)
    }
    @IBAction func backEvent(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func switchButton(_ sender: UIButton) {
        guard
            let device = AVCaptureDevice.default(for: .video),
            device.hasTorch == true else {
                ViewManager.showNotice("闪光灯故障")
            return
        }
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
           
//            guard let location = GDLocationManager.manager.location,let reGeocode = GDLocationManager.manager.reGeocode else {
//                ViewManager.showNotice(notice: "定位失败，请检查重试")
//                return
//            }
           
            
//            self.vm.scanResult(codeId: codeStr, scanMobile: UserManager.manager.userEntity.mobile,longitude: String(format: "%f", location.coordinate.longitude), latitude: String(format: "%f", location.coordinate.latitude), model: "", country: reGeocode.country, province: reGeocode.province, city: reGeocode.city, district: reGeocode.district, address: reGeocode.poiName, street: reGeocode.street, number: reGeocode.number) { (data, msg, isSuccess) in
//                //
//                print("data = ", data)
//                guard
//                    let result = data as? Dictionary<String,Any>
//
//                    else{
//                        return
//                }
//                print("result = ", result)
//                guard
////                    let result = data as? Dictionary<String,Any>,
//                    let goodsStatus = result["goodsStatus"] as? Dictionary<String,Any>
//
//                    else{
//                    return
//                }
//                print("goodsStatus = ", goodsStatus)
//                if
//                    let status = goodsStatus["status"] as? Int,
//                    let describe = goodsStatus["describe"] as? String,
//                    status != 1 {
//
//                    let alert = UIAlertView(title: nil, message: describe, delegate: self, cancelButtonTitle: "确定")
//                    alert.show()
//
//                    return
//                }
            
            
//                let model = scanFinishModel()
//                model.setmodel(scandict: result as NSDictionary)
//
//                if model.quality == "-1" {
//                    //
//                    return
//                }
                
//                let vc = ScanDetailViewController()
//
//                //vc.view.backgroundColor = JXFfffffColor;
//                vc.hidesBottomBarWhenPushed = true
//                vc.scanFinishModel = model
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
}
