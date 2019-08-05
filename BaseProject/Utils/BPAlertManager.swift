//
//  BPAlertManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPAlertManager: BPTopWindowView {
    func showAlertView(_ title: String? = nil, titleFont: UIFont = UIFont.regularFont(ofSize: 18), description: String? = nil, descriptionFont: UIFont = UIFont.systemFont(ofSize: 16), leftButton: UIButton? = nil, leftBtnColor: UIColor = UIColor.gray, leftBtnClosure: @escaping (() -> Void), rightButton: UIButton? = nil, rightBtnColor: UIColor = UIColor.green, rightBtnClosure: @escaping (() -> Void)) {

    }

    //  底部一个按钮
    init(title: String?, description: String, buttonName: String, closure: @escaping (() -> Void)) {
        super.init(frame: .zero)
        self.descriptionHeight = description.textHeight(font: descriptionLabel.font, width: kScreenWidth - 60)
        self.setupSubviews()
    }

    // 底部两个按钮
    init(title: String?, description: String, leftBtnName: String, leftBtnClosure: @escaping (() -> Void), rightBtnName: String, rightBtnClosure: @escaping (() -> Void)) {
        super.init(frame: .zero)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
