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

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
