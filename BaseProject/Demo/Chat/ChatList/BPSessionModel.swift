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
    /// 会话类型
    var type             = BPSessionType.normal
    /// 是否置顶
    var isTop: Bool      = false
    /// 好友ID
    var friendId: String = ""
    /// 好友名称
    var friendName: String = ""
    /// 好友头像地址
    var friendAvatarPath: String?
    /// 最后一条消息内容
    var lastMessage: String?
    /// 最后一条消息时间
    var lastMessageTime: Date?
    /// 最后一条消息类型
    var lastMessageType: BPMessageType = .text
    /// 最后一条消息状态
    var lastMessageStatus: BPMessageStatus = .success
    /// 最后一条时间戳消息的时间，用于判断发送消息是否需要显示时间
    var lastTimestamp: Date?
    /// 未读消息数
    var unreadCount: Int = 0
    /// 创建时间
    var createTime: Date?

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
