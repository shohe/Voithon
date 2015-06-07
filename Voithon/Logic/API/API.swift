//
//  API.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import Foundation


protocol VoithonRequest {
    typealias Response: Any
    
    var URLRequest: NSURLRequest? {get}
    
    func responseFromError(object: AnyObject) -> NSError?
    func responseFromObject(object: AnyObject) -> Response?
}

enum Method: String {
    case GET = "GET"
    case POST = "POST"
}

let VoithonAPIErrorDomain = "VoithonAPIErrorDomain"
let VoithonAPIDebugFlag = true

class API {
    /**
    return base url for api. please override.
    
    :returns: NSURL
    */
    class func baseURL() -> NSURL {
        return NSURL()
    }
    
    
    /**
    return url session for api. please override.
    
    :returns: NSURLSession
    */
    class func URLSession() -> NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    
    /**
    parse help
    
    :returns: ResponseBodyParser
    */
    class func responseBodyParser() -> ResponceBodyParser {
        return ResponceBodyParser.Json
    }
    
    
    /**
    send request to server
    
    :param: VoithonRequest
    
    :returns: NSError?
    :returns: Response?
    :returns: NSURLSessionDataTask?
    */
    class func sendRequest<T: VoithonRequest>(request: T, success: ((T.Response) -> Void)?, failure: ((NSError) -> Void)?) -> NSURLSessionDataTask? {
        let session = URLSession()
        if let URLRequest = request.URLRequest {
            
            if Reachability.reachabilityForInternetConnection().currentReachabilityStatus == .NotReachable {
                // failure?(...)
                return nil
            }
            
            let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data: NSData!, response: NSURLResponse!, connectionError: NSError?) -> Void in
                
                if let error = connectionError {
                    failure?(error)
                    return
                }
                
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode ?? 0
                
                if !contains(200..<300, statusCode) {
                    let userInfo = [NSLocalizedDescriptionKey: "received status code that represents error."]
                    let error = NSError(domain: VoithonAPIErrorDomain, code: statusCode, userInfo: userInfo)
                    failure?(error)
                    return
                }
                
                if let raw: AnyObject = self.responseBodyParser().parseData(data) {
                    
                    if VoithonAPIDebugFlag {
                        print("request url : \(URLRequest)\nresponce json : \(raw)\n----------\n")
                    }
                    
                    if let apiError = request.responseFromError(raw) {
                        failure?(apiError)
                        return
                    }
                    
                    if let res = request.responseFromObject(raw) {
                        success?(res)
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey: "failed to create model object from raw object."]
                        let error = NSError(domain: VoithonAPIErrorDomain, code: statusCode, userInfo: userInfo)
                        failure?(error)
                    }
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "failed to create model object from raw object."]
                    let error = NSError(domain: VoithonAPIErrorDomain, code: statusCode, userInfo: userInfo)
                    failure?(error)
                }
            })
            
            if Reachability.reachabilityForInternetConnection().currentReachabilityStatus == .NotReachable {
                // failure?(...)
                return nil
            }
            
            task.resume()
            return task
            
        } else {
            return nil
        }
    }
    
    
    /**
    send create request url
    
    :param: Method
    :param: path
    :param: parameters
    
    :returns: NSURLRequest?
    */
    class func URLRequest(method: Method, path: String, parameters: [String:AnyObject] = [:]) -> NSURLRequest? {
        if let components = NSURLComponents(URL: baseURL(), resolvingAgainstBaseURL: true) {
            let request = NSMutableURLRequest()
            request.HTTPMethod = method.rawValue
            
            if method == .GET {
                components.query = API.Helper.stringFromObject(parameters, encoding: NSUTF8StringEncoding)
            } else if method == .POST {
                var contentType: String?
                var paramsData: NSData?
                if API.Helper.isMultiParams(parameters) {
                    let boundary = "Voithon-POST-boundary-\(arc4random())-\(arc4random())"
                    paramsData = API.Helper.multiDataFromObject(parameters, boundary: boundary)
                    contentType = "multipart/form-data; boundary=\(boundary)"
                } else {
                    paramsData = API.Helper.dataFromObject(parameters, encoding: NSUTF8StringEncoding)
                    contentType = "application/x-www-form-urlencoded"
                }
                
                if let params = paramsData {
                    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                    request.setValue("\(params.length)", forHTTPHeaderField: "Content-Length")
                    request.HTTPBody = params
                }
            }
            
            components.path = (components.path ?? "").stringByAppendingPathComponent(path).stringByAppendingString("/")
            request.URL = components.URL
            request.setValue(responseBodyParser().acceptHeader, forHTTPHeaderField: "Accept")
            
            return request
        } else {
            return nil
        }
    }
}

