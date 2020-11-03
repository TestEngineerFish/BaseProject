//
//  BPAlertManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Kingfisher

class BPAlertManager {
    
    static var share       = BPAlertManager()
    private var alertArray = [BPBaseAlertView]()
    private var isShowing  = false
    
    private func show() {
        guard !self.isShowing else {
            return
        }
        self.isShowing = true
        // 排序
        guard let alertView = self.alertArray.sorted(by: { $0.priority.rawValue < $1.priority.rawValue }).first else {
            return
        }
        // 关闭弹框后的闭包
        alertView.closeActionBlock = { [weak self] in
            guard let self = self else { return }
            self.isShowing = false
            self.removeAlert()
        }
        alertView.show()
    }

    /// 添加一个alertView
    /// - Parameter alertView: alert对象
    private func addAlert(alertView: BPBaseAlertView) {
        self.alertArray.append(alertView)
    }

    /// 移除当前已显示的Alert
    private func removeAlert() {
        self.alertArray.removeFirst()
        // 如果队列中还有未显示的Alert，则继续显示
        guard !self.alertArray.isEmpty else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.show()
        }
    }

    /// 默认样式: 底部左右两个按钮
    func showTwoButton(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?) {
        let alertView = BPAlerViewTwoButton(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure)
        self.addAlert(alertView: alertView)
        self.show()
    }

    /// 底部一个按钮
    func showOneButton(title: String?, description: String, buttonName: String, closure: (() -> Void)?) {
        let alertView = BPAlertViewOneButton(title: title, description: description, buttonName: buttonName, closure: closure)
        self.addAlert(alertView: alertView)
        self.show()
    }

    /// 底部没有按钮
    func showZeroButton(title: String?, description: String) {
        let alertView = BPAlertViewZeroButton(title: title, description: description)
        self.addAlert(alertView: alertView)
        self.show()
    }

    /// 显示纯图片
    func showOnlyImage(imageStr: String, hideCloseBtn: Bool = false, touchBlock: ((String?) -> Void)? = nil) {
        let alertView = BPAlertViewImage(imageStr: imageStr, hideCloseBtn: hideCloseBtn, touchBlock: touchBlock)
        self.addAlert(alertView: alertView)
        self.show()
    }
}
