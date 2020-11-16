//
//  BPToastManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/16.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Toast_Swift

struct BPToastManager {
    static let share = BPToastManager()

    func showToast(title: String? = nil, message: String, complete block: DefaultBlock?) {
        kWindow.makeToast(message, duration: 3, point: kWindow.center, title: title, image: nil, style: ToastStyle()) { (finished) in
            block?()
        }
    }
}
