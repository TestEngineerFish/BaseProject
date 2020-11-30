//
//  BPView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit
import SnapKit

class BPView: UIView {
    
    deinit {
        #if DEBUG
        BPLog(self.classForCoder, "资源释放")
        #endif
    }

    /// 初始化子视图
    internal func createSubviews() {}

    /// 初始化属性
    internal func bindProperty() {}
    
    /// 初始化数据
    internal func bindData() {}
}
