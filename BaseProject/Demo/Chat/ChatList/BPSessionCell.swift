//
//  BPChatCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPSessionCell: UITableViewCell {
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius  = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()

    private var messageLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()

    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment = .right
        return label
    }()

    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray3
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(messageLabel)
        self.addSubview(timeLabel)
        self.addSubview(lineView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.width.height.equalTo(self.snp.height).offset(AdaptSize(-10))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(10))
            make.top.equalTo(avatarImageView)
            make.right.equalTo(timeLabel.snp.left).offset(AdaptSize(-5))
        }
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.bottom.equalTo(avatarImageView)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(AdaptSize(50))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }

    private func bindProperty() {

    }

    // MARK: ==== Event ====
    func setData(model: BPSessionModel) {
        self.avatarImageView.image = UIImage(named: "dog")
        self.nameLabel.text        = model.name
        self.messageLabel.text     = model.lastMsg
        self.timeLabel.text        = "\(model.msgTime)"
    }
}
