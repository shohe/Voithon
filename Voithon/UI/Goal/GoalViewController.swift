//
//  GoalViewController.swift
//  Voithon
//
//  Created by SHOHE on 6/6/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController {

    @IBOutlet weak var box: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
        time.text = "00:00"
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
