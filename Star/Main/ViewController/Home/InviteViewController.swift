//
//  InviteViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/12.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

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
    
    
    var inviteEntity : InviteEntity?
    
    
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
        
        
        self.inviteNumLabel.text = self.inviteEntity?.inviteCount
        self.powerNumLabel.text = "\(self.inviteEntity?.invitePower ?? 0)"
        self.inviteCodeLabel.text = self.inviteEntity?.inviteCode
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteCard" {
            if let nvc = segue.destination as? UINavigationController,let vc = nvc.topViewController as? InviteCardController,let entity = sender as? InviteEntity {
                vc.entity = entity
            }
        }
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
    @IBAction func copyCode(_ sender: Any) {
        
        guard let codeStr = self.inviteEntity?.inviteCode, codeStr.isEmpty == false else{
            return
        }
        let pals = UIPasteboard.general
        pals.string = codeStr

        ViewManager.showNotice("复制成功")
    }
    @IBAction func exportCard(_ sender: Any) {
        
        guard let codeStr = self.inviteEntity?.inviteCode, codeStr.isEmpty == false else{
            return
        }
        
        self.performSegue(withIdentifier: "inviteCard", sender: self.inviteEntity)
    }
    
    @IBAction func unwindToInviteInfo(_ sender: UIStoryboardSegue) {
        let sourceViewController = sender.source
        // Use data from the view controller which initiated the unwind segue
        if sender.identifier == "inviteCardBack" {
            print(sourceViewController)
        }
    }
}

