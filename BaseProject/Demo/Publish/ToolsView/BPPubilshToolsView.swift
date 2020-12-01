//
//  BPPubilshToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/25.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPPubilshToolsViewDelegate: NSObjectProtocol {
    func clickRecordAction()
    func clickCameraAction()
    func clickPhotoAction()
    func clickEmojiAction()
    func clickRemindAction()
}

class BPPubilshToolsView: BPView {

    let toolBarHeight = AdaptSize(40)
    var delegate: BPPubilshToolsViewDelegate?

    private var recordButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.record.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(20))
        return button
    }()
    private var cameraButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.camera.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(25))
        return button
    }()
    private var photoButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.photo.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(25))
        return button
    }()
    private var emojiButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.emoji.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(20))
        return button
    }()
    private var remindButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.remind.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(20))
        return button
    }()
    private var contentView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.randomColor()
        return view
    }()

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
        self.recordButton.addTarget(self, action: #selector(self.recordAction), for: .touchUpInside)
        self.cameraButton.addTarget(self, action: #selector(self.cameraAction), for: .touchUpInside)
        self.photoButton.addTarget(self, action: #selector(self.photoAction), for: .touchUpInside)
        self.emojiButton.addTarget(self, action: #selector(self.emojiAction), for: .touchUpInside)
        self.remindButton.addTarget(self, action: #selector(self.remindAction), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc private func recordAction() {
        self.delegate?.clickRecordAction()
    }
    @objc private func cameraAction() {
        self.delegate?.clickCameraAction()
    }
    @objc private func photoAction() {
        self.delegate?.clickPhotoAction()
    }
    @objc private func emojiAction() {
        self.delegate?.clickEmojiAction()
    }
    @objc private func remindAction() {
        self.delegate?.clickRemindAction()
    }
}
