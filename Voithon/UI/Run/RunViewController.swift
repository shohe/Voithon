//
//  RunViewController.swift
//  Voithon
//
//  Created by SHOHE on 6/6/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class RunViewController: UIViewController, CLLocationManagerDelegate {
    
    // ゴール
    var goleDistance: Float = 0.0
    var gole: Int = 0
    var goleLabel = UILabel()
    
    // チャート
    var timecolon = UILabel()
    var timeTen = UILabel()
    var timeOne = UILabel()
    var center = CGPoint()
    var circleChart = PNCircleChart()
    
    // タイマー
    var timer = NSTimer()
    var timeCount = 0
    var isFirst = true
    
    // 位置情報
    var myLocationManager = CLLocationManager()
    
    // suruさん
    var suru = AVSpeechSynthesizer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initTimeLabel()
        initChart()
        initLocationManager()
        initTimer()
        
        suru = AVSpeechSynthesizer()
        suru.delegate = self
        suruTalk("こんにちは\(User.getName())さん。目標達成目指して頑張りましょう。")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initChart() {
        gole = 100//Int(goleDistance*1000)
        let chartSize = self.view.frame.width-40
        let frame = CGRectMake(center.x-chartSize/2, timecolon.frame.origin.y-chartSize-40, chartSize, chartSize)
        circleChart = PNCircleChart(frame: frame, total: NSNumber(integer: gole), current: NSNumber(integer: 0), clockwise: true, shadow: false, shadowColor: nil, displayCountingLabel: false, overrideLineWidth: NSNumber(integer: 40))
        circleChart.backgroundColor = UIColor.clearColor()
        circleChart.strokeColor = UIColor.VoithonRed()
        circleChart.strokeChart()
        self.view.addSubview(circleChart)
        
        let box = UIView(frame: CGRectMake(0, 0, chartSize-130, chartSize-130))
        box.center = circleChart.center
        self.view.addSubview(box)
        
        let left = UILabel(frame: CGRectMake(0, 25, box.frame.size.width,  box.frame.size.height/3-10))
        left.text = "残り"
        left.textColor = UIColor.VoithonRed()
        left.font = UIFont(name: "Arial-BoldMT", size: 20)
        left.textAlignment = NSTextAlignment.Center
        box.addSubview(left)
        
        goleLabel = UILabel(frame: CGRectMake(0, left.frame.height, box.frame.size.width,  box.frame.size.height/3*2-10))
        goleLabel.text = (Int(goleDistance*1000)-gole < 10) ? "0"+String(stringInterpolationSegment: Int(goleDistance*1000)-gole)+"km" : String(stringInterpolationSegment: Int(goleDistance*1000)-gole)+"km"
        goleLabel.textColor = UIColor.VoithonRed()
        goleLabel.font = UIFont(name: "Arial-BoldMT", size: 40)
        goleLabel.textAlignment = NSTextAlignment.Center
        box.addSubview(goleLabel)
    }
    
    func initTimeLabel() {
        timeCount = 0
        isFirst = true
        center = CGPoint(x: self.view.center.x, y: self.view.center.y-80)
        
        // :
        timecolon = UILabel(frame: CGRectMake(center.x-10, self.view.frame.height-170, 20, 40))
        timecolon.text = ":"
        timecolon.textColor = UIColor.VoithonRed()
        timecolon.font = UIFont(name: "Arial-BoldMT", size: 50)
        timecolon.textAlignment = NSTextAlignment.Center
        self.view.addSubview(timecolon)
        
        // 10の位
        timeTen = UILabel(frame: CGRectMake(timecolon.frame.origin.x-80, timecolon.frame.origin.y, 100, 50))
        timeTen.text = "00"
        timeTen.textColor = UIColor.VoithonRed()
        timeTen.font = UIFont(name: "Arial-BoldMT", size: 60)
        timeTen.textAlignment = NSTextAlignment.Center
        self.view.addSubview(timeTen)
        
        // 1の位
        timeOne = UILabel(frame: CGRectMake(timecolon.frame.origin.x, timecolon.frame.origin.y, 100, 50))
        timeOne.text = "00"
        timeOne.textColor = UIColor.VoithonRed()
        timeOne.font = UIFont(name: "Arial-BoldMT", size: 60)
        timeOne.textAlignment = NSTextAlignment.Center
        self.view.addSubview(timeOne)
    }
    
    func initLocationManager() {
        myLocationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.NotDetermined  {
            self.myLocationManager.requestAlwaysAuthorization()
        }
        myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        myLocationManager.distanceFilter = 10
        myLocationManager.startUpdatingLocation()
    }
    
    func initTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timeUpdate:", userInfo: nil, repeats: true)
    }
    
    func timeUpdate(timer: NSTimer) {
        timeCount++
        
        timeOne.text = (timeCount%60 < 10) ? "0".stringByAppendingFormat("%i",timeCount%60) : String(timeCount%60)
        timeTen.text = (timeCount/60 < 10) ? "0".stringByAppendingFormat("%i",timeCount/60) : String(timeCount/60)
    }
    
    func suruTalk(talkText: String) {
        let utterance = AVSpeechUtterance(string: talkText)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.3
        utterance.pitchMultiplier = 2.0
        suru.speakUtterance(utterance)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        var statusStr = "";
        
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        
        println("CLAuthorizationStatus: \(statusStr)")
    }
    
    func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
    
        if !isFirst {
            println("緯度： \(manager.location.coordinate.latitude)")
            println("経度： \(manager.location.coordinate.longitude)")
            gole = (gole > 0) ? gole -  10 : 0
            circleChart.updateChartByCurrent(NSNumber(integer: circleChart.current.integerValue+10))
            
            if gole <= 0 {
                goleLabel.text = "00.0km"
                myLocationManager.stopUpdatingLocation()
                let goalViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GoalViewController") as! GoalViewController
                goalViewController.delegate = self
                goalViewController.times = timeCount
                self.presentViewController(goalViewController, animated: true, completion: nil)
            } else {
                let gl = Float(gole) / 1000
                goleLabel.text = String(format: "%.01f", gl)
                goleLabel.text = (gl < 10) ? "0"+goleLabel.text!+"km" : goleLabel.text!+"km"
            }
            
        }
        isFirst = false
    }
    
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("error: \(error)")
    }

}

extension RunViewController: UIAlertViewDelegate {
    
    @IBAction func giveUp(sender: AnyObject) {
        if objc_getClass("UIAlertController") != nil {
            var ac = UIAlertController(title: "GIVE UP", message: "トップページに戻ります。", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                println("Cancel button tapped.")
            }
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                self.myLocationManager.stopUpdatingLocation()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            ac.addAction(cancelAction)
            ac.addAction(okAction)
            presentViewController(ac, animated: true, completion: nil)
            
        } else {
            var av = UIAlertView(title: "GIVE UP", message:"トップページに戻ります。", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            av.delegate = self
            av.show()
        }
        
        func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
            if (buttonIndex == alertView.cancelButtonIndex) {
                println("Cancel button tapped.")
            } else {
                myLocationManager.stopUpdatingLocation()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
}

extension RunViewController: GoalViewControllerDelegate {
    func didFinishGole(viewController: UIViewController) {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didCancel(viewController: UIViewController) {
        println("Cancel button tapped.")
    }
}

extension RunViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        println("start")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        println("end")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        let word = (utterance.speechString as NSString).substringWithRange(characterRange)
        // println("Speech: \(word)")
    }
}