// MARK: - helper
extension API {
    class Helper {
        
        /**
        create url as String from array object.
        
        :param: object
        :param: encoding
        
        :returns: String
        */
        class func stringFromObject(object: AnyObject, encoding: NSStringEncoding) -> String {
            var pairs = [String]()
            
            if let dictionary = object as? [String: AnyObject] {
                for(key, value) in dictionary {
                    let string = (value as? String) ?? "\(value)"
                    let pair = "\(key)=\(string.escape())"
                    pairs.append(pair)
                }
            }
            
            return join("&", pairs)
        }
        
        
        /**
        create multiData as NSData from object.
        
        :param: object
        :param: boundary
        
        :returns: NSData
        */
        class func multiDataFromObject(object: AnyObject, boundary: String) -> NSData? {
            var data = NSMutableData()
            
            let prefixString = "--\(boundary)\r\n"
            let prefixData = prefixString.dataUsingEncoding(NSUTF8StringEncoding)!
            
            let seperatorString = "\r\n"
            let seperatorData = seperatorString.dataUsingEncoding(NSUTF8StringEncoding)!
            
            if let dictionary = object as? [String: AnyObject] {
                for (key, value) in dictionary {
                    
                    var valueData: NSData?
                    var valueType: String?
                    var filenameClause = ""
                    
                    if value is PostData {
                        let postData = value as! PostData
                        valueData = postData.data
                        valueType = postData.mimeType.rawValue
                        filenameClause = " filename=\"\(postData.filename)\""
                    } else {
                        let stringValue = "\(value)"
                        valueData = stringValue.dataUsingEncoding(NSUTF8StringEncoding)!
                    }
                    
                    if valueData == nil {
                        continue
                    }
                    
                    data.appendData(prefixData)
                    
                    // append content disposition
                    let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
                    let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
                    data.appendData(contentDispositionData!)
                    
                    if let type = valueType {
                        let contentTypeString = "Content-Type: \(type)\r\n"
                        let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
                        data.appendData(contentTypeData!)
                    }
                    
                    data.appendData(seperatorData)
                    data.appendData(valueData!)
                    data.appendData(seperatorData)
                }
                
                let endingString = "--\(boundary)--\r\n"
                let endingData = endingString.dataUsingEncoding(NSUTF8StringEncoding)!
                data.appendData(endingData)
            }
            
            return data
        }
        
        
        /**
        create data from object.
        
        :param: object
        :param: boundary
        
        :returns: NSData
        */
        class func dataFromObject(object: AnyObject, encoding: NSStringEncoding) -> NSData? {
            let string = stringFromObject(object, encoding: encoding)
            return string.dataUsingEncoding(encoding, allowLossyConversion: false)
        }
        
        
        /**
        create string from object.
        
        :param: object
        :param: boundary
        
        :returns: String
        */
        class func dataFromObject(object: AnyObject, encoding: String) -> String {
            var pairs = [String]()
            
            if let dictionary = object as? [String: AnyObject] {
                for (key, value) in dictionary {
                    let string = (value as? String) ?? "\(value)"
                    let pair = "\(key)=\(string.escape())"
                    pairs.append(pair)
                }
            }
            return join("&", pairs)
        }
        
        
        /**
        check parameter multi or not
        
        :param: params
        
        :returns: Bool
        */
        class func isMultiParams(params: AnyObject) -> Bool {
            
            var isMultiParams = false
            
            if let dic = params as? [String: AnyObject] {
                for (_, value) in dic {
                    if value is PostData {
                        isMultiParams = true
                        break
                    }
                }
            }
            return isMultiParams
        }
        
    }
}