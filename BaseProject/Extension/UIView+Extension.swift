//
//  UIView+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/**
 *  ViewGeometry
 */
public extension UIView {

    /// 顶部距离父控件的距离
    ///
    ///     self.frame.origin.y
    var top: CGFloat {
        get{
            return self.frame.origin.y
        }
        
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    /// 左边距离父控件的距离
    ///
    ///     self.frame.origin.x
    var left: CGFloat {
        get{
            return self.frame.origin.x
        }
        
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    /// 当前View的底部,距离父控件顶部的距离
    ///
    ///     self.frame.maxY
    var bottom: CGFloat {
        get {
            return self.frame.maxY
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }

    /// 当前View的右边,距离父控件左边的距离
    ///
    ///     self.frame.maxX
    var right: CGFloat {
        get {
            return self.frame.maxX
        }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue + self.frame.size.width
            self.frame = frame
        }
    }

    /// 宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    /// 高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    /// X轴的中心位置
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    /// Y轴的中心位置
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    /// 左上角的顶点,在父控件中的位置
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    /// 尺寸大小
    var size: CGSize {
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
}

extension UIView {
    
    /// 移除父视图中的所有子视图
    public func removeAllSubviews() {
        while (self.subviews.count > 0) {
            self.subviews.last?.removeFromSuperview()
        }
    }
}

extension UIView {
    
    /// 裁剪 view 的圆角,裁一角或者全裁
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter direction: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    public func clipRectCorner(direction: UIRectCorner, cornerRadius: CGFloat) {
        let cornerSize = CGSize(width:cornerRadius, height:cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.addSublayer(maskLayer)
        layer.mask = maskLayer
    }

    /*
     *                      .,:;;iiiiiiiii;;:,,.
     *                ,.;iirrrrriiiiiiiiiirrrrri;,s&
     *              r3AH5iiiii;;;;;;;;;;;;;;;;iiirXHGSs
     *            .;i;;s91;;;;;;::::::::::::;;;;iS5;;;ii:
     *          :rsriii;;r::::::::::::::::::::::;;,;;iiirsi,
     *       .,;;;;;::::;;;;;;::,,,,,,,,,,,,,..,,;;;;;;;;iiri,
     *     ,9;;;;;;;;;;;;;;;;.,:;;:,,,,,,,,,,,;;;;;;;;;;;;;;;;;;
     *    ,;;;;;:;;;;;::::,,.;;;;r,,,,,,,,,,;;;;;;;;;:::;;;::;;;
     *   ,:ih1iii;;;;;::::;;;;;;;:,,,,,,,,,,;;;;;;;;;;;;;;;;;;;;;,
     *  ,ir;;iiiiiiiiii;;;;::::::,,,,,,,:::::,,:;;;;;;;;;;;;;;;;;;,
     *  ,iriiiiiiiiiiiiiiii;;;::::::::::::::::;;;iiiiiiiiiiiiiiiir;
     * ,iriii;;;;;;;;;;;;;:::::::::::::::::::::::;;;;;;;;;;;;;;iiir.
     * ,iri;;;::::,,,,,,,,,,:::::::::::::::::::::::::,::,,::::;;iir:,
     * .rii;;::::,,,,,,,,,,,,:::::::::==============================i
     * ,rii;;;::,,,,,,,,,,,,,:::::::::::,:::::;;;;;;;;;;;;;;:::;;;iir.
     * ,rii;;i::,,,,,,,,,,,,,:::::::::::::::::,,,,,,,,,,,,,,::i;;iir.
     * ,rii;;r::,,,,,,,,,,,,,:,:::::,:,:::::::,,,,,,,,,,,,,::;r;;iir.
     * .rii;;rr,:,,,,,,,,,,,,,,:::::::::::::::,,,,,,,,,,,,,:,si;;iri
     *  ;rii;:1i,,,,,,,,,,,,,,,,,,:::::::::,,,,,,,,,,,,,,,:,ss:;iir:
     *  .rii;;;5r,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,sh:;;iri
     *   ;rii;:;51,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.:hh:;;iir,
     *    irii;::hSr,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.,sSs:;;iir:
     *     irii;;:iSSs:.,,,,,,,,,,,,,,,,,,,,,,,,,,,..:135;:;;iir:
     *      ;rii;;:,r535r:...,,,,,,,,,,,,,,,,,,..,;sS35i,;;iirr:
     *       :rrii;;:,;1S3Shs;:,............,:is533Ss:,;;;iiri,
     *        .;rrii;;;:,;rhS393S55hh11hh5S3393Shr:,:;;;iirr:
     *          .;rriii;;;::,:;is1h555555h1si;:,::;;;iirri:.
     *            .:irrrii;;;;;:::,,,,,,,,:::;;;;iiirrr;,
     *               .:irrrriiiiii;;;;;;;;iiiiiirrrr;,.
     *                  .,:;iirrrrrrrrrrrrrrrrri;:.
     *                        ..,:::;;;;:::,,.
     */
    /// 根据需要,裁剪各个顶点为圆角
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter directionList: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    /// - note: .pi等于180度,圆角计算,默认以圆横直径的右半部分顺时针开始计算(就类似上面那个圆形中的‘=====’线),当然如果参数 clockwies 设置false.则逆时针开始计算角度
    func clipRectCorner(directionList: [UIRectCorner], cornerRadius radius: CGFloat) {
        let bezierPath = UIBezierPath()
        // 以左边中间节点开始绘制
        bezierPath.move(to: CGPoint(x: 0, y: height/2))
        // 如果左上角需要绘制圆角
        if directionList.contains(.topLeft) {
            bezierPath.move(to: CGPoint(x: 0, y: radius))
            bezierPath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
        } else {
            bezierPath.addLine(to: origin)
        }
        // 如果右上角需要绘制
        if directionList.contains(.topRight) {
            bezierPath.addLine(to: CGPoint(x: right - radius, y: 0))
            bezierPath.addArc(withCenter: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: width, y: 0))
        }
        // 如果右下角需要绘制
        if directionList.contains(.bottomRight) {
            bezierPath.addLine(to: CGPoint(x: width, y: height - radius))
            bezierPath.addArc(withCenter: CGPoint(x: width - radius, y: height - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: width, y: height))
        }
        // 如果左下角需要绘制
        if directionList.contains(.bottomLeft) {
            bezierPath.addLine(to: CGPoint(x: radius, y: height))
            bezierPath.addArc(withCenter: CGPoint(x: radius, y: height - radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: 0, y: height))
        }
        // 与开始节点闭合
        bezierPath.addLine(to: CGPoint(x: 0, y: height/2))

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = bezierPath.cgPath
        layer.mask = maskLayer
    }
}

// MARK: --- 颜色处理 ---
extension UIView {
    
    @discardableResult
    public func setGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint ,endPoint: CGPoint) -> CAGradientLayer {
        func setGradient(_ layer: CAGradientLayer) {
            self.layoutIfNeeded()
            var colorArr = [CGColor]()
            for color in colors {
                colorArr.append(color.cgColor)
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.frame = self.bounds
            CATransaction.commit()
            
            layer.colors = colorArr
            layer.locations = locations
            layer.startPoint = startPoint
            layer.endPoint = endPoint
        }
        
        var kCAGradientLayerType = CAGradientLayerType.axial
        if let gradientLayer = objc_getAssociatedObject(self, &kCAGradientLayerType) as? CAGradientLayer {
            setGradient(gradientLayer)
            return gradientLayer
        } else {
            var gradientLayer = CAGradientLayer()
            self.layer.insertSublayer(gradientLayer , at: 0)
            setGradient(gradientLayer)
            objc_setAssociatedObject(self, &gradientLayer, gradientLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return gradientLayer
        }
    }
    
}

extension UIView {
    /** 获取当前的 ViewController */
    public var currentViewController: UIViewController? {
        return UIViewController.currentViewController
    }
    
    public class func cleanTopWindow(anyClass: AnyClass) {
        if let tviews = UIApplication.shared.keyWindow?.subviews {
            for tview in tviews {
                if tview.isKind(of: anyClass) {
                    tview.removeFromSuperview()
                }
            }
        }
    }
    
    /**
     * 显示Toast提示，基于当前的View，不影响其他页面的操作
     */
    public func toast(_ message: String?) {
        if let msg = message, msg.isNotEmpty {
            self.makeToast(msg, duration: 1.5, position: CSToastPositionCenter)
        }
    }
    
    /**
     * 显示Toast提示，基于最顶层，可能会影响其他的操作
     */
    public class func topToast(_ message: String?) {
        if let msg = message, msg.isNotEmpty {
            if let topWindow = UIApplication.shared.windows.last {
                topWindow.toast(msg)
            }
        }
    }
}

extension CGAffineTransform {
    var angle: CGFloat { return atan2(-self.c, self.a) }
    
    var angleInDegrees: CGFloat { return self.angle * 180 / .pi }
    
    var scaleX: CGFloat {
        let angle = self.angle
        return self.a * cos(angle) - self.c * sin(angle)
    }
    
    var scaleY: CGFloat {
        let angle = self.angle
        return self.d * cos(angle) + self.b * sin(angle)
    }
}

