//
//  CALayer+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/29.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

extension CALayer {

    /// 设置阴影
    /// - parameter opacity: 阴影的透明度, 默认0.8
    /// - parameter shadowRadius: 阴影半径长度,长度越大,阴影越大,默认3.0
    /// - parameter cornerRadius: 阴影圆角,默认当前View的一半
    func configPathShadow(opacity: Float = 0.8, shadowRadius: CGFloat = 3.0, cornerRadius: CGFloat) {

        // 设置阴影Layer
        let shadowLayer           = CALayer()
        shadowLayer.frame         = self.frame
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowOffset  = CGSize.zero
        shadowLayer.shadowColor   = UIColor.black.cgColor
        shadowLayer.shadowRadius  = shadowRadius

        // 设置阴影路径
        let bezierPath = UIBezierPath()
        let width      = shadowLayer.bounds.width
        let height     = shadowLayer.bounds.height
        let x          = shadowLayer.bounds.origin.x
        let y          = shadowLayer.bounds.origin.y

        // 根据阴影图路径,设置各个阴影各个顶点位置
        let topLeft     = shadowLayer.bounds.origin
        let topRight    = CGPoint(x: x + width, y: y)
        let bottomRight = CGPoint(x: x + width, y: y + height)
        let bottomLeft  = CGPoint(x: x, y: y + height)

        // 绘制路径
        let offset: CGFloat = 20.0

        bezierPath.move(to: CGPoint(x: topLeft.x - offset, y: topLeft.y + cornerRadius))
        bezierPath.addArc(withCenter: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y + cornerRadius), radius: (cornerRadius + offset), startAngle: CGFloat.pi, endAngle: CGFloat.pi*1.5, clockwise: true)

        bezierPath.addLine(to: CGPoint(x: topRight.x - cornerRadius, y: topRight.y - offset))
        bezierPath.addArc(withCenter: CGPoint(x: topRight.x - cornerRadius, y: topRight.y + cornerRadius), radius: (cornerRadius + offset), startAngle: CGFloat.pi*1.5, endAngle: CGFloat.pi*2, clockwise: true)

        bezierPath.addLine(to: CGPoint(x: bottomRight.x + offset, y: bottomRight.y - cornerRadius))
        bezierPath.addArc(withCenter: CGPoint(x: bottomRight.x - cornerRadius, y: bottomRight.y - cornerRadius), radius: cornerRadius + offset, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)

        bezierPath.addLine(to: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y + offset))
        bezierPath.addArc(withCenter: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y - cornerRadius), radius: (cornerRadius + offset), startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)

        bezierPath.addLine(to: CGPoint(x: topLeft.x - offset, y: topLeft.y + cornerRadius))
        shadowLayer.shadowPath = bezierPath.cgPath

        self.cornerRadius = cornerRadius
        self.masksToBounds = true
        self.shouldRasterize = true
        self.rasterizationScale = UIScreen.main.scale
        self.superlayer?.insertSublayer(shadowLayer, below: self)
    }


    /// 有可能图形用在复用的Cell或者Item上,所以定义一个name
    fileprivate var bezierPathIdentifier:String { return "bezierPathBorderLayer" }

    /// 查找View是否包含有已创建的CAShapeLayer
    fileprivate var bezierPathBorder:CAShapeLayer? {
        return (self.sublayers?.filter({ (layer) -> Bool in
            return layer.name == self.bezierPathIdentifier && (layer as? CAShapeLayer) != nil
        }) as? [CAShapeLayer])?.first
    }

    /// 以当前View边框为path,创建一个CAShapeLayer,添加到Layer层中
    /// - parameter color: 边框颜色, 默认白色
    /// - parameter width: 边框宽度, 默认1
    func bezierPathBorder(_ color:UIColor = .white, width:CGFloat = 1) {
        // 设置遮罩层形状与最终结果一致,保证显示的视图不会超过mask范围(其实可有可无,因为之后的代码保证了图层背景色透明,且)
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.cornerRadius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.mask = mask
        self.masksToBounds = true

        var border = self.bezierPathBorder
        if (border == nil) {
            border = CAShapeLayer()
            border!.name = self.bezierPathIdentifier
            self.addSublayer(border!)
        }

        border!.frame = self.bounds
        let pathUsingCorrectInsetIfAny =
            UIBezierPath(roundedRect: border!.bounds, cornerRadius:self.cornerRadius)

        border!.path = pathUsingCorrectInsetIfAny.cgPath
        border!.fillColor = UIColor.clear.cgColor
        border!.strokeColor = color.cgColor
        border!.lineWidth = width

    }

    /// 移除当前View已存在的CAShapeLayer和mask遮罩层
    func removeBezierPathBorder() {
        self.mask = nil
        self.bezierPathBorder?.removeFromSuperlayer()
    }
}
