//
//  BPDrawPath.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

struct BPDrawPath {
    var drawPath: UIBezierPath
    var drawColor: UIColor
    var lineWidth: CGFloat
    var image: UIImage?

    init(path: CGPath, color: UIColor, line width: CGFloat) {
        self.drawPath  = UIBezierPath(cgPath: path)
        self.drawColor = color
        self.lineWidth = width
    }
}
