//
//  BPPubilshToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/25.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPPubilshToolsViewDelegate: NSObjectProtocol {
    func clickRecordAction(content height:CGFloat)
    func clickCameraAction()
    func clickPhotoAction()
    func clickEmojiAction(content height:CGFloat)
    func clickRemindAction()
}

class BPPubilshToolsView: BPView {
    /// 工具栏默认高度
    let toolBarHeight     = AdaptSize(40)
    /// 工具视图默认高度
    private let contentViewHeight = AdaptSize(360)
    var delegate: BPPubilshToolsViewDelegate?

    /// 当前选择的选项
    private var currentSelectedButton: BPButton? {
        willSet {
            guard let _ = newValue, let button = currentSelectedButton else {
                return
            }
            // 更改上一个按钮的选中状态
            self.clickButton(sender: button)
        }
    }

    private var recordButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.record.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(20))
        return button
    }()
    private var cameraButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.camera.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(25))
        return button
    }()
    private var photoButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.photo.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(25))
        return button
    }()
    private var emojiButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.emoji.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(20))
        return button
    }()
    private var remindButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.remind.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(20))
        return button
    }()
    private var contentView = BPPublishToolsMoreView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(recordButton)
        self.addSubview(cameraButton)
        self.addSubview(photoButton)
        self.addSubview(emojiButton)
        self.addSubview(remindButton)
        self.addSubview(contentView)
        recordButton.sizeToFit()
        recordButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(5))
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.size.equalTo(recordButton.size)
        }
        cameraButton.sizeToFit()
        cameraButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(recordButton)
            make.left.equalTo(recordButton.snp.right).offset(AdaptSize(15))
            make.size.equalTo(cameraButton.size)
        }
        photoButton.sizeToFit()
        photoButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(recordButton)
            make.left.equalTo(cameraButton.snp.right).offset(AdaptSize(15))
            make.size.equalTo(photoButton.size)
        }
        emojiButton.sizeToFit()
        emojiButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(recordButton)
            make.left.equalTo(photoButton.snp.right).offset(AdaptSize(15))
            make.size.equalTo(emojiButton.size)
        }
        remindButton.sizeToFit()
        remindButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(recordButton)
            make.left.equalTo(emojiButton.snp.right).offset(AdaptSize(15))
            make.size.equalTo(remindButton.size)
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(toolBarHeight)
        }
        self.layer.cornerRadius = AdaptSize(10)
        self.layer.borderWidth  = 0.9
        self.layer.borderColor  = UIColor.gray0.cgColor
    }

    override func bindProperty() {
        super.bindProperty()
        self.recordButton.addTarget(self, action: #selector(self.recordAction(sender:)), for: .touchUpInside)
        self.cameraButton.addTarget(self, action: #selector(self.cameraAction(sender:)), for: .touchUpInside)
        self.photoButton.addTarget(self, action: #selector(self.photoAction(sender:)), for: .touchUpInside)
        self.emojiButton.addTarget(self, action: #selector(self.emojiAction(sender:)), for: .touchUpInside)
        self.remindButton.addTarget(self, action: #selector(self.remindAction(sender:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc private func recordAction(sender:BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func cameraAction(sender:BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func photoAction(sender:BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func emojiAction(sender:BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func remindAction(sender:BPButton) {
        self.clickButton(sender: sender)
    }

    /// 恢复默认状态
    func resetContentView() {
        guard let button = self.currentSelectedButton else { return }
        self.clickButton(sender: button)
    }

    // 设置按钮的选中状态
    private func switchButtonState(sender: BPButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.currentSelectedButton = sender
        } else {
            self.currentSelectedButton = nil
        }
    }

    private func clickButton(sender: BPButton) {
        let hideHeight = toolBarHeight + kSafeBottomMargin
        let showHeight = hideHeight + contentViewHeight
        switch sender {
        case recordButton:
            self.switchButtonState(sender: sender)
            if sender.isSelected {
                self.contentView.showView(type: .record)
                self.delegate?.clickRecordAction(content: showHeight)
            } else {
                self.contentView.hideView()
                self.delegate?.clickEmojiAction(content: hideHeight)
            }
        case cameraButton:
            self.delegate?.clickCameraAction()
        case photoButton:
            self.delegate?.clickPhotoAction()
        case emojiButton:
            self.switchButtonState(sender: sender)
            if sender.isSelected {
                self.contentView.showView(type: .emoji)
                self.delegate?.clickEmojiAction(content: showHeight)
            } else {
                self.contentView.hideView()
                self.delegate?.clickEmojiAction(content: hideHeight)
            }
        case remindButton:
            self.delegate?.clickRemindAction()
        default:
            break
        }
    }
}
