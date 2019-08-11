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

        self.cornerRadius       = cornerRadius
        self.masksToBounds      = true
        self.shouldRasterize    = true
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

        border!.path        = pathUsingCorrectInsetIfAny.cgPath
        border!.fillColor   = UIColor.clear.cgColor
        border!.strokeColor = color.cgColor
        border!.lineWidth   = width

    }

    /// 移除当前View已存在的CAShapeLayer和mask遮罩层
    func removeBezierPathBorder() {
        self.mask = nil
        self.bezierPathBorder?.removeFromSuperlayer()
    }
    
    /// 设置渐变色
    /// - parameter colors: 渐变颜色数组
    /// - parameter locations: 逐个对应渐变色的数组,设置颜色的渐变占比,nil则默认平均分配
    /// - parameter startPoint: 开始渐变的坐标(控制渐变的方向),取值(0 ~ 1)
    /// - parameter endPoint: 结束渐变的坐标(控制渐变的方向),取值(0 ~ 1)
    @discardableResult
    public func setGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint.zero ,endPoint: CGPoint = CGPoint(x: 1, y: 1)) -> CAGradientLayer {
        /// 设置渐变色
        func _setGradient(_ layer: CAGradientLayer) {
            // self.layoutIfNeeded()
            var colorArr = [CGColor]()
            for color in colors {
                colorArr.append(color.cgColor)
            }
            
            /** 将UI操作的事务,先打包提交,防止出现视觉上的延迟展示,
             * 但如果在提交的线程中还有其他UI操作,则这些UI操作会被隐式的包在CATransaction事务中
             * 则当前显式创建的CATransaction则还是会等到这个UI操作的事务结束后,才会展示,毕竟嵌套了嘛
             * 如果一定要立马展示,可以结束之前的UI操作,强制展示:CATransaction.flush(),缺点就是会造成其他UI操作的异常
             */
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.frame = self.bounds
            CATransaction.commit()
            
            layer.colors     = colorArr
            layer.locations  = locations
            layer.startPoint = startPoint
            layer.endPoint   = endPoint
        }
        
        //查找是否有已经存在的渐变色Layer
        var kCAGradientLayerType = CAGradientLayerType.axial
        if let gradientLayer = objc_getAssociatedObject(self, &kCAGradientLayerType) as? CAGradientLayer {
            // 清除渐变颜色
            gradientLayer.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer()
        self.insertSublayer(gradientLayer , at: 0)
        _setGradient(gradientLayer)
        // 添加渐变色属性到当前Layer
        objc_setAssociatedObject(self, &kCAGradientLayerType, gradientLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return gradientLayer
    }
}

extension CALayer {
    /// 添加弹框动画,frame的比例放大缩小效果,类似果冻(Jelly)晃动
    /// - parameter duration: 动画持续时间
    func addJellyAnimation(duration: Double = 0.25){
        let animater            = CAKeyframeAnimation(keyPath: "transform.scale")
        animater.values         = [0.5, 1.1, 1.0]// 先保持大小比例,再放大,最后恢复默认大小
        animater.duration       = duration
        animater.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.add(animater, forKey: "jellyAnimation")
    }
}
