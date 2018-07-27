//
//  MyWalletViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import WebKit

//let kDiscoveryUrl = "https://find.guangjiego.com/Discovery/home.html"  //发现
let kWalletUrl = "http://192.168.0.171:8080/"  //钱包

class MyWalletViewController: JXWkWebViewController {
    

    var homeUrl: URL? {
        return URL(string: String.init(format: "%@wallet?sid=%@", kHtmlUrl,UserManager.manager.userEntity.smart_sid))
    }
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "scanIcon"), for: .normal)
        //leftButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 12, 24)
        leftButton.addTarget(self, action: #selector(goScan), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: leftButton)
        return item
    }()
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的钱包"
        
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "imgBack"), for: .normal)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
        leftButton.addTarget(self, action: #selector(goback), for: .touchUpInside)
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
        
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)

        self.webView.configuration.userContentController.add(self, name: "getParames")
        self.webView.configuration.userContentController.add(self, name: "titleFn")
        self.webView.configuration.userContentController.add(self, name: "copyFn")
        self.webView.configuration.userContentController.add(self, name: "scanFn")
        
        //[self.bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
//        self.webView.evaluateJavaScript("getParames()") { (data, error) in
//            print(data,error)
//            if let error = error {
//                print(error.localizedDescription)
//            }else{
//                print(data)
//            }
//        }
        
        let web = UIWebView(frame: view.bounds)
        if let userAgent = web.stringByEvaluatingJavaScript(from: "navigator.userAgent") {
            if !(userAgent.contains("platformParams=")) {
                let dict = ["platform":"ios"]
                guard
                    let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
                    let jsonStr = String.init(data: data, encoding: .utf8) else{
                    return
                }
                let newUserAgent = userAgent.appendingFormat("platformParams=%@", jsonStr)
                let mdict = ["UserAgent": newUserAgent]
                print("mdict = ",mdict)
                UserDefaults.standard.register(defaults: mdict)
                UserDefaults.standard.synchronize()
            }
        }
        
        self.webView.evaluateJavaScript("navigator.userAgent") { (data, error) in
            
            if let error = error {
                print("Error = ",error.localizedDescription)
            } else {
                print("navigator.userAgent = ",data ?? "")
            }
        }
        
        
//        if let url = homeUrl {
//            self.webView.load(URLRequest(url: url))
//        }
        let url = URL.init(string: kWalletUrl)
        self.webView.load(URLRequest(url: url!))

        

        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        
        if keyPath == "title" {
            //self.title = self.webView.title
            //            if  self.webView.title == "首页" {
            //                self.navigationItem.leftBarButtonItem = nil
            //            }else {
            //                self.title = self.webView.title;
            //                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(goback))
            //            }
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
        }else if keyPath == "URL"{
            guard
                let change = change,
                let value = change[NSKeyValueChangeKey.newKey],
                let url = value as? URL else{
                    return
            }
            print("webview.url = " + (webView.url?.absoluteString)!)
            print("url = " + url.absoluteString)
            
            if webView.url?.absoluteString == homeUrl?.absoluteString {
                //            self.navigationItem.leftBarButtonItem = nil
                print("首页")
                
            }else {
                //            self.title = self.webView.title;
                //            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(goback))
                print("次级")
            }
        }
        
    }
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "URL")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "getParames")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationLocatedStatus), object: nil)
    }
    @objc func goback() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func goScan() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getParames() -> String{
        print("1234567890")
        ViewManager.showNotice("123456789")
        //callBack!("1234567890")
        return UserManager.manager.userEntity.smart_sid
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true,
            let url = homeUrl{
            
            self.webView.load(URLRequest(url: url))
            
        }
    }
}
extension MyWalletViewController {
    
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        super.webView(webView, didStartProvisionalNavigation: navigation)
    }
    override func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        super.webView(webView, didCommit: navigation)
    }
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
    }
    override func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        super.webView(webView, didFail: navigation, withError: error)
    }
}
extension MyWalletViewController {
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message:",message)
        print("message.name:",message.name)
        print("message.body:",message.body)
        print("message.frameInfo:",message.frameInfo)

        if message.name == "titleFn" {
            guard let body = message.body as? String else {
                return
            }
            self.title = body
        } else if message.name == "copyFn" {
            guard let body = message.body as? String else {
                return
            }
            let pals = UIPasteboard.general
            pals.string = body
        } else if message.name == "scanFn" {
            guard let body = message.body as? Bool else {
                return
            }
            print(body)
            if body == true {
                self.customNavigationItem.rightBarButtonItem = self.rightBarButtonItem
            } else {
                self.customNavigationItem.rightBarButtonItem = nil
            }
        }
    }
}
