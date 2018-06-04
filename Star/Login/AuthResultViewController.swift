//
//  AuthResultViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/5/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class AuthResultViewController: UIViewController {

    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var isSucc : Bool = false
    var tip: String?
    var score: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isSucc {
            self.showLabel.text = "核真通过"
            self.showLabel.isHighlighted = false
        } else {
            self.showLabel.text = "核真失败"
            self.showLabel.isHighlighted = true
        }
        self.tipLabel.text = tip
        self.scoreLabel.text = score
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirm(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
