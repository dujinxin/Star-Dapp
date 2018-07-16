//
//  AttentionViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/12.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class AttentionViewController: BaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    var taskVM = TaskVM()
    var alert : JXSelectView?
    
    lazy var layer: CAGradientLayer = {
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: confirmButton.jxWidth, height: confirmButton.jxHeight)
        gradientLayer.cornerRadius = 18
        return gradientLayer
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "关注公众号"
        
        self.textField.text = ""
        
        self.confirmButton.backgroundColor = UIColor.lightGray
        self.confirmButton.layer.cornerRadius = 18
        
        self.infoButton.isEnabled = false
        
        let attributedString = NSMutableAttributedString.init(string: "验证码")
        attributedString.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)], range: NSRange.init(location: 0, length: 3))
        
        self.textField.attributedPlaceholder = attributedString
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    @IBAction func attention(_ sender: Any) {
        guard let text = self.textField.text else { return }
        self.textField.resignFirstResponder()

        self.taskVM.weChat(text) { (_, msg, isSuc) in
            if isSuc {
                self.showResult()
            } else {
                ViewManager.showNotice(msg)
            }
        }
        
    }
    func showResult() {
        let width : CGFloat = kScreenWidth - 70
        
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 280)
        contentView.backgroundColor = UIColor.clear
        
        let backView = UIView()
        backView.frame = CGRect(x: 35, y: 0, width: width, height: 280)
        backView.backgroundColor = UIColor.white
        contentView.addSubview(backView)

        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 35, y: 20, width: width, height: 20)
        titleLabel.text = "领取成功"
        titleLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        
        
        let line = UIView()
        line.frame = CGRect(x: 35, y: titleLabel.jxBottom + 20, width: width, height: 1)
        line.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line)
        
        let detailLabel = UILabel()
        detailLabel.frame = CGRect(x: 35, y: line.jxBottom + 25, width: width, height: 20)
        detailLabel.text = "智慧值"
        detailLabel.textColor = UIColor.rgbColor(rgbValue: 0x979ebf)
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(detailLabel)
        
        
        let infoLabel = UILabel()
        infoLabel.frame = CGRect(x: 35, y: detailLabel.jxBottom + 5, width: width, height: 84)
        infoLabel.text = "+\(self.taskVM.finishTaskPower)"
        infoLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont.systemFont(ofSize: 60)
        infoLabel.numberOfLines = 2
        contentView.addSubview(infoLabel)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: infoLabel.jxBottom + 10, width: 114, height: 36)
        button.setTitle("查看", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        contentView.addSubview(button)
        button.center = CGPoint(x: infoLabel.center.x, y: button.center.y)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 114, height: 36)
        gradientLayer.cornerRadius = 18
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        self.alert = JXSelectView.init(frame: CGRect(), customView: contentView)
        self.alert?.position = .middle
        self.alert?.show()
    }
    @objc func backTo() {
        self.alert?.dismiss(animate: false)
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension AttentionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.textField {
            if range.location > 5 {
                //let s = textField.text! as NSString
                //let str = s.substring(to: 10)
                //textField.text = str
                //ViewManager.showNotice("字符个数为6位")
                return false
            }
        }
        return true
    }
    @objc func textChange(notify:NSNotification) {
        guard let tf = notify.object as? UITextField else {
            return
        }
        if tf.text?.isEmpty == true {
            if let _ = self.layer.superlayer {
                self.layer.removeFromSuperlayer()
            }
            self.confirmButton.backgroundColor = UIColor.lightGray
            self.confirmButton.isEnabled = false
        } else {
            if let _ = self.layer.superlayer {
                
            } else {
                //self.confirmButton.layer.addSublayer(self.layer)
                self.confirmButton.layer.insertSublayer(self.layer, at: 0)
            }
            self.confirmButton.backgroundColor = UIColor.clear
            self.confirmButton.isEnabled = true
        }
        
    }
}
