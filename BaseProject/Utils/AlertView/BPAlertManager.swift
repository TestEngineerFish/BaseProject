//
//  BPAlertManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Kingfisher

struct BPAlertManager {

    /// 默认样式: 底部左右两个按钮
    static func showAlertTwoBtn(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?) -> BPBaseAlertView {
        let alertView = BPAlerViewTwoButton(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure)
        return alertView
    }

    /// 底部一个按钮
    static func showAlertOntBtn(title: String, description: String, buttonName: String, closure: (() -> Void)?) -> BPBaseAlertView {
        let alertView = BPAlertViewOneButton(title: title, description: description, buttonName: buttonName, closure: closure)
        return alertView
    }

    /// 底部没有按钮
    static func showAlertZeroBtn(title: String, description: String, hideCloseBtn: Bool = true) -> BPBaseAlertView {
        let alertView = BPAlertViewZeroButton(title: title, description: description, hideCloseBtn: hideCloseBtn)
        return alertView
    }

    /// 显示纯图片
    @discardableResult
    static func showAlertImage(imageStr: String, hideCloseBtn: Bool = true, touchBlock: ((String?) -> Void)? = nil) -> BPAlertViewImage {
        let alertView = BPAlertViewImage(imageStr: imageStr, hideCloseBtn: hideCloseBtn, touchBlock: touchBlock)
        return alertView
    }
}
