//
//  ArticleDetailsController.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import WebKit

private let additionalBottomHeight : CGFloat = (deviceModel == .iPhoneX) ? 34 : 0
private let bottomInputViewHeight : CGFloat = 60 + additionalBottomHeight

class ArticleDetailsController: BaseViewController,UITableViewDelegate,UITableViewDataSource,JXInputTextViewDelegate,UIScrollViewDelegate {

    let vm = ArticleVM()
    
    lazy var processView: UIProgressView = {
        let process = UIProgressView()
        process.progressTintColor = UIColor.blue
        process.progress = 0.0
        return process
    }()
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        let preferences = WKPreferences()
        config.preferences = preferences
        //The minimum font size in points default is 0
        config.preferences.minimumFontSize = 10
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = true
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        //通过JS与webView内容交互
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        // 注入JS对象名称senderModel，当JS通过senderModel来调用时，我们可以在WKScriptMessageHandler代理中接收到
        let web = WKWebView(frame: CGRect(), configuration: config)
        
        //web.uiDelegate = self
        web.navigationDelegate = self
        
        return web
    }()
    var tableView : UITableView!
    
    var inputTextView : JXInputTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        //        if #available(iOS 11.0, *) {
        //            self.tableView.contentInsetAdjustmentBehavior = .automatic
        //            self.tableView.contentInset = UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0)//有tabbar时下为49，iPhoneX是88
        //            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0)
        //
        //        } else {
        //            self.automaticallyAdjustsScrollViewInsets = false
        //        }
        
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - bottomInputViewHeight), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        //        self.tableView.mj_header = MJRefreshHeader(refreshingBlock: {
        //            //self.vm.loadNewMainData(completion: <#T##((Any?, String, Bool) -> ())##((Any?, String, Bool) -> ())##(Any?, String, Bool) -> ()#>)
        //        })
        //        self.tableView.mj_header.beginRefreshing()
        self.view.addSubview(self.tableView)
        
        self.inputTextView = JXInputTextView(frame: CGRect(x: 0, y: self.tableView.frame.height, width: view.bounds.width, height: bottomInputViewHeight), style: .bottom, completion:nil)
        self.inputTextView?.delegate = self
        self.inputTextView?.sendBlock = { (_,object) in
            print("发送block",object)
            
            let dict = ["title":"新增","content":object,"status":1]
            self.vm.dataArray.append(dict)
            self.tableView.reloadSections([0], with: .automatic)
        }
        self.inputTextView?.limitWords = 1000
        self.inputTextView?.placeHolder = "写下你的评论吧~~🌹🌹🌹"
        self.view.addSubview(self.inputTextView!)
        
        
        self.webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.tableView.bounds.height - bottomInputViewHeight)
        //self.webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 3 * bottomInputViewHeight)
        self.webView.scrollView.isScrollEnabled = false
        self.webView.scrollView.bounces = false
        self.tableView.tableHeaderView = self.webView
        self.webView.scrollView.delegate = self
        
        
        self.processView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 2)
        view.addSubview(self.processView)
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        
        self.showMBProgressHUD()
        self.webView.load(URLRequest(url: URL(string: "https://www.jianshu.com/p/0b781b423170")!))
        //self.webView.load(URLRequest(url: URL(string: "https://find.guangjiego.com/Discovery/home.html")!))
    
        
        self.vm.dataArray = [
            ["title":"标题1","content":"我要上春晚🌹","status":1],
            ["title":"标题2","content":"我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹","status":1],
            ["title":"标题3","content":"我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹我要上春晚🌹","status":1],
            ["title":"标题4","content":"我要上春晚🌹我要上春晚🌹我要上春晚🌹","status":1]]
        
        
    }
    func inputTextViewConfirm(inputTextView: JXInputTextView, object: String?) {
        print("发送delegate",object)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        self.webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "getParames")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationLocatedStatus), object: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if
                let change = change,
                let sizeValue = change[NSKeyValueChangeKey.newKey],
                let size = sizeValue as? CGSize{
                print(size)
                
                if size != self.tableView.tableHeaderView?.frame.size {
                    print("更新header")
                    self.tableView.beginUpdates()
                    self.tableView.tableHeaderView?.frame = CGRect(origin: CGPoint(), size: size)
                    self.tableView.endUpdates()
                }
            }
            
        }else if keyPath == "estimatedProgress"{
            if
                let change = change,
                let processValue = change[NSKeyValueChangeKey.newKey],
                let process = processValue as? Float{
                
                self.processView.setProgress(process, animated: true)//动画有延时，所以要等动画结束再隐藏
                if process == 1.0 {
                    //perform(<#T##aSelector: Selector##Selector#>, with: <#T##Any?#>, afterDelay: <#T##TimeInterval#>)
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25, execute: {
                        self.processView.alpha = 0.0
                    })
                }
            }
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.webView.scrollView {
            print("scrollViewDidScroll = ",scrollView.contentSize)
        }
        if scrollView.isDragging {
            self.view.endEditing(true)
        }
    }
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.vm.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CommentCell
        
        cell.userImageView.backgroundColor = UIColor.randomColor
        cell.userImageView.sd_setImage(with: URL.init(string: String(format: "%@%@?deviceId=%@&method=login&random=", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000))), placeholderImage: nil, options: [], completed: nil)
//        cell.nickNameLabel.text = "标题"
//        cell.statusLabel.text = "精"
//        cell.contentLabel.text = "我要评论😳带表情😔😓"
        
        let dict = self.vm.dataArray[indexPath.row] as! Dictionary<String,Any>
        cell.nickNameLabel.text = dict["title"] as? String
        cell.statusLabel.text = "精"
        cell.contentLabel.text = dict["content"] as? String
        // Configure the cell...
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //self.inputTextView?.show()
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension ArticleDetailsController:WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start")
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("commit")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish",webView.scrollView.contentSize)
        self.hideMBProgressHUD()
//        self.webView.frame = CGRect(origin: CGPoint(), size: size)
//        self.tableView.tableHeaderView?.frame = CGRect(origin: CGPoint(), size: size)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fail:\(error.localizedDescription)")
        self.hideMBProgressHUD()
    }
    
    //当webView的web内容进程被终止时调用。(iOS 9.0之后)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    //监听页面跳转的代理方法，分为：收到跳转与决定是否跳转两种
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    //收到服务器重定向时调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    //当webView需要响应身份验证时调用(如需验证服务器证书)
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
    ////加载错误时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
}
extension ArticleDetailsController :WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message:",message)
    }
}
