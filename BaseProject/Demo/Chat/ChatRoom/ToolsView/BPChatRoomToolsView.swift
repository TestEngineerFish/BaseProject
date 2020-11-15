//
//  BPChatRoomToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPChatRoomToolsViewDelegate: NSObjectProtocol {
    func clickSwitchAction(transform:CGAffineTransform)
    func clickEmojiAction(transform:CGAffineTransform)
    func clickMoreAction(transform:CGAffineTransform)
    func recordingAction()
    func sendMessage(text: String)
}

class BPChatRoomToolsView: BPView, UITextFieldDelegate {

    enum ToolsViewStatus: Int {
        /// 默认状态
        case normal
        /// 显示软键盘（编辑中）
        case showKeyboard
        /// 显示录音按钮
        case showRecordButton
        /// 录音中
        case recording
        /// 显示表情视图
        case showEmojiView
        /// 显示更多功能视图
        case showMoreView
    }

    var moreViewHeight: CGFloat = AdaptSize(120)
    weak var delegate: BPChatRoomToolsViewDelegate?

    var status: ToolsViewStatus = ToolsViewStatus.normal {
        willSet {
            switch newValue {
            case .normal:
                self.moreView.isHidden     = true
                self.recordButton.isHidden = true
                self.switchButton.setTitle(IconFont.record.rawValue, for: .normal)
            case .showKeyboard:
                self.moreView.isHidden     = true
                self.recordButton.isHidden = true
                self.switchButton.setTitle(IconFont.record.rawValue, for: .normal)
            case .showRecordButton:
                self.moreView.isHidden     = true
                self.recordButton.isHidden = false
                self.switchButton.setTitle(IconFont.keyboard.rawValue, for: .normal)
            case .showEmojiView:
                self.moreView.isHidden     = false
                self.recordButton.isHidden = true
            case .showMoreView:
                self.moreView.isHidden     = false
                self.recordButton.isHidden = true
            default:
                break
            }
        }
    }

    private var switchButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.record.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(25))
        return button
    }()
    private var recordButton: BPButton = {
        let button = BPButton(.normal, frame: .zero, animation: false)
        button.backgroundColor    = .randomColor()
        button.layer.cornerRadius = 5
        button.setTitle("按住 说话", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.DINAlternateBold(ofSize: AdaptSize(16))
        return button
    }()
    private var textFieldView: UITextField = {
        let textFieldView = UITextField()
        textFieldView.leftView = UIView()
        textFieldView.rightView = UIView()
        textFieldView.layer.cornerRadius = 5
        textFieldView.backgroundColor = .white
        return textFieldView
    }()
    private var emojiButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.emoji.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(25))
        return button
    }()
    private var moreButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.more.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(32))
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
        self.addSubview(switchButton)
        self.addSubview(textFieldView)
        self.addSubview(recordButton)
        self.addSubview(emojiButton)
        self.addSubview(moreButton)
        self.addSubview(moreView)
        switchButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(10))
            make.size.equalTo(CGSize(width: AdaptSize(35), height: AdaptSize(35)))
        }
        textFieldView.snp.makeConstraints { (make) in
            make.left.equalTo(switchButton.snp.right)
            make.centerY.equalTo(switchButton)
            make.right.equalTo(emojiButton.snp.left)
            make.height.equalTo(AdaptSize(35))
        }
        recordButton.snp.makeConstraints { (make) in
            make.edges.equalTo(textFieldView)
        }
        emojiButton.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(switchButton)
            make.right.equalTo(moreButton.snp.left)
        }
        moreButton.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(switchButton)
            make.right.equalToSuperview()
        }
        moreView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(textFieldView.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(moreViewHeight)
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor        = .gray5
        self.recordButton.isHidden  = true
        self.moreView.isHidden      = true
        self.textFieldView.delegate = self
        self.switchButton.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
        self.emojiButton.addTarget(self, action: #selector(emojiAction(sender:)), for: .touchUpInside)
        self.moreButton.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc private func switchAction(sender: BPButton) {
        if self.status != .showRecordButton && self.status != .recording {
            // 显示录音按钮，并位移到底部
            self.status = .showRecordButton
            self.delegate?.clickSwitchAction(transform: .identity)
        } else {
            // 显示编辑状态，并显示软键盘
            self.status = .showKeyboard
            self.delegate?.clickSwitchAction(transform: CGAffineTransform(translationX: 0, y: -self.moreView.height))
        }
    }

    @objc private func emojiAction(sender: BPButton) {
        if self.status != .showEmojiView {
            // 显示Emoji表情列表，并位移
            self.status = .showEmojiView
            self.delegate?.clickEmojiAction(transform: CGAffineTransform(translationX: 0, y: -self.moreView.height))
        } else {
            // 显示编辑状态，并显示软键盘
            self.status = .normal
            self.delegate?.clickEmojiAction(transform: .identity)
        }
    }

    @objc private func moreAction(sender: BPButton) {
        if self.status != .showMoreView {
            // 显示Emoji表情列表，并位移
            self.status = .showMoreView
            self.delegate?.clickMoreAction(transform: CGAffineTransform(translationX: 0, y: -self.moreView.height))
        } else {
            // 显示编辑状态，并显示软键盘
            self.status = .normal
            self.delegate?.clickMoreAction(transform: .identity)
        }
    }

    @objc private func recordingAction(sender: BPButton) {
        self.delegate?.recordingAction()
    }

    // MARK: ==== UITextFieldDelegate ====

}
