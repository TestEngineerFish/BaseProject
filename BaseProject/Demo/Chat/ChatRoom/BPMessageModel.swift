//
//  BPMessageModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

enum BPMessageType: Int {
    case text
    case image
    case system
}

enum BPMessageFromType: Int {
    case me
    case friend
    case system
    case local// 时间戳等
}

struct BPMessageModel: Mappable {
    var id: Int             = 0
    var text: String        = ""
    var time: Double        = .zero
    var type: BPMessageType = .text
    var fromType: BPMessageFromType = .me
    var mediaModel: BPMediaModel? // 多媒体资源

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
