//
//  Utils.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

struct Utils {

    /// 获取一个控制点的弧形上X值
    /// - Parameters:
    ///   - scale: x点占总长度的比例
    ///   - p0: 起始点
    ///   - c  : 控制点
    ///   - p1: 终点🏁
    static func getAngleX(t scale: Float, p0: CGPoint, c: CGPoint, p1: CGPoint) -> CGFloat {
        let t = scale
        let step0 = powf(Float(1 - t), 2.0) * Float(p0.x)
        let step1 = 2 * t * (1 - t) * Float(c.x)
        let step2 = powf(t, 2) * Float(p1.x)
        let x = step0 + step1 + step2
        return CGFloat(x)
    }
}


