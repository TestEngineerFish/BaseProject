//
//  BPChatRoomMoreToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatRoomMoreToolsView: BPView {
    private var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.opacity   = .zero
        view.backgroundColor = .randomColor()
        return view
    }()
    private var photoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.opacity   = .zero
        view.backgroundColor = .randomColor()
        return view
    }()
    private var recordView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.opacity   = .zero
        view.backgroundColor = .randomColor()
        return view
    }()
    private var moreView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.opacity   = .zero
        view.backgroundColor = .randomColor()
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
        self.backgroundColor = .randomColor()
    }

    // MARK: ==== Event ====
    func showEmojiView() {

    }

    func hideEmojiView() {

    }

    func showPhotoView() {

    }

    func hidePhotoView() {

    }

    func showRecordView() {

    }

    func hideRecordView() {

    }

    func showMoreView() {

    }

    func hideMoreView() {

    }
}
