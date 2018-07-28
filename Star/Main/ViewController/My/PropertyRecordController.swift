//
//  PropertyRecordController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class PropertyRecordController: UIViewController,JXTopBarViewDelegate,JXHorizontalViewDelegate {
    
    var topBar : JXTopBarView?
    var horizontalView : JXHorizontalView?
    
    lazy var wholeRVC: SubRecordController = {
        let vc = SubRecordController()
        vc.type = SubType.whole
        return vc
    }()
    lazy var inRVC: SubRecordController = {
        let vc = SubRecordController()
        vc.type = .comeIn
        return vc
    }()
    lazy var outRVC: SubRecordController = {
        let vc = SubRecordController()
        vc.type = .payOut
        return vc
    }()
    
    var keystoreStr = ""
    

    //MARK: - custom NavigationBar
    //自定义导航栏
    lazy var customNavigationBar : PropertyRecordNavigationBar = {
        let navigationBar = PropertyRecordNavigationBar(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNavStatusHeight))
        navigationBar.barTintColor = UIColor.white
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
        view.backgroundColor = UIColor.groupTableViewBackground
        self.navigationController?.navigationBar.barStyle = .default
        setCustomNavigationBar()
        
        self.title = "我的水晶IPE"
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "imgBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
        leftButton.tintColor = UIColor.black
        leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
        topBar = JXTopBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["全部","收入","支出"])
        topBar?.delegate = self
        topBar?.isBottomLineEnabled = true
        topBar?.backgroundColor = UIColor.rgbColor(from: 241, 242, 247)
        topBar?.layer.borderColor = UIColor.rgbColor(from: 203, 210, 238).cgColor
        topBar?.layer.borderWidth = 0.3
        view.addSubview(topBar!)
        
        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [wholeRVC,inRVC,outRVC], parentViewController: self)
        view.addSubview(horizontalView!)
        
//        self.inRVC.view.frame = CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight)
//        view.addSubview(self.inRVC.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
extension PropertyRecordController {
    func jxTopBarView(topBarView: JXTopBarView, didSelectTabAt index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }
    func horizontalViewDidScroll(scrollView:UIScrollView) {
        var frame = self.topBar?.bottomLineView.frame
        let offset = scrollView.contentOffset.x
        frame?.origin.x = (offset / view.bounds.width ) * (view.bounds.width / 3)
        self.topBar?.bottomLineView.frame = frame!
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        //
        if self.topBar?.selectedIndex == indexPath.item {
            return
        }
        resetTopBarStatus(index: indexPath.item)
    }
    
    func resetTopBarStatus(index:Int) {
        
        self.topBar?.selectedIndex = index
        self.topBar?.subviews.forEach { (v : UIView) -> () in
            
            if (v is UIButton){
                let btn = v as! UIButton
                if (v.tag != self.topBar?.selectedIndex){
                    btn.isSelected = false
                }else{
                    btn.isSelected = !btn.isSelected
                }
            }
        }
    }
}
class PropertyRecordNavigationBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight)
        
        self.subviews.forEach { (v) in
            if NSStringFromClass(type(of: v)).contains("UIBarBackground") {
                v.frame = rect
                
            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarContentView") {
                rect.origin.y += kStatusBarHeight
                rect.size.height -= kStatusBarHeight
                v.frame = rect
            }
        }
    }
}
