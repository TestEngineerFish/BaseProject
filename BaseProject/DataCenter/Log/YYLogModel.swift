//
//  YYLogModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import ObjectMapper

struct YYLoggerModel: Mappable{
    
    var createTime: String?
    var logContent: Any?
    var loggerCommandType: YYLoggerCommandType = .other
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        createTime <- map["createTime"]
        logContent <- map["logContent"]
    }
}

