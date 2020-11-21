//
//  BPChatRoomWithDrawCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/21.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation


class BPChatRoomWithDrawCell: BPChatRoomBaseCell {

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = "你撤回了一条消息"
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        label.sizeToFit()
        label.size = CGSize(width: AdaptSize(130), height: label.font.lineHeight)
        return label
    }()
    private var reeditButton: BPButton = {
        let button = BPButton()
        button.setTitle("重新编辑", for: .normal)
        button.setTitleColor(UIColor.blue1, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(12))
        button.size = CGSize(width: AdaptSize(60), height: AdaptSize(12))
        return button
    }()

    override func createSubviews() {
        super.createSubviews()
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(reeditButton)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(AdaptSize(-20))
            make.top.equalToSuperview().offset(topSpace)
            make.bottom.equalToSuperview().offset(-bottomSpace)
            titleLabel.size.equalTo(titleLabel.size)
        }
        reeditButton.sizeToFit()
        reeditButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(reeditButton.size)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.reeditButton.addTarget(self, action: #selector(reeditAction), for: .touchUpInside)
    }

    override func bindData(message model: BPMessageModel, indexPath: IndexPath) {
        super.bindData(message: model, indexPath: indexPath)
        let offsetSce = -model.time.timeIntervalSinceNow
        if offsetSce > TimeInterval(minute * 2) {
            self.reeditButton.isHidden = true
            self.titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview()
            }
        } else {
            self.reeditButton.isHidden = false
            self.titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview().offset(AdaptSize(-20))
            }
        }
    }

    // MARK: === Event ====

    @objc private func reeditAction() {
        guard let _messageModel = self.messageModel, let _indexPath = self.indexPath else {
            return
        }
        self.delegate?.reeditAction(model: _messageModel, indexPath: _indexPath)
    }
}
