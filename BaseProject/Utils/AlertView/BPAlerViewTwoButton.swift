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
        self.descriptionLabel.text = description
        self.rightActionBlock      = rightBtnClosure
        self.leftActionBlock       = leftBtnClosure
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        kWindow.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(leftButton)
        mainView.addSubview(rightButton)
        // 是否显示标题
        if let title = titleLabel.text, title.isNotEmpty {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(-rightPadding)
                make.height.equalTo(titleHeight)
            }
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(defaultSpace)
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(descriptionHeight)
            }
        } else {
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalTo(-rightPadding)
                make.height.equalTo(descriptionHeight)
            }
        }

        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(defaultSpace)
            make.left.equalTo(leftButton.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        leftButton.snp.makeConstraints { (make) in
            make.top.height.equalTo(rightButton)
            make.left.equalToSuperview()
        }

        let mainViewHeight = topPadding + titleHeight + defaultSpace*2 + descriptionHeight + buttonHeight
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
}

