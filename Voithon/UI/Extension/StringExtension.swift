//
//  StringExtension.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import Foundation

extension String {
    
    func escape() -> String {
        return CFURLCreateStringByAddingPercentEscapes(nil, self, nil, "!*'();:@&=+$/?%#[]", CFStringBuiltInEncodings.UTF8.rawValue) as! String
    }
    
    func unescape() -> String {
        return CFURLCreateStringByReplacingPercentEscapes(nil, self, nil) as! String
    }
    
}