//
//  BPChatRoomImageMessageCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Kingfisher

/// 图片消息
class BPChatRoomImageMessageBubble: BPChatRoomBaseMessageBubble {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(model: BPMessageModel) {
        super.init(model: model)
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(imageView)
        imageView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(90), height: AdaptSize(150)))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.layer.cornerRadius  = 5
        self.layer.masksToBounds = true
    }

    override func bindData() {
        super.bindData()
        self.messageModel.mediaModel?.getOriginImage(progress: nil, completion: { (image) in
            self.imageView.image = image
        })
    }
}
