//
//  User.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import Foundation
import UIKit

let UserNameKey = "UserNameKey"

class User {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    
    class func regist(name: String, pass: String, imgFile: UIImage?, success:(Bool) -> Void, failure: (NSError) -> Void) {
        
        var image = UIImage(named: "test.jpg")
        if let img = imgFile {
            image = img
        }
        
        let request = Voithon.Request.Register(name: name, pass: pass, imgFile: image)
        Voithon.sendRequest(request, success: { (responce) -> Void in
            success(responce)
            }) { (error) -> Void in
                failure(error)
        }
    }
    
    
    class func login(name: String, pass: String, success:(Bool) -> Void, failure: (NSError) -> Void) {
        let request = Voithon.Request.Login(name: name, pass: pass)
        Voithon.sendRequest(request, success: { (responce) -> Void in
            success(responce)
            }) { (error) -> Void in
                failure(error)
        }
    }
    
    
    class func beginRun(name: String, target: Float, latitude: Float, longitude: Float, success:(Bool) -> Void, failure: (NSError) -> Void) {
        let request = Voithon.Request.BeginRun(name: name, target: target, latitude: latitude, longitude: longitude)
        Voithon.sendRequest(request, success: { (responce) -> Void in
            success(responce)
            }) { (error) -> Void in
                failure(error)
        }
    }
    
    class func getName() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name: String = defaults.objectForKey(UserNameKey) as? String {
            return name
        }
        return "ななし"
    }

}


