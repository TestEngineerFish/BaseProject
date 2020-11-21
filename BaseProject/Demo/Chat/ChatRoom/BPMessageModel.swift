//
//  BPMessageModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

enum BPMessageType: Int {
    /// 文本
    case text     = 0
    /// 图片
    case image    = 1
    /// 时间
    case time     = 2
    /// 撤回
    case withDraw = 3
    /// 草稿
    case draft    = 99

    /// 获取显示的CellID
    var cellID: String {
        get {
            switch self {
            case .text, .image:
                return "kBPChatRoomCell"
            case .time:
                return "kBPChatRoomLocalTimeCell"
            case .withDraw:
                return "kBPChatRoomWithDrawCell"
            default:
                return ""
            }
        }
    }
}

enum BPMessageFromType: Int {
    /// 自己
    case me
    /// 对方
    case friend
    /// 系统
    case system
    /// 本地（时间戳等）
    case local
}

enum BPMessageStatus: Int {
    /// 发送成功
    case success
    /// 发送失败
    case fail
    /// 发送中…
    case sending
    /// 编辑中…
    case editing
}

struct BPMessageModel: Mappable {
    var id: String          = ""
    var sessionId           = ""
    var text: String        = ""
    var time: Date          = Date(timeIntervalSinceNow: 0)
    var type: BPMessageType = .text
    var fromType: BPMessageFromType = .me
    var mediaModel: BPMediaModel? // 多媒体资源
    var status: BPMessageStatus = .success
    var unread: Bool        = true

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
