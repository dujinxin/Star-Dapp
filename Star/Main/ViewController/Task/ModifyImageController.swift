//
//  ModifyImageController.swift
//  Star
//
//  Created by 杜进新 on 2018/6/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ModifyImageController: UIViewController {

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var isSelected = false
    var imageVM = ModifyImageVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func confirm(_ sender: Any) {
        if isSelected {
            let _ = UIImage.insert(image: self.userImageView.image!, name: "userImage.jpg")
            
            self.imageVM.modifyImage(param: [:]) { (_, msg, isSuc) in
                if isSuc {
                    let _ = UIImage.delete(name: "userImage.jpg")
                }
            }
        } else {
            ViewManager.showNotice("请先选择图片")
        }
    }
    
    func showImagePickerViewController(_ sourceType:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.title = "选择照片"
        imagePicker.navigationBar.barTintColor = UIColor.yellow
        
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
