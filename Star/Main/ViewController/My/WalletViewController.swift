//
//  WalletViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.layer.cornerRadius = 5
        importButton.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func create(_ sender: Any) {
        ViewManager.showNotice("create")
    }
    @IBAction func `import`(_ sender: Any) {
        ViewManager.showNotice("import")
    }
}
