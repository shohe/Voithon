//
//  Voithon.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import Foundation
import UIKit

class Voithon: API {
    
    override class func baseURL() -> NSURL {
        return NSURL(string: "http://192.168.100.25:8000")!
    }
    
    class Request {
        
    }
}

// MARK: - Register
extension Voithon.Request {
    class Register: VoithonRequest {
        
        typealias Response = Bool
        
        let name: String
        let pass: String
        var imgFile: UIImage?
        
        init(name: String, pass: String, imgFile: UIImage?) {
            self.name = name
            self.pass = pass
            self.imgFile = imgFile
        }
        
        var URLRequest: NSURLRequest? {
            var parameters = ["name": name, "pass": pass, "imgFile": imgFile!]
            return Voithon.URLRequest(.POST, path: "/users/register", parameters: parameters)
        }
        
        func responseFromError(object: AnyObject) -> NSError? {
            if let jsonObject = object as? JSON {
                let error = APIError(json: jsonObject)
                if error.isError {
                    let userInfo = [NSLocalizedDescriptionKey: error.errorMessage]
                    let error = NSError(domain: VoithonAPIErrorDomain, code: error.errorCode, userInfo: userInfo)
                    return error
                } else {
                    let errors = jsonObject["error"].asArray
                    if errors?.count > 0 {
                        let userInfo = [NSLocalizedDescriptionKey: "api request error -> \(errors)"]
                        let error = NSError(domain: VoithonAPIErrorDomain, code: error.errorCode, userInfo: userInfo)
                        return error
                    }
                    return nil
                }
            } else {
                return nil
            }
        }
        
        func responseFromObject(object: AnyObject) -> Response? {
            if let jsonObject = object as? JSON {
                var isSuccess = false
                
                if jsonObject["status"].asString == "OK" {
                    isSuccess = true
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setObject(jsonObject["name"].asString, forKey: UserNameKey)
                }
                return isSuccess
            }
            return nil
        }
    }
}



// MARK: - Login
extension Voithon.Request {
    class Login: VoithonRequest {
        
        typealias Response = Bool
        
        let name: String
        let pass: String
        
        init(name: String, pass: String) {
            self.name = name
            self.pass = pass
        }
        
        var URLRequest: NSURLRequest? {
            var parameters = ["name": name, "pass": pass]
            return Voithon.URLRequest(.GET, path: "/users/login", parameters: parameters)
        }
        
        func responseFromError(object: AnyObject) -> NSError? {
            if let jsonObject = object as? JSON {
                let error = APIError(json: jsonObject)
                if error.isError {
                    let userInfo = [NSLocalizedDescriptionKey: error.errorMessage]
                    let error = NSError(domain: VoithonAPIErrorDomain, code: error.errorCode, userInfo: userInfo)
                    return error
                } else {
                    let errors = jsonObject["error"].asArray
                    if errors?.count > 0 {
                        let userInfo = [NSLocalizedDescriptionKey: "api request error -> \(errors)"]
                        let error = NSError(domain: VoithonAPIErrorDomain, code: error.errorCode, userInfo: userInfo)
                        return error
                    }
                    return nil
                }
            } else {
                return nil
            }
        }
        
        func responseFromObject(object: AnyObject) -> Response? {
            if let jsonObject = object as? JSON {
                var isSuccess = false
                
                if jsonObject["status"].asString == "OK" {
                    isSuccess = true
                }
                return isSuccess
            }
            return nil
        }
    }
}




// MARK: - BeginRun
extension Voithon.Request {
    class BeginRun: VoithonRequest {
        
        typealias Response = Bool
        
        let name: String
        let target: Float
        let latitude: Float
        let longitude: Float
        
        init(name: String, target: Float, latitude: Float, longitude: Float) {
            self.name = name
            self.target = target
            self.latitude = latitude
            self.longitude = longitude
        }
        
        var URLRequest: NSURLRequest? {
            var parameters: [String:AnyObject] = [:]
            parameters = ["name": name, "target": target, "latitude": latitude, "longitude": longitude]
            return Voithon.URLRequest(.GET, path: "/run/begin", parameters: parameters)
        }
        
        func responseFromError(object: AnyObject) -> NSError? {
            if let jsonObject = object as? JSON {
                let error = APIError(json: jsonObject)
                if error.isError {
                    let userInfo = [NSLocalizedDescriptionKey: error.errorMessage]
                    let error = NSError(domain: VoithonAPIErrorDomain, code: error.errorCode, userInfo: userInfo)
                    return error
                } else {
                    let errors = jsonObject["error"].asArray
                    if errors?.count > 0 {
                        let userInfo = [NSLocalizedDescriptionKey: "api request error -> \(errors)"]
                        let error = NSError(domain: VoithonAPIErrorDomain, code: error.errorCode, userInfo: userInfo)
                        return error
                    }
                    return nil
                }
            } else {
                return nil
            }
        }
        
        func responseFromObject(object: AnyObject) -> Response? {
            if let jsonObject = object as? JSON {
                var isSuccess = false
                
                if jsonObject["status"].asString == "OK" {
                    isSuccess = true
                }
                return isSuccess
            }
            return nil
        }
    }
}



// MARK: - FinishRun
extension Voithon.Request {
    class FinishRun: VoithonRequest {
        
        typealias Response = Bool
        
        let name: String
        let target: Float
        let latitude: Float
        let longitude: Float
        
        init(name: String, target: Float, latitude: Float, longitude: Float) {
            self.name = name
            self.target = target
            self.latitude = latitude
            self.longitude = longitude
        }
        
        var URLRequest: NSURLRequest? {
            var parameters: [String:AnyObject] = [:]
            parameters = ["name": name, "target": target, "latitude": latitude, "longitude": longitude]
            return Voithon.URLRequest(.GET, path: "/run/begin", parameters: parameters)
        }
        
        func responseFromError(object: AnyObject) -> NSError? {
            if let jsonObject = object as? JSON {
                let error = APIError(json: jsonObject)
                if error.isError {
                    let userInfo = [NSLocalizedDescriptionKey: error.errorMessage]
                    let error = NSError(domain: VoithonAPIErrorDomain, code: error.errorCode, userInfo: userInfo)
                    return error
                } else {
                    let errors = jsonObject["error"].asArray
                    if errors?.count > 0 {
                        let userInfo = [NSLocalizedDescriptionKey: "api request error -> \(errors)"]
                        let error = NSError(domain: VoithonAPIErrorDomain, code: error.errorCode, userInfo: userInfo)
                        return error
                    }
                    return nil
                }
            } else {
                return nil
            }
        }
        
        func responseFromObject(object: AnyObject) -> Response? {
            if let jsonObject = object as? JSON {
                var isSuccess = false
                
                if jsonObject["status"].asString == "OK" {
                    isSuccess = true
                }
                return isSuccess
            }
            return nil
        }
    }
}