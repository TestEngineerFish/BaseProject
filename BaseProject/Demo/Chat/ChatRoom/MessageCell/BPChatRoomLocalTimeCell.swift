//
//  BPChatRoomLocalTimeCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/16.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatRoomLocalTimeCell: BPChatRoomBaseCell {
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment = .center
        return label
    }()

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(topSpace)
            make.bottom.equalToSuperview().offset(-bottomSpace)
        }
    }

    override func bindProperty() {
        super.bindProperty()
    }

    override func bindData(message model: BPMessageModel, indexPath: IndexPath) {
        super.bindData(message: model, indexPath: indexPath)
        self.timeLabel.text = model.time.timeStr()
    }
}
