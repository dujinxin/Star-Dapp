//
//  TaskViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

private let headViewHeight : CGFloat = 278

class TaskViewController: UICollectionViewController {

    let taskVM = TaskVM()
    let vm = IdentifyVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        self.taskVM.taskList { (_, msg, isSuc) in
            if isSuc {
                self.collectionView?.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        self.view.backgroundColor = JXF1f1f1Color
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "imgBack"), for: .normal)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(5, 9, 5, 9)
        //leftButton.setTitle("up", for: .normal)
        leftButton.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "iconInfo"), for: .normal)
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        rightButton.addTarget(self, action: #selector(checkDetail), for: .touchUpInside)
        
        let navigationBar = self.setClearNavigationBar(title: "提升智慧", leftItem: leftButton,rightItem: rightButton)
        self.view.addSubview(navigationBar)
        
        
        let width = (kScreenWidth - 0.5 * 2) / 3
        //let height = width * kPercent
        let height : CGFloat = 122
        
        //self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: layout)
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: width, height: height)
        
        layout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0, 0)
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 272 + kNavStatusHeight)

        self.collectionView?.collectionViewLayout = layout
        
        // Register cell classes
        self.collectionView?.register(UINib.init(nibName: "TaskCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "TaskReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
        
        if #available(iOS 11.0, *) {
            self.collectionView?.contentInsetAdjustmentBehavior = .never
            self.collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    @objc func backTo() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func checkDetail() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateViewController(withIdentifier: "HelpVC") as! HelpViewController
        login.hidesBottomBarWhenPushed = true
        //let login = TaskViewController()
        self.navigationController?.pushViewController(login, animated: true)
    }
    func setClearNavigationBar(title:String,leftItem:UIView,rightItem:UIView? = nil) -> UIView {
        
        let navigiationBar = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight))
        let backgroudView = UIView(frame: navigiationBar.bounds)
        
        let titleView = UILabel(frame: CGRect(x: 80, y: kStatusBarHeight, width: kScreenWidth - 160, height: 44))
        titleView.text = title
        titleView.textColor = UIColor.white
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 17)
        
        leftItem.frame = CGRect(x: 10, y: kStatusBarHeight + 7, width: 30, height: 30)
        
        navigiationBar.addSubview(backgroudView)
        navigiationBar.addSubview(titleView)
        
        navigiationBar.addSubview(leftItem)
        if let right = rightItem {
            right.frame = CGRect(x: kScreenWidth - 10 - 30, y: kStatusBarHeight + 7, width: 30, height: 30)
            navigiationBar.addSubview(right)
        }
        return navigiationBar
        
    }
    func imageWithColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.taskVM.taskListEntity.tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TaskCell
        let taskEntity = self.taskVM.taskListEntity.tasks[indexPath.item]
        cell.entity = taskEntity
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIndentifierHeader, for: indexPath) as! TaskReusableView
        if kind == UICollectionElementKindSectionHeader {
            reusableView.klLable.text = "\(self.taskVM.taskListEntity.power)"
            reusableView.powerRecordBlock = {
                let vc = PowerRecordController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            reusableView.dayTaskBlock = {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "ArticleVC") as! ArticleListController
                login.hidesBottomBarWhenPushed = true
                login.type = .task
                self.navigationController?.pushViewController(login, animated: true)
            }
        }
        
        return reusableView
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entity = self.taskVM.taskListEntity.tasks[indexPath.item]
        if entity.finishStatus == 1 {
            return
        }
        switch entity.id {
        case 3:
            self.performSegue(withIdentifier: "attention", sender: nil)
        case 4:
            self.identifyUserLiveness()
        case 5:
            self.taskVM.createWallet { (_, msg, _) in
                ViewManager.showNotice(msg)
            }
        case 6:
            self.taskVM.backupWallet { (_, msg, _) in
                ViewManager.showNotice(msg)
            }
        case 7:
            self.performSegue(withIdentifier: "modifyImage", sender: nil)
        default:
            print("未知任务")
        }
    }

    func identifyUserLiveness() {
        
        
        let licenseFile = Bundle.main.path(forResource: FACE_LICENSE_NAME, ofType: FACE_LICENSE_SUFFIX)
        if let filePath = licenseFile, FileManager.default.fileExists(atPath: filePath) == true {
            print("liveness = ",FaceSDKManager.sharedInstance().canWork())
            FaceSDKManager.sharedInstance().setLicenseID(FACE_LICENSE_ID, andLocalLicenceFile: filePath)
        }
        
        let vc = LivenessViewController()
        let model = LivingConfigModel()
        vc.livenesswithList(model.liveActionArray as! [Any]?, order: model.isByOrder, numberOfLiveness: model.numOfLiveness)
        vc.completion = {(images,image) in
            guard let imageDict = images else { return }
            let bestImage = imageDict["bestImage"] as? Array<Any>
            //let data = Data(base64Encoded: bestImage?.last, options:Data.Base64DecodingOptions.ignoreUnknownCharacters)
            var data = UIImageJPEGRepresentation(image!, 0.6)
            if data == nil {
                data = UIImagePNGRepresentation(image!)
            }
            //            let imageStr = data?.base64EncodedString(options: .endLineWithLineFeed)
            let _ = UIImage.insert(image: image!, name: "facePhoto.jpg")
            self.vm.identifyInfo(param: [:], completion: { (_, msg, isSuc) in
                ViewManager.showNotice(msg)
                if isSuc {
                    let _ = UIImage.delete(name: "facePhoto.jpg")
                    self.taskVM.taskList { (_, msg, isSuc) in
                        if isSuc {
                            self.collectionView?.reloadData()
                        }
                    }
                }
                self.dismiss(animated: true, completion: {})
                
            })
            
            //
            //            self.vm.ocr(imageStr: imageStr ?? "", completion: { (data, msg, isSuccess) in
            //
            //                DispatchQueue.main.async(execute: {
            //                    var isSucc = false
            //                    var tip = "验证分数"
            //                    var score = "0"
            //                    if isSuccess {
            //                        guard
            //                            let dict = data as? Dictionary<String,Any>
            //                            else{
            //                                return
            //                        }
            //                        if
            //                            let result = dict["result"] as? Dictionary<String,Any>,
            //                            let s = result["score"] as? Double{
            //                            score = String(format: "%.4f", s)
            //                            if s > 80.0 {
            //                                isSucc = true
            //                            }
            //                        } else if
            //                            let i = dict["error_code"] as? Int, let message = dict["error_msg"] as? String{
            //                            //                            if i == 216600 {
            //                            //                                tip = "身份证号码错误"
            //                            //                            } else if i == 216601 {
            //                            //                                tip = "身份证号码与姓名不匹配"
            //                            //                            }
            //                            tip = message
            //                        } else {
            //
            //                        }
            //
            //                    } else {
            //
            //                    }
            //                    let dict = ["isSucc":isSucc,"tip":tip,"score":score] as [String:Any]
            //                    self.performSegue(withIdentifier: "result", sender: dict)
            //                })
            //
            //            })
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.isNavigationBarHidden = true
        self.present(nvc, animated: true, completion: nil)
    }
}
