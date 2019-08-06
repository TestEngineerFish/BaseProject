//
//  BPAlertViewOneButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPAlertViewOneButton: BPBaseAlertView {

    private var rightAction: (() -> Void)?

    /// 底部左右两个按钮的Alert弹框
    /// - parameter title: 标题
    /// - parameter description: 描述
    /// - parameter buttonName: 按钮文案
    /// - parameter closure: 按钮点击事件
    init(title: String?, description: String, buttonName: String, closure: (() -> Void)?) {
        super.init(frame: .zero)
        self.titleLabel.text       = title
        self.rightAction           = closure
        self.descriptionHeight     = description.textHeight(font: self.descriptionLabel.font, width: kScreenWidth - 90)
        self.descriptionLabel.text = description
        self.rightButton.setTitle(buttonName, for: .normal)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupSubviews() {
        super.setupSubviews()
        // 是否显示标题
        if let title = titleLabel.text, title.isNotEmpty {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(18)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(22)
            }

            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(18)
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(descriptionHeight)
            }
        } else {
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(18)
                make.left.equalToSuperview().offset(15)
                make.right.equalTo(-15)
                make.height.equalTo(descriptionHeight)
            }
        }

        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(56)
        }

        containerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(rightButton).offset(30)
        }
    }

    override func rightBtnAction() {
        self.rightAction?()
        super.rightBtnAction()
    }
}
