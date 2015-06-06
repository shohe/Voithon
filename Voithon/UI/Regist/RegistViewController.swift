//
//  RegistViewController.swift
//  Voithon
//
//  Created by SHOHE on 6/6/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController {
    
    @IBOutlet weak var userPicButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushRegist(sender: AnyObject) {
        // TODO ユーザ登録処理
        
        // 画面遷移
        let topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TopViewController") as! TopViewController
        self.presentViewController(topViewController, animated: false, completion: nil)
    }

}
