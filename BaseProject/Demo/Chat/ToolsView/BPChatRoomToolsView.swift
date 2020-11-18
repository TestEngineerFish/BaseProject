//
//  BPChatRoomToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPChatRoomToolsViewDelegate: NSObjectProtocol {
    func clickEmojiAction(transform:CGAffineTransform)
    func clickPhotoAction()
    func clickCameraAction()
    func clickRecordAction(transform:CGAffineTransform)
    func clickGiftAction(transform:CGAffineTransform)
    func clickMoreAction(transform:CGAffineTransform)
    func recordingAction()
    func sendMessage(text: String)
}

/// 工具栏视图
class BPChatRoomToolsView: BPView, UITextFieldDelegate, BPChatRoomMoreToolsViewDelegate {

    private let itemSize = CGSize(width: AdaptSize(35), height: AdaptSize(35))
    var moreViewHeight: CGFloat = AdaptSize(180)
    weak var delegate: BPChatRoomToolsViewDelegate?

    /// 当前选择的安妮句
    var currentSelectedButton: BPButton? {
        willSet {
            guard let _ = newValue, let button = currentSelectedButton else {
                return
            }
            // 更改上一个按钮的选中状态
            self.clickButton(sender: button)
        }
    }

    var textFieldView: UITextField = {
        let leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: AdaptSize(10), height: AdaptSize(10)))
        let textFieldView = UITextField()
        textFieldView.leftView           = leftView
        textFieldView.leftViewMode       = .always
        textFieldView.rightViewMode      = .always
        textFieldView.layer.cornerRadius = 5
        textFieldView.backgroundColor    = .white
        textFieldView.returnKeyType      = .send
        textFieldView.textColor          = .black1
        textFieldView.font               = UIFont.regularFont(ofSize: 14)
        textFieldView.enablesReturnKeyAutomatically = true // 无文字不可点
        textFieldView.placeholder        = "输入新消息"
        textFieldView.layer.borderWidth  = 1
        textFieldView.layer.borderColor  = UIColor.gray3.cgColor
        return textFieldView
    }()
    private var emojiButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.emoji.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(20))
        button.titleEdgeInsets  = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: AdaptSize(5))
        return button
    }()
    private var phoneButton: BPButton = {
        let button = BPButton()
        button.setTitle("电话", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    private var photoButton: BPButton = {
        let button = BPButton()
        button.setTitle("照片", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    private var cameraButton: BPButton = {
        let button = BPButton()
        button.setTitle("拍照", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    private var recordButton: BPButton = {
        let button = BPButton()
        button.setTitle("录音", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    private var giftButton: BPButton = {
        let button = BPButton()
        button.setTitle("礼物", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    private var moreButton: BPButton = {
        let button = BPButton()
        button.setTitle("更多", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .selected)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()

    private var moreView = BPChatRoomMoreToolsView()

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
        phoneButton.size  = itemSize
        photoButton.size  = itemSize
        cameraButton.size = itemSize
        recordButton.size = itemSize
        giftButton.size   = itemSize
        moreButton.size   = itemSize
        self.addSubview(textFieldView)
        self.textFieldView.rightView = emojiButton
        let stackView = UIStackView(arrangedSubviews: [phoneButton, photoButton, cameraButton, recordButton, giftButton, moreButton])
        stackView.alignment    = .center
        stackView.distribution = .equalSpacing
        self.addSubview(stackView)
        self.addSubview(moreView)
        textFieldView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview().offset(AdaptSize(10))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(itemSize.height)
        }
        emojiButton.frame = CGRect(origin: .zero, size: itemSize)
        stackView.snp.makeConstraints { (make) in
            make.left.right.equalTo(textFieldView)
            make.top.equalTo(textFieldView.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(itemSize.height)
        }
        moreView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(moreViewHeight)
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }
        textFieldView.layer.cornerRadius = itemSize.height / 2
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor        = .gray2
        self.textFieldView.delegate = self
        self.moreView.delegate      = self
        self.emojiButton.addTarget(self, action: #selector(clickEmojiButton(sender:)), for: .touchUpInside)
        self.phoneButton.addTarget(self, action: #selector(clickPhoneButton(sender:)), for: .touchUpInside)
        self.photoButton.addTarget(self, action: #selector(clickPhotoButton(sender:)), for: .touchUpInside)
        self.cameraButton.addTarget(self, action: #selector(clickCameraButton(sender:)), for: .touchUpInside)
        self.recordButton.addTarget(self, action: #selector(clickRecordButton(sender:)), for: .touchUpInside)
        self.giftButton.addTarget(self, action: #selector(clickGiftButton(sender:)), for: .touchUpInside)
        self.moreButton.addTarget(self, action: #selector(clickMoreButton(sender:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc private func clickEmojiButton(sender: BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func clickPhoneButton(sender: BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func clickPhotoButton(sender: BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func clickCameraButton(sender: BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func clickRecordButton(sender: BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func clickGiftButton(sender: BPButton) {
        self.clickButton(sender: sender)
    }
    @objc private func clickMoreButton(sender: BPButton) {
        self.clickButton(sender: sender)
    }

    private func clickButton(sender: BPButton) {
        self.textFieldView.resignFirstResponder()
        switch sender {
        case emojiButton:
            // 点击表情按钮
            self.switchButtonState(sender: sender)
            if sender.isSelected {
                self.moreView.showView(type: .emoji)
                self.delegate?.clickEmojiAction(transform: CGAffineTransform(translationX: 0, y: -self.moreView.height))
            } else {
                self.moreView.hideView()
                self.delegate?.clickEmojiAction(transform: .identity)
            }
        case phoneButton:
            // 点击电话按钮
            BPActionSheet().addItem(title: "视频聊天") {
                kWindow.makeToast("等待完善中……")
            }.addItem(title: "语音聊天") {
                kWindow.makeToast("说了完善中……")
            }.show()
        case photoButton:
            // 点击相册按钮
            self.delegate?.clickPhotoAction()
        case cameraButton:
            // 显示拍照按钮
            BPLog("显示相机")
            self.delegate?.clickCameraAction()
        case recordButton:
            // 点击录音按钮
            self.switchButtonState(sender: sender)
            if sender.isSelected {
                self.moreView.showView(type: .record)
                self.delegate?.clickRecordAction(transform: CGAffineTransform(translationX: 0, y: -self.moreView.height))
            } else {
                self.moreView.hideView()
                self.delegate?.clickRecordAction(transform: .identity)
            }
        case giftButton:
            // 点击礼物按钮
            self.switchButtonState(sender: sender)
            if sender.isSelected {
                self.delegate?.clickGiftAction(transform: CGAffineTransform(translationX: 0, y: -self.moreView.height))
            } else {
                self.delegate?.clickGiftAction(transform: .identity)
            }
        case moreButton:
            // 点击更多按钮
            self.switchButtonState(sender: sender)
            if sender.isSelected {
                self.moreView.showView(type: .moreView)
                self.delegate?.clickMoreAction(transform: CGAffineTransform(translationX: 0, y: -self.moreView.height))
            } else {
                self.moreView.hideView()
                self.delegate?.clickMoreAction(transform: .identity)
            }
        default:
            break
        }
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

    // MARK: ==== UITextFieldDelegate ====
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let currentButton = self.currentSelectedButton {
            self.switchButtonState(sender: currentButton)
            self.moreView.hideView()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        self.delegate?.sendMessage(text: text)
        textField.text = ""
        return true
    }

    // MARK: === BPChatRoomMoreToolsViewDelegate ====
    func selectedEmoji(model: BPEmojiModel) {
        self.textFieldView.text = (self.textFieldView.text ?? "") + (model.name ?? "")
    }

}
