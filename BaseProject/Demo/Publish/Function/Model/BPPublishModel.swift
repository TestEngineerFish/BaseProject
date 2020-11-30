//
//  BPPublishModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/30.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

struct BPPublishModel: Mappable {

    var limitType: BPPublishLimitType = .all

    init() {}
    init?(map: Map) {}
    mutating func mapping(map: Map) {}
}
