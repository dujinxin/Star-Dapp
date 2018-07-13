//
//  MainViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class MainViewController: JXCollectionViewController {

    let homeVM = HomeVM()
    var isIpe : Bool = true
    
    
    func setClearNavigationBar(title:String,leftItem:UIView? = nil,rightItem:UIView? = nil) -> UIView {
        
        let navigiationBar = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight))
        let backgroudView = UIView(frame: navigiationBar.bounds)
        
        let titleView = UILabel(frame: CGRect(x: 80, y: kStatusBarHeight, width: kScreenWidth - 160, height: 44))
        titleView.text = title
        titleView.textColor = UIColor.white
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 20)
        
        
        navigiationBar.addSubview(backgroudView)
        navigiationBar.addSubview(titleView)
        
        
        if let left = leftItem {
            navigiationBar.addSubview(left)
            left.frame = CGRect(x: 10, y: kStatusBarHeight + 7, width: 30, height: 30)
        }
        if let right = rightItem {
            right.frame = CGRect(x: kScreenWidth - 10 - 30, y: kStatusBarHeight + 7, width: 30, height: 30)
            navigiationBar.addSubview(right)
        }
        return navigiationBar
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.customNavigationBar.removeFromSuperview()
        self.customNavigationBar.alpha = 0
        
        let additionalBottomHeight : CGFloat = (deviceModel == .iPhoneX) ? 34 : 0
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kTabBarHeight - additionalBottomHeight)
        // Register cell classes
        self.collectionView?.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "HomeReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: kScreenWidth, height: 50)
        
        layout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0, 0)
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: kScreenHeight - kTabBarHeight - additionalBottomHeight + 74 + 44)
        
        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.bounces = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        }else{
            self.showAuth()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    deinit {
        
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.requestData()
        }
    }
    func showAuth() {
        
        //未实名认证
        if UserManager.manager.userEntity.authStatus == 1 {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let auth = storyboard.instantiateViewController(withIdentifier: "AuthVC") as! AuthViewController
            let authVC = UINavigationController.init(rootViewController: auth)
            
            self.navigationController?.present(authVC, animated: false, completion: nil)
        }else{
            print("已认证")
            self.requestData()
        }
    }
    override func requestData() {
        self.homeVM.home { (_, msg, isSuc) in
            //
            self.collectionView?.reloadData()
        }
        self.homeVM.powerRank(limit: 15) { (_, msg, isSuc) in
            
        }
//        self.homeVM.coinRank(limit: 10) { (_, msg, isSuc) in
//
//        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
}
extension MainViewController {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isIpe == true {
            return self.homeVM.homeEntity.coinRankArray.count
        } else {
            return self.homeVM.homeEntity.powerRankArray.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCell
        if self.isIpe == true {
            let entity = self.homeVM.homeEntity.coinRankArray[indexPath.item]
            cell.coinEntity = entity
            cell.indexPath = indexPath
        } else {
            let entity = self.homeVM.homeEntity.powerRankArray[indexPath.item]
            cell.powerEntity = entity
            cell.indexPath = indexPath
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIndentifierHeader, for: indexPath) as! HomeReusableView
        if kind == UICollectionElementKindSectionHeader {
            reusableView.entity = self.homeVM.homeEntity
            reusableView.fetchPowerBlock = {
                let storyboard = UIStoryboard(name: "Task", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "TaskVC") as! TaskViewController
                login.hidesBottomBarWhenPushed = true
                
                //let login = TaskViewController()
                self.navigationController?.pushViewController(login, animated: true)
            }
            reusableView.myPropertyBlock = {
                self.performSegue(withIdentifier: "property", sender: nil)
            }
            reusableView.diamondRankBlock = {
                self.isIpe = true
                //self.collectionView?.reloadSections([0])
                
                var indexArray = [IndexPath]()
                for i in 0..<collectionView.numberOfItems(inSection: 0) {
                    let index = IndexPath.init(item: i, section: 0)
                    indexArray.append(index)
                }
                self.collectionView?.reloadItems(at: indexArray)
            }
            reusableView.powerRankBlock = {
                self.isIpe = false
                
                var indexArray = [IndexPath]()
                for i in 0..<collectionView.numberOfItems(inSection: 0) {
                    let index = IndexPath.init(item: i, section: 0)
                    indexArray.append(index)
                }
                self.collectionView?.reloadItems(at: indexArray)
            }
            reusableView.fetchDiamondBlock = { (id: String) in
                print(id)
                
                self.homeVM.harvestDiamond(id:id,completion: { (_, msg, isSuc) in
                    if isSuc {
                        
                    }
                })
            }
            reusableView.inviteBlock = {
                self.performSegue(withIdentifier: "invite", sender: nil)
            }
            reusableView.helpBlock = {
                self.performSegue(withIdentifier: "help", sender: nil)
            }
        }
        
        return reusableView
    }
}
