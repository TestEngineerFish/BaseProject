//
//  BPChatRoomBaseMessageCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPChatRoomBubbleDelegate: NSObjectProtocol {
    /// 点击气泡
    func clickBubble()
    /// 撤回消息
    func withDrawMessage()
}

class BPChatRoomBaseMessageBubble: BPView {

    var messageModel: BPMessageModel
    weak var delegate: BPChatRoomBubbleDelegate?

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

    override func bindProperty() {
        super.bindProperty()
        self.isUserInteractionEnabled = true
        // 设置手势事件
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.clickBubbleAction))
        self.addGestureRecognizer(tapAction)

        let longPressAction = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressBubbleAction(sender:)))
        self.addGestureRecognizer(longPressAction)
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    // MARK: ==== Event ====

    /// 点击bubble区域事件
    @objc func clickBubbleAction() {
        self.delegate?.clickBubble()
    }

    /// 长按Bubble区域事件
    @objc func longPressBubbleAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let _superView = self.superview else {
                return
            }
            self.becomeFirstResponder()
            let menuController = UIMenuController.shared
            menuController.isMenuVisible = true
            let item = UIMenuItem(title: "撤回", action: #selector(self.withDrawAction))
            menuController.menuItems = [item]
            menuController.setTargetRect(self.frame, in: _superView)
            menuController.setMenuVisible(true, animated: true)
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // 仅文本支持复制
        if action == #selector(UIResponderStandardEditActions.copy(_:)) && self.messageModel.type == .text || action == #selector(self.withDrawAction) {
            return true
        } else {
            return false
        }
    }

    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = self.messageModel.text
    }

    @objc private func withDrawAction() {
        self.delegate?.withDrawMessage()
    }
}
