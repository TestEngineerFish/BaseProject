//
//  BPPublishLocalCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/27.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPublishLocalcell: UITableViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(9))
        label.textAlignment = .left
        return label
    }()

    private var selectButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.select.rawValue, for: .normal)
        button.setTitleColor(UIColor.orange1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(20))
        button.isHidden = true
        return button
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
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(selectButton)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalTo(selectButton.snp.left).offset(AdaptSize(-15))
            make.top.equalToSuperview().offset(AdaptSize(10))
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
        }
        selectButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(20)))
        }
    }

    private func bindProperty() {
        self.selectionStyle = .none
    }

    // MARK: ==== Event ====

    func setData(type: BPPublishLimitType, selected: Bool) {
        self.titleLabel.text    = type.title
        self.subtitleLabel.text = type.subtitle
        self.selectButton.isHidden = !selected
    }
}
