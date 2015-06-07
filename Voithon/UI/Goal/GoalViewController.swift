//
//  GoalViewController.swift
//  Voithon
//
//  Created by SHOHE on 6/6/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit

protocol GoalViewControllerDelegate: class {
    func didFinishGole(viewController: UIViewController)
    func didCancel(viewController: UIViewController)
}

class GoalViewController: UIViewController {
    
    
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: GoalViewControllerDelegate?
    var times = 0
    var names = ["hello", "world", "hello", "Swift"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTimeLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTimeLabel() {
        let time = UILabel(frame: CGRectMake(0, messageLabel.frame.height, self.view.frame.width, box.frame.height-messageLabel.frame.height))
        let ten = (times%60 < 10) ? "0".stringByAppendingFormat("%i",times%60) : String(times%60)
        let one = (times/60 < 10) ? "0".stringByAppendingFormat("%i",times/60) : String(times/60)
        time.text = "\(ten):\(one)"
        time.textColor = UIColor.VoithonRed()
        time.font = UIFont(name: "Arial-BoldMT", size: 50)
        time.textAlignment = NSTextAlignment.Center
        
        
        box.addSubview(time)
    }
}

extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: VoithonCell = tableView.dequeueReusableCellWithIdentifier("VoithonCell", forIndexPath: indexPath) as! VoithonCell
        cell.setCell(UIImage(named: "test.jpg")!, place: "渋谷", name: "hello-shohe")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        var text: String = names[indexPath.row]
        println(text)
    }
}

extension GoalViewController: UIAlertViewDelegate {
    
    @IBAction func backTop(sender: AnyObject) {
        if objc_getClass("UIAlertController") != nil {
            var ac = UIAlertController(title: "GOLE!!", message: "トップページに戻ります。", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                self.delegate?.didCancel(self)
            }
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                self.delegate?.didFinishGole(self)
            }
            
            ac.addAction(cancelAction)
            ac.addAction(okAction)
            presentViewController(ac, animated: true, completion: nil)
            
        } else {
            var av = UIAlertView(title: "GOLE!!", message:"トップページに戻ります。", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            av.delegate = self
            av.show()
        }
        
        func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            if (buttonIndex == alertView.cancelButtonIndex) {
                self.delegate?.didCancel(self)
            } else {
                self.delegate?.didFinishGole(self)
            }
        }
    }
    
}
