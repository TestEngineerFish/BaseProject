//
//  BPChatModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

enum BPSessionType: Int {
    case normal = 0
    case system = 1
    case group  = 2
}

struct BPSessionModel: Mappable {
    var id: String       = ""
    var friendId: String = ""
    var avatarPath: String?
    var name: String     = ""
    var isTop: Bool      = false
    var type             = BPSessionType.normal
    var unreadCount: Int = 0
    var lastMsgModel: BPMessageModel?
    var lastShowTime: Date? // 最后一条时间戳消息的时间，用于判断发送消息是否需要显示时间
    var draftText: String?  // 草稿文案
    var draftTime: Date?    // 草稿时间

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
