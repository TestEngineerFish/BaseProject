//
//  BPPublishTipsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/25.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPubilshTipsView: BPView {

    private var localButton: BPButton = {
        let button = BPButton()
        button.setTitle("  ! 你在那里  ", for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: AdaptSize(11))
        button.layer.borderWidth = 0.9
        button.layer.borderColor = UIColor.gray0.cgColor
        return button
    }()
    private var tagButton: BPButton = {
        let button = BPButton()
        button.setTitle("  # 添加标签  ", for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: AdaptSize(11))
        button.layer.borderWidth = 0.9
        button.layer.borderColor = UIColor.gray0.cgColor
        return button
    }()
    private var limitButton: BPButton = {
        let button = BPButton()
        button.setTitle("广场可见 " + IconFont.back.rawValue, for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(11))
        return button
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
        self.backgroundColor = .white
        self.addSubview(localButton)
        self.addSubview(tagButton)
        self.addSubview(limitButton)
        localButton.sizeToFit()
        localButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.centerY.equalToSuperview()
            make.size.equalTo(localButton.size)
        }
        tagButton.sizeToFit()
        tagButton.snp.makeConstraints { (make) in
            make.left.equalTo(localButton.snp.right).offset(AdaptSize(10))
            make.centerY.equalToSuperview()
            make.size.equalTo(tagButton.size)
        }
        limitButton.sizeToFit()
        limitButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.centerY.equalToSuperview()
            make.size.equalTo(limitButton.size)
        }
        localButton.layer.cornerRadius = localButton.size.height/2
        tagButton.layer.cornerRadius   = tagButton.size.height/2
    }
    override func bindProperty() {
        super.bindProperty()
        self.localButton.addTarget(self, action: #selector(self.selectLocalAction), for: .touchUpInside)
        self.tagButton.addTarget(self, action: #selector(self.appendTagAction), for: .touchUpInside)
        self.limitButton.addTarget(self, action: #selector(self.setLimitAction), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc private func selectLocalAction() {
        BPLog("selectLocalAction")
    }

    @objc private func appendTagAction() {
        BPLog("appendTagAction")
    }

    @objc private func setLimitAction() {
        BPLog("setLimitAction")
    }
}
