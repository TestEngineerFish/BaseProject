//
//  BPMessageModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

enum BPMessageType: Int {
    case text   = 0
    case image  = 1
    case system = 2
}

enum BPMessageFromType: Int {
    case me
    case friend
    case system
    case local// 时间戳等
}

enum BPMessageStatus: Int {
    case success
    case fail
    case sending
}

struct BPMessageModel: Mappable {
    var id: String          = ""
    var sessionId           = ""
    var text: String        = ""
    var time: Date          = Date()
    var type: BPMessageType = .text
    var fromType: BPMessageFromType = .me
    var mediaModel: BPMediaModel? // 多媒体资源
    var status: BPMessageStatus = .success
    var unread: Bool        = true

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
