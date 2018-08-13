//
//  TransferSuccessController.swift
//  Star
//
//  Created by 杜进新 on 2018/8/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TransferSuccessController: BaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberLable: UILabel!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var address : String?
    var number : String?
    var name : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "转账成功"
        
        
        self.addressLabel.text = self.address
        self.numberLable.text = self.number
        self.coinNameLabel.text = self.name
        
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIView())
        
        addressLabel.layer.shadowColor =  UIColor.rgbColor(rgbValue: 0xe2e2e2).cgColor
        addressLabel.layer.shadowOpacity = 0.5
        addressLabel.layer.shadowRadius = 3
        addressLabel.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: self.confirmButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.confirmButton.layer.insertSublayer(gradientLayer, at: 0)
        self.confirmButton.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 84
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    @IBAction func complete(_ sender: Any) {
        if
            let controllers = self.navigationController?.viewControllers,
            controllers.count > 2, let vc = self.navigationController?.viewControllers[1] as? WalletViewController{
            print(controllers)
            vc.requestData()
            self.navigationController?.popToViewController(vc, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
}
