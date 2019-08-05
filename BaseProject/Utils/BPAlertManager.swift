//
//  BPAlertManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

struct BPAlertManager {

    // 底部两个按钮
    static func showAlert(title: String?, description: String, leftBtnName: String, leftBtnClosure: @escaping (() -> Void), rightBtnName: String, rightBtnClosure: @escaping (() -> Void)) {
        let alertView = BPAlerView(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure)
        alertView.showToWindow()
    }
}
