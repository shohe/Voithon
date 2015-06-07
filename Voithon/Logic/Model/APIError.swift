//
//  APIError.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import Foundation

let ServerErrorMessageKey   = "resultMessage"
let ServerResultCodeKey     = "resultCode"
let ServerResultSuccessCode = 0

class APIError {
    
    let errorMessage: String
    let errorCode: Int
    
    var isError: Bool {
        return self.errorCode != ServerResultSuccessCode
    }
    
    init(message: String, code: Int) {
        self.errorMessage = message
        self.errorCode = code
    }
    
    init(json: JSON) {
        if let error = json.asError {
            self.errorMessage = error.description
            self.errorCode = error.code
        } else {
            self.errorMessage = json[ServerErrorMessageKey].asString ?? ""
            self.errorCode = json[ServerResultCodeKey].asInt ?? ServerResultSuccessCode
        }
    }
}