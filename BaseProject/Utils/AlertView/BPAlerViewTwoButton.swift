//
//  BPAlerViewTwoButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 默认AlertView,显示底部左右两个按钮的样式
class BPAlerViewTwoButton: BPBaseAlertView {

    private var leftAction: (() -> Void)?
    private var rightAction: (() -> Void)?

    /// 底部左右两个按钮的Alert弹框
    /// - parameter title: 标题
    /// - parameter description: 描述
    /// - parameter leftBtnName: 左边按钮文案
    /// - parameter leftBtnClosure: 左边按钮点击事件
    /// - parameter rightBtnName: 右边按钮文案
    /// - parameter rightBtnClosure: 右边按钮点击事件
    init(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?) {
        super.init(frame: .zero)
        self.titleLabel.text       = title
        self.rightAction           = rightBtnClosure
        self.leftAction            = leftBtnClosure
        self.descriptionHeight     = description.textHeight(font: self.descriptionLabel.font, width: kScreenWidth - 90)
        self.descriptionLabel.text = description
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.createSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
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

        // 是否显示左边按钮
        if let leftBtnTitle = leftButton.titleLabel?.text, leftBtnTitle.isNotEmpty {
            leftButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
                make.left.equalToSuperview().offset(15)
                make.right.equalTo(containerView.snp.centerX).offset(-8)
                make.height.equalTo(56)
            }
            rightButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
                make.left.equalTo(containerView.snp.centerX).offset(8)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(56)
            }
        } else {
            rightButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(56)
            }
        }

        containerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(rightButton).offset(30)
        }
    }

    override func leftBtnAction() {
        self.leftAction?()
        super.leftBtnAction()
    }

    override func rightBtnAction() {
        self.rightAction?()
        super.rightBtnAction()
    }
}

