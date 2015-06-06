//
//  RunViewController.swift
//  Voithon
//
//  Created by SHOHE on 6/6/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit
import CoreLocation

class RunViewController: UIViewController, CLLocationManagerDelegate {
    
    // ゴール
    var goleDistance = Float()
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
    var isFirst = -1
    
    // 位置情報
    var myLocationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initTimeLabel()
        initChart()
        initLocationManager()
        initTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initChart() {
        let chartSize = self.view.frame.width-40
        let frame = CGRectMake(center.x-chartSize/2, timecolon.frame.origin.y-chartSize-40, chartSize, chartSize)
        circleChart = PNCircleChart(frame: frame, total: NSNumber(integer: 100), current: NSNumber(integer: 60), clockwise: true, shadow: false, shadowColor: nil, displayCountingLabel: false, overrideLineWidth: NSNumber(integer: 40))
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
        goleLabel.text = (goleDistance < 10) ? "0"+String(stringInterpolationSegment: goleDistance)+"km" : String(stringInterpolationSegment: goleDistance)+"km"
        goleLabel.textColor = UIColor.VoithonRed()
        goleLabel.font = UIFont(name: "Arial-BoldMT", size: 40)
        goleLabel.textAlignment = NSTextAlignment.Center
        box.addSubview(goleLabel)
    }
    
    func initTimeLabel() {
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
        myLocationManager.distanceFilter = 100  // debug -> 0.5
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
        
        isFirst++
        if isFirst > 0 {
            println("緯度： \(manager.location.coordinate.latitude)")
            println("経度： \(manager.location.coordinate.longitude)")
            goleDistance -=  0.1
            circleChart.updateChartByCurrent(NSNumber(integer: circleChart.current.integerValue+1))
        }
        
        if goleDistance < 0 {
            goleLabel.text = "00.0km"
        } else {
            goleLabel.text = String(stringInterpolationSegment: goleDistance)
            goleLabel.text = (goleDistance < 10) ? "0"+goleLabel.text!+"km" : goleLabel.text!+"km"
        }
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
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
}

