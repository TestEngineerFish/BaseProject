//
//  BPChatRoomToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPChatRoomToolsViewDelegate: NSObjectProtocol {
    func clickSwitchAction()
    func clickEmojiAction()
    func clickMoreAction()
    func recordingAction()
    func sendMessage(text: String)
}

class BPChatRoomToolsView: BPView, UITextFieldDelegate {

    weak var delegate: BPChatRoomToolsViewDelegate?

    private var switchButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.record.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(30))
        return button
    }()
    private var recordButton: BPButton = {
        let button = BPButton(.normal, frame: .zero, animation: false)
        button.backgroundColor    = .randomColor()
        button.layer.cornerRadius = 5
        button.setTitle("按住 说话", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.DINAlternateBold(ofSize: AdaptSize(18))
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
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(30))
        return button
    }()
    private var moreButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.more.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(30))
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
            make.height.equalTo(AdaptSize(90))
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
        if sender.currentTitle == IconFont.record.rawValue {
            sender.setTitle(IconFont.keyboard.rawValue, for: .normal)
            self.recordButton.isHidden = false
        } else {
            sender.setTitle(IconFont.record.rawValue, for: .normal)
            self.recordButton.isHidden = true
        }
        self.delegate?.clickSwitchAction()
    }

    @objc private func emojiAction(sender: BPButton) {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            if self.transform.ty < 0 {
                self.transform = .identity
            } else {
                self.transform = CGAffineTransform(translationX: 0, y: -self.moreView.height)
            }
        } completion: { (finished) in
            if finished {
                self.isUserInteractionEnabled = true
                self.delegate?.clickEmojiAction()
            }
        }
    }

    @objc private func moreAction(sender: BPButton) {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            if self.transform.ty < 0 {
                self.transform = .identity
            } else {
                self.transform = CGAffineTransform(translationX: 0, y: -self.moreView.height)
            }
        } completion: { (finished) in
            if finished {
                self.isUserInteractionEnabled = true
                self.delegate?.clickMoreAction()
            }
        }
    }

    @objc private func recordingAction(sender: BPButton) {
        self.delegate?.recordingAction()
    }


    // MARK: ==== UITextFieldDelegate ====

}
