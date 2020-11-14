//
//  BPChatRoomTextMessageCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

/// 文本消息
class BPChatRoomTextMessageCell: BPChatRoomBaseMessageCell {
    private var textLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(textLabel)
        self.textLabel.snp.remakeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(10))
            make.bottom.right.equalToSuperview().offset(AdaptSize(-10))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.layer.cornerRadius = 5
    }

    override func bindData() {
        super.bindData()
        self.textLabel.text = self.messageModel.text
    }
    
}
