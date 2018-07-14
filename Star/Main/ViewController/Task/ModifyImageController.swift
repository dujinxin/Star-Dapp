//
//  ModifyImageController.swift
//  Star
//
//  Created by 杜进新 on 2018/6/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ModifyImageController: BaseViewController {

    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var isSelected = false
    var imageVM = ModifyImageVM()
    var avatar : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置头像"
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: confirmButton.jxWidth, height: confirmButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.confirmButton.layer.addSublayer(gradientLayer)
        self.confirmButton.backgroundColor = UIColor.clear
        
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提交", style: UIBarButtonItemStyle.plain, target: self, action: #selector(confirm))
        
        if let str = self.avatar,let url = URL(string: str){
            self.userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "portrait_default_big"), options: [], progress: nil, completed: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }

    @IBAction func selectImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
            self.showImagePickerViewController(.camera)
        }))
        alert.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            self.showImagePickerViewController(.photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc func confirm() {
        if isSelected {
            let _ = UIImage.insert(image: self.userImageView.image!, name: "userImage.jpg")
            
            self.imageVM.modifyImage(param: [:]) { (_, msg, isSuc) in
                if isSuc {
                    let _ = UIImage.delete(name: "userImage.jpg")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            ViewManager.showNotice("请先选择图片")
        }
    }
    
    func showImagePickerViewController(_ sourceType:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.title = "选择照片"
        imagePicker.navigationBar.barTintColor = UIColor.blue
        imagePicker.navigationBar.tintColor = UIColor.white
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
}
extension ModifyImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == "public.image"{
            let image = info[UIImagePickerControllerEditedImage] as? UIImage
            //UIImage.image(originalImage: image, to: view.bounds.width)
            self.userImageView.image = image
            isSelected = true
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}