//
//  BPChatRoomMessageCellFactory.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

/// 消息子视图工厂
struct BPChatRoomMessageBubbleFactory {

    static func buildView(message model: BPMessageModel) -> BPChatRoomBaseMessageBubble {
        switch model.type {
        case .text:
            return BPChatRoomTextMessageBubble(model: model)
        case .image:
            return BPChatRoomImageMessageBubble(model: model)
        default:
            return BPChatRoomBaseMessageBubble(model: model)
        }
    }
}
