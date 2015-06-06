//
//  GoalSetViewController.swift
//  Voithon
//
//  Created by SHOHE on 6/6/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit

class GoalSetViewController: UIViewController, UIPickerViewDelegate {
    
    var pickerValueOne = 0
    var pickerValueTwo = 0
    var pickerValueThree = 0
    var goalPickerValues = ["0","1","2","3","4","5","6","7","8","9"]
    var goalPickerThreeValues = ["0","5"]
    
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var GoalPickerOne: UIPickerView!
    @IBOutlet weak var GoalPickerTwo: UIPickerView!
    @IBOutlet weak var GoalPickerThree: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        GoalPickerOne.delegate = self
        GoalPickerTwo.delegate = self
        GoalPickerThree.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func beginRun(sender: AnyObject) {
        // 画面遷移
        let runViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RunViewController") as! RunViewController
        runViewController.goleDistance = (Float(pickerValueOne*10)) + Float(pickerValueTwo) + (Float(pickerValueThree)/10)
        self.presentViewController(runViewController, animated: true, completion: nil)
    }
}

extension GoalSetViewController: UIPickerViewDataSource {
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 3 ? goalPickerThreeValues.count : goalPickerValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerText(pickerView: pickerView, titleForRow: row)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1: pickerValueOne = row
        case 2: pickerValueTwo = row
        case 3: pickerValueThree = row*5
        default: break
        }
        
        let check = (Float(pickerValueOne*10)) + Float(pickerValueTwo) + (Float(pickerValueThree)/10)
        if check > 0 {
            runButton.enabled = true
            runButton.backgroundColor = UIColor.VoithonRed()
        } else {
            runButton.enabled = false
            runButton.backgroundColor = UIColor.VoithonRedDark()
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50;
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.VoithonRed()
        pickerLabel.text = pickerText(pickerView: pickerView, titleForRow: row)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 50)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    private func pickerText(#pickerView: UIPickerView, titleForRow row: Int) -> String! {
        if pickerView.tag == 3 {
            switch row {
            case 0:
                return goalPickerThreeValues[0] as String
            case 1:
                return goalPickerThreeValues[1] as String
            default:
                return ""
            }
        } else {
            switch row {
            case 0:
                return goalPickerValues[0] as String
            case 1:
                return goalPickerValues[1] as String
            case 2:
                return goalPickerValues[2] as String
            case 3:
                return goalPickerValues[3] as String
            case 4:
                return goalPickerValues[4] as String
            case 5:
                return goalPickerValues[5] as String
            case 6:
                return goalPickerValues[6] as String
            case 7:
                return goalPickerValues[7] as String
            case 8:
                return goalPickerValues[8] as String
            case 9:
                return goalPickerValues[9] as String
            default:
                return ""
            }
        }
    }
}
