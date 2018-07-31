//
//  WalletViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/31.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletViewController: JXTableViewController {
    @IBOutlet weak var defaultBackView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱包"
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: self.createButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.createButton.layer.insertSublayer(gradientLayer, at: 0)
        self.createButton.backgroundColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if WalletManager.manager.isWalletExist == true {
            self.defaultBackView.isHidden = true
            //            self.defaultBackView.removeFromSuperview()
            self.tableView?.isHidden = false
            self.tableView?.reloadData()
        } else {
            self.defaultBackView.isHidden = false
            self.tableView?.isHidden = true
            //            self.tableView?.removeFromSuperview()
            //            if let _ = self.defaultBackView.superview {
            //
            //            } else {
            //                self.view.addSubview(self.defaultBackView)
            //            }
        }
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
    @IBAction func createWallet(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "createWallet", sender: nil)
    }
    @IBAction func importWallet(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "importWallet", sender: nil)
    }
}
