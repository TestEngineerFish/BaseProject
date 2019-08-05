//
//  BPAlertView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPAlerView: BPTopWindowView {

    private var leftAction: (() -> Void)?
    private var rightAction: (() -> Void)?

    // 底部两个按钮
    init(title: String?, description: String, leftBtnName: String, leftBtnClosure: @escaping (() -> Void), rightBtnName: String, rightBtnClosure: @escaping (() -> Void)) {
        super.init(frame: .zero)
        self.titleLabel.text       = title
        self.rightAction           = rightBtnClosure
        self.leftAction            = leftBtnClosure
        self.descriptionHeight     = description.textHeight(font: self.descriptionLabel.font, width: kScreenWidth - 90)
        self.descriptionLabel.text = description
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupSubviews() {
        super.setupSubviews()
    }

    override func leftBtnAction() {
        self.leftAction?()
        super.leftBtnAction()
    }

    override func rightBtnAction() {
        self.rightAction?()
        super.rightBtnAction()
    }
    
    override func closeBtnAction() {
        super.closeBtnAction()
    }
}

