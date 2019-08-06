//
//  BPAlertManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

struct BPAlertManager {

    /// 默认样式: 底部左右两个按钮
    static func showAlert(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?) {
        let alertView = BPAlerViewTwoButton(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure)
        alertView.showToWindow()
    }

    /// 底部一个按钮
    static func showAlertOntBtn(title: String, description: String, buttonName: String, closure: (() -> Void)?){
        let alertView = BPAlertViewOneButton(title: title, description: description, buttonName: buttonName, closure: closure)
        alertView.showToWindow()
    }

    /// 底部没有按钮
    static func showAlertZeroBtn(title: String, description: String, showCloseBtn: Bool) {
        let alertView = BPAlertViewZeroButton(title: title, description: description, showCloseBtn: showCloseBtn)
        alertView.showToWindow()
    }

    /// 显示纯图片
    static func showAlertImage(imageStr: String, showCloseBtn: Bool) {
        let alertView = BPAlertViewImage(imageStr: imageStr, showCloseBtn: showCloseBtn)
        alertView.showToWindow()
    }
}
