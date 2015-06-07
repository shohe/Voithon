//
//  PostData.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import Foundation
import UIKit

enum MimeType: String {
    case ImageJpeg = "image/jpeg"
    case ImagePng = "image/png"
}

class PostData {
    
    let data: NSData
    let mimeType: MimeType
    let filename: String
    
    
    init(data: NSData, mimeType: MimeType) {
        self.data = data
        self.mimeType = mimeType
        
        let dateFormatter = NSDateFormatter()
        let filename: String
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        switch mimeType {
        case .ImageJpeg:
            dateFormatter.dateFormat = "yyyyMMddHHmmssSS"
            filename = dateFormatter.stringFromDate(NSDate()) + ".jpg"
        case .ImagePng:
            dateFormatter.dateFormat = "yyyyMMddHHmmssSS"
            filename = dateFormatter.stringFromDate(NSDate()) + ".png"
        }
        self.filename = filename
    }
    
    
    init(imageName: String) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        
        var data = NSData()
        var mimeType = MimeType.ImageJpeg
        var filename = ""
        
        if imageName.pathExtension == "jpg" {
            data = UIImageJPEGRepresentation(UIImage(named: imageName), 1)
            mimeType = MimeType.ImageJpeg
            dateFormatter.dateFormat = "yyyyMMddHHmmssSS"
            filename = dateFormatter.stringFromDate(NSDate()) + ".jpg"
        } else if imageName.pathExtension == "png" {
            data = UIImagePNGRepresentation(UIImage(named: imageName))
            mimeType = MimeType.ImagePng
            dateFormatter.dateFormat = "yyyyMMddHHmmssSS"
            filename = dateFormatter.stringFromDate(NSDate()) + ".png"
        }
        
        self.data = data
        self.mimeType = mimeType
        self.filename = filename
    }
    
}

