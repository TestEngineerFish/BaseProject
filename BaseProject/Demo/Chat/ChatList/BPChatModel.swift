//
//  BPChatModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

enum BPChatType: Int {
    case normal
    case group
}

struct BPChatModel: Mappable {
    var id: Int          = 0
    var avatarPath: String?
    var name: String     = ""
    var lastMsg: String  = ""
    var lastTime: String = ""
    var isTop: Bool      = false
    var type: BPChatType = .normal

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
