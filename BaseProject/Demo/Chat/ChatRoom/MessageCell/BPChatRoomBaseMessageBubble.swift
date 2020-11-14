//
//  BPChatRoomBaseMessageCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatRoomBaseMessageBubble: BPView {
    var messageModel: BPMessageModel

    init(model: BPMessageModel) {
        self.messageModel = model
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
