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
    
    static var share = BPAlertManager()
    private var alertArray = [BPBaseAlertView]()
    private var isShowing  = false
    
    /// 添加一个alertView
    /// - Parameter alertView: alert对象
    private func addAlert(alertView: BPBaseAlertView) {
        self.alertArray.append(alertView)
        if !isShowing {
            alertView.show()
        }
    }
    
    func show() {
        guard !self.isShowing else {
            return
        }
        self.isShowing = true
        // 排序
        let alertView = self.alertArray.sorted { $0.priority.rawValue < $1.priority.rawValue }.first
        // 关闭弹框后的闭包
        alertView?.closeActionBlock = { [weak self] in
            guard let self = self else { return }
            self.isShowing = false
            self.removeAlert()
        }
        // 显示弹框
        alertView?.show()
    }
    
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
    func twoButton(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?) -> BPAlertManager {
        let alertView = BPAlerViewTwoButton(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure)
        self.addAlert(alertView: alertView)
        return self
    }

    /// 底部一个按钮
    func oneButton(title: String?, description: String, buttonName: String, closure: (() -> Void)?) -> BPAlertManager {
        let alertView = BPAlertViewOneButton(title: title, description: description, buttonName: buttonName, closure: closure)
        self.addAlert(alertView: alertView)
        return self
    }

    /// 底部没有按钮
    func zeroButton(title: String?, description: String) -> BPAlertManager {
        let alertView = BPAlertViewZeroButton(title: title, description: description)
        self.addAlert(alertView: alertView)
        return self
    }

    /// 显示纯图片
    func onlyImage(imageStr: String, hideCloseBtn: Bool = false, touchBlock: ((String?) -> Void)? = nil) -> BPAlertManager {
        let alertView = BPAlertViewImage(imageStr: imageStr, hideCloseBtn: hideCloseBtn, touchBlock: touchBlock)
        self.addAlert(alertView: alertView)
        return self
    }
}
