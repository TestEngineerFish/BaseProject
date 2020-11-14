//
//  BPChatRoomMessageCellFactory.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

/// 消息子视图工厂
struct BPChatRoomMessageCellFactory {

    static func buildView(message model: BPMessageModel) -> BPChatRoomBaseMessageCell {
        switch model.type {
        case .text:
            return BPChatRoomTextMessageCell(model: model)
        case .image:
            return BPChatRoomImageMessageCell(model: model)
        default:
            return BPChatRoomBaseMessageCell(model: model)
        }
    }
}
