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

//    //  底部一个按钮
//    init(title: String?, description: String, buttonName: String, closure: @escaping (() -> Void)) {
//        super.init(frame: .zero)
//        self.titleLabel.text   = title
//        self.descriptionHeight = description.textHeight(font: descriptionLabel.font, width: kScreenWidth - 60)
//        self.lrightAction      = closure
//        self.rightButton.setTitle(buttonName, for: .normal)
//        self.setupSubviews()
//    }

    // 底部两个按钮
    init(title: String?, description: String, leftBtnName: String, leftBtnClosure: @escaping (() -> Void), rightBtnName: String, rightBtnClosure: @escaping (() -> Void)) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.rightAction    = rightBtnClosure
        self.leftAction      = leftBtnClosure
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupSubviews() {
        super.setupSubviews()
//        containerView.snp.remakeConstraints { (make) in
//            make.center.equalTo(self)
//            make.left.equalToSuperview().offset(15)
//            make.right.equalToSuperview().offset(-15)
//            make.height.equalTo(200)
//        }
//        leftButton.snp.remakeConstraints { (make) in
//            make.bottom.equalTo(rightButton.snp.top).offset(-15)
//            make.left.equalToSuperview().offset(15)
//            make.right.equalTo(containerView.centerX).offset(-8)
//            make.height.equalTo(54)
//        }
//        rightButton.backgroundColor = UIColor.gray3
//        rightButton.setTitleColor(UIColor.black1, for: .normal)
//        rightButton.snp.remakeConstraints { (make) in
//            make.bottom.equalToSuperview().offset(-15)
//            make.left.equalTo(containerView.centerX).offset(8)
//            make.right.equalToSuperview().offset(-16)
//            make.height.equalTo(54)
//        }
    }

    override func leftBtnAction() {
        self.leftAction?()
    }

    override func rightBtnAction() {
        self.rightAction?()
    }
}

