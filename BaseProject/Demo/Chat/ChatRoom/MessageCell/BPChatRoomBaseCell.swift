//
//  BPChatRoomBaseCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/21.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPChatRoomCellDelegate: NSObjectProtocol {
    func clickBubble(model: BPMessageModel, indexPath: IndexPath)
    func drawAction(model: BPMessageModel, indexPath: IndexPath)
    func reeditAction(model: BPMessageModel, indexPath: IndexPath)
}

class BPChatRoomBaseCell: UITableViewCell {
    let topSpace    = AdaptSize(10)
    let bottomSpace = AdaptSize(10)
    var messageModel: BPMessageModel?
    var indexPath: IndexPath?
    weak var delegate: BPChatRoomCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubviews() {}

    func bindProperty() {
        self.selectionStyle  = .none
        self.backgroundColor = .clear
    }

    func bindData(message model: BPMessageModel, indexPath: IndexPath) {
        self.messageModel = model
        self.indexPath    = indexPath
    }
}
