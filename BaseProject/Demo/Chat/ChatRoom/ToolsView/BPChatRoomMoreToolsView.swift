//
//  BPChatRoomMoreToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPChatRoomMoreToolsViewDelegate: NSObjectProtocol {
    func selectedEmoji(model: BPEmojiModel)
}
/// 工具栏底部更多内容视图
class BPChatRoomMoreToolsView: BPView, BPEmojiToolViewDelegate {

    weak var delegate: BPChatRoomMoreToolsViewDelegate?

    private var emojiView: BPEmojiToolView = {
        let view = BPEmojiToolView()
        view.layer.opacity   = .zero
        return view
    }()
    private var photoView: BPView = {
        let view = BPView()
        view.layer.opacity   = .zero
        view.backgroundColor = .blue1
        return view
    }()
    private var recordView: BPView = {
        let view = BPView()
        view.layer.opacity   = .zero
        view.backgroundColor = .gray1
        return view
    }()
    private var moreView: BPView = {
        let view = BPView()
        view.layer.opacity   = .zero
        view.backgroundColor = .black1
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
        self.addSubview(emojiView)
        self.addSubview(photoView)
        self.addSubview(recordView)
        self.addSubview(moreView)
        emojiView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        photoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        recordView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        moreView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .clear
        self.emojiView.delegate = self
    }
    private var currentShowView: BPView? {
        willSet {
            // 先隐藏之前显示的视图
            if let lastView = self.currentShowView {
                self.hideContentView(content: lastView)
            }
            // 如果有选中，则显示新视图
            if let newView = newValue {
                self.showContentView(content: newView)
            }
        }
    }
    enum BPChatRoomMoreViewType: Int {
        case emoji
        case photo
        case record
        case moreView
    }
    // MARK: ==== Event ====
    func showView(type: BPChatRoomMoreViewType) {
        switch type {
        case .emoji:
            self.currentShowView = self.emojiView
        case .photo:
            self.currentShowView = self.photoView
        case .record:
            self.currentShowView = self.recordView
        case .moreView:
            self.currentShowView = self.moreView
        }
    }

    func hideView() {
        self.currentShowView = nil
    }

    private func showContentView(content view: BPView) {
        UIView.animate(withDuration: 0.15) {
            view.layer.opacity = 1.0
        } completion: { [weak self] (finished) in
            self?.bringSubviewToFront(view)
        }
    }

    private func hideContentView(content view: BPView) {
        UIView.animate(withDuration: 0.15) {
            view.layer.opacity = .zero
        }
    }

    // MARK: ==== BPEmojiToolViewDelegate ====
    func selectedEmoji(model: BPEmojiModel) {
        self.delegate?.selectedEmoji(model: model)
    }
}
