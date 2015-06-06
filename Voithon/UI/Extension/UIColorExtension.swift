//
//  UIColorExtension.swift
//  Voithon
//
//  Created by SHOHE on 6/6/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(#r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    class func VoithonRed() -> UIColor {
        return UIColor.rgb(r: 159, g: 32, b: 36, alpha: 1.0)
    }
    class func VoithonRedDark() -> UIColor {
        return UIColor.rgb(r: 81, g: 17, b: 19, alpha: 1.0)
    }
}