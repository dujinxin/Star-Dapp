//
//  SmartViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class SmartViewController: BaseViewController {
    
    var topBar : JXBarView?
    var horizontalView : JXHorizontalView?
    
    lazy var article: ArticleListController = {
        let storyboard = UIStoryboard(name: "Smart", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ArticleVC") as! ArticleListController
        vc.hidesBottomBarWhenPushed = true
        vc.type = .tab
        return vc
    }()
    lazy var paper: PaperListController = {
        let vc = PaperListController()
        vc.hidesBottomBarWhenPushed = true
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "智慧"
        
        topBar = JXBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["文章","论文"])
        topBar?.delegate = self
        topBar?.isBottomLineEnabled = true
//        let attribute = TopBarAttribute()
//        attribute.normal
//        topBar?.attribute =
        view.addSubview(topBar!)
        

        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [self.article,self.paper], parentViewController: self)
        view.addSubview(horizontalView!)
        
        
        self.paper.clickBlock = { (id) in
            let vc = PaperDetailController()
            vc.id = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    
}

extension SmartViewController : JXBarViewDelegate {
    
    func jxBarView(barView: JXBarView, didClick index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
    }
}
extension SmartViewController : JXHorizontalViewDelegate {
    
    func horizontalViewDidScroll(scrollView:UIScrollView) {
        var frame = self.topBar?.bottomLineView.frame
        let offset = scrollView.contentOffset.x
        frame?.origin.x = (offset / kScreenWidth ) * (kScreenWidth / CGFloat((self.topBar?.titles.count)!))
        self.topBar?.bottomLineView.frame = frame!
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        if self.topBar?.selectedIndex == indexPath.item {
            return
        }
        self.topBar?.containerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
