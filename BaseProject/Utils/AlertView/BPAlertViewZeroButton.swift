//
//  BPAlertViewZeroButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPAlertViewZeroButton: BPBaseAlertView {
    
    /// 底部左右两个按钮的Alert弹框
    /// - parameter title: 标题
    /// - parameter description: 描述
    /// - parameter hideCloseBtn: 是否隐藏右上角的关闭按钮
    init(title: String?, description: String, hideCloseBtn: Bool = false) {
        super.init(frame: .zero)
        self.titleLabel.text       = title
        self.descriptionLabel.text = description
        self.closeButton.isHidden  = hideCloseBtn
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        kWindow.addSubview(mainView)
        self.mainView.addSubview(titleLabel)
        self.mainView.addSubview(descriptionLabel)
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
        let mainViewHeight = topPadding + titleHeight + defaultSpace + descriptionHeight + bottomPadding
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
    }

}
