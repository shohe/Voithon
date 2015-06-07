//
//  ResponceBodyParser.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import Foundation

enum ResponceBodyParser {
    case Json
    case URL(encoding: NSStringEncoding)
    
    var acceptHeader: String {
        switch self {
        case .Json:
            return "application/json"
        case .URL:
            return "application/x-www-form-urlencoded"
        }
    }
    
    func parseData(data: NSData) -> AnyObject? {
        switch self {
        case .Json:
            return JSON(data: data)
        case .URL:
            return nil
        }
    }
}