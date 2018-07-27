//
//  TradeDetailController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import QuickLook

class TradeDetailController: JXTableViewController {
    
    let tradeVM = TradeVM()
    let paperVM = PaperVM()
    
    var id : String = ""
    var url : URL?
    
    
    var process : String = "0/0"
    
    lazy var bottomView: UIView = {
        let contentView = UIView()
        contentView.addSubview(self.checkButton)
        contentView.addSubview(self.infoButton)
        return contentView
    }()
    lazy var checkButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.setTitle("查看完整论文", for: UIControlState.normal)
        button.addTarget(self, action: #selector(clickAction(button:)), for: UIControlEvents.touchUpInside)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: 44)
        gradientLayer.cornerRadius = 22
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        return button
    }()
    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor.rgbColor(rgbValue: 0x1296db), for: UIControlState.normal)
        button.setTitle("交易详情将被IPXE区块链记录，首次交易的永久智慧值！", for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "Shape"), for: .normal)
        button.addTarget(self, action: #selector(clickAction(button:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "交易详情"
        
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.contentInset = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        self.tableView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - (64 + 60 + kBottomMaginHeight))
        self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.register(UINib(nibName: "PaperDetailTopCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierTop")
        self.tableView?.register(UINib(nibName: "PaperDetailCommonCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCommon")
        
        self.view.addSubview(self.bottomView)
        self.bottomView.frame = CGRect(x: 0, y: (self.tableView?.jxBottom)!, width: view.bounds.width, height: kScreenHeight - (self.tableView?.jxHeight)!)
        self.checkButton.frame = CGRect(x: 50, y: 20, width: kScreenWidth - 100, height: 44)
        self.infoButton.frame = CGRect(x: 5, y: self.checkButton.jxBottom + 20, width: kScreenWidth - 10, height: 20)
        
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    override func requestData() {
        self.tradeVM.tradeDetails(self.id) { (_, msg, isSuc) in
            if isSuc {
                self.tableView?.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    @objc func clickAction(button: UIButton) {
 
        self.showMBProgressHUD()
        //下载
        self.paperVM.paperDownload(self.tradeVM.tradeDetailEntity.url!, process: { (progress) in
            print(progress.completedUnitCount,"/",progress.totalUnitCount)
        }) { (isSuc, url) in
            print("download ",isSuc)
            self.hideMBProgressHUD()
            
            self.url = url
            
            let vc  = QLPreviewController.init()
            vc.delegate = self
            vc.dataSource = self
            self.present(vc, animated: true) {
                
            }
        }
      
        
        
        
//        if self.vm.tradeDetailEntity. == 1 {
//            self.showMBProgressHUD()
//            //下载
//            self.vm.paperDownload(self.vm.paperDetailEntity.paperEntity.downloadUrl!, process: { (progress) in
//                print(progress.completedUnitCount,"/",progress.totalUnitCount)
//            }) { (isSuc) in
//                print("download ",isSuc)
//                self.hideMBProgressHUD()
//            }
//        } else {
//            //self.tradeBottomView.show()
//        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndetifier = (indexPath.row == 0) ? "reuseIdentifierTop" : "reuseIdentifierCommon"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath) as! PaperDetailTopCell
        cell.selectionStyle = .none
        
//        cell.titleView.text = self.vm.paperDetailEntity.paperEntity.title
//        cell.sourceView.text = self.vm.paperDetailEntity.paperEntity.source
//        cell.tradeView.text = "交易量：\(self.vm.paperDetailEntity.paperEntity.tradeCount)"
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if let entity = sender as? ArticleEntity, identifier == "articleDetail" {
            let vc = segue.destination as! ArticleDetailsController
            vc.articleEntity = entity
        }
    }
    
}
extension TradeDetailController : QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        //let item = urls[index] as QLPreviewItem
        guard let url = self.url else {
            return URL.init(string: "")! as QLPreviewItem
        }
        let item = url as QLPreviewItem
        return item
    }
}
