//
//  Models.swift
//  ServerAPIDemo
//
//  Created by 唐韬 on 2017/11/12.
//  Copyright © 2017年 Demo. All rights reserved.
//

import Foundation
import ObjectMapper

struct Weather: Mappable {
    
    var timezone    : String?
    var summary     : String?
    
    init?(map: Map) {
        guard let _ = map["timezone"].currentValue else { return nil }
        guard let _ = map["currently.summary"].currentValue else { return nil }
    }
    
    mutating func mapping(map: Map) {
        timezone    <- map["timezone"]
        summary     <- map["currently.summary"]
    }
}



struct AnotherModel: Mappable {
    
    var value1    : String?
    var value2     : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
    }
}


