//
//  History.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import Foundation

class History {
    
    let run_id: String
    let name: String
    let target: String
    let position: String
    let status: String
    let latitude: String
    let longitude: String
    let date: String
    let finish: String
    let location: String
    
    
    init(run_id: String, name: String, target: String, position: String, status: String,latitude: String, longitude: String, date: String, finish: String, location: String) {
        self.run_id = run_id
        self.name = name
        self.target = target
        self.position = position
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.finish = finish
        self.location = location
    }
    
}