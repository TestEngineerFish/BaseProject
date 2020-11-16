//
//  BPChatRoomLocalTimeCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/16.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatRoomLocalTimeCell: UITableViewCell {
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: 11)
        label.textAlignment = .center
        return label
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
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(5))
            make.bottom.equalToSuperview().offset(AdaptSize(-5))
        }
    }

    private func bindProperty() {
        self.backgroundColor = .clear
        self.selectionStyle  = .none
    }

    func setData(time: Date) {
        self.timeLabel.text = time.timeStr()
    }
}
