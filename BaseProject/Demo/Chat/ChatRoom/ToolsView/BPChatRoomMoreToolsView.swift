//
//  BPChatRoomMoreToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatRoomMoreToolsView: BPView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .randomColor()
    }
}
