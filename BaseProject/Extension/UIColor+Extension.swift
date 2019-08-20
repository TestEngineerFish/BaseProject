//
//  UIColor+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public extension UIColor {
    class func make(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }else{
            return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }
    }

    /// 十六进制颜色值
    /// - parameter hex: 十六进制值,例如: 0x000fff
    /// - parameter alpha: 透明度
    class func hex(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        if hex > 0xFFF {
            let divisor = CGFloat(255)
            let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
            let green   = CGFloat((hex & 0xFF00  ) >> 8)  / divisor
            let blue    = CGFloat( hex & 0xFF    )        / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            let divisor = CGFloat(15)
            let red     = CGFloat((hex & 0xF00) >> 8) / divisor
            let green   = CGFloat((hex & 0x0F0) >> 4) / divisor
            let blue    = CGFloat( hex & 0x00F      ) / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

    /// 根据方向,设置渐变色
    ///
    /// - Parameters:
    ///   - size: 渐变区域大小
    ///   - colors: 渐变色数组
    ///   - direction: 渐变方向
    /// - Returns: 渐变后的颜色,如果设置失败,则返回nil
    /// - note: 设置前,一定要确定当前View的高宽!!!否则无法准确的绘制
    class func gradientColor(with size: CGSize, colors: [CGColor], direction: GradientDirectionType) -> UIColor? {
        switch direction {
        case .horizontal:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        case .vertical:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        case .leftTop:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        case .leftBottom:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        }
    }

    /// 设置渐变色
    /// - parameter size: 渐变文字区域的大小.也就是用于绘制的区域
    /// - parameter colors: 渐变的颜色数组,从左到右顺序渐变,区域均匀分布
    /// - parameter startPoint: 渐变开始坐标
    /// - parameter endPoint: 渐变结束坐标
    /// - returns: 返回一个渐变的color,如果绘制失败,则返回nil;
    class func gradientColor(with size: CGSize, colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) -> UIColor? {
        // 设置画布,开始准备绘制
        UIGraphicsBeginImageContextWithOptions(size, false, kScreenScale)
        // 获取当前画布上下文,用于操作画布对象
        guard let context     = UIGraphicsGetCurrentContext() else { return nil }
        // 创建RGB空间
        let colorSpaceRef     = CGColorSpaceCreateDeviceRGB()
        // 在RGB空间中绘制渐变色,可设置渐变色占比,默认均分
        guard let gradientRef = CGGradient(colorsSpace: colorSpaceRef, colors: colors as CFArray, locations: nil) else { return nil }
        // 设置渐变起始坐标
        let startPoint        = CGPoint.zero
        // 设置渐变结束坐标
        let endPoint          = CGPoint(x: size.width, y: size.height)
        // 开始绘制图片
        context.drawLinearGradient(gradientRef, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: CGGradientDrawingOptions.drawsBeforeStartLocation.rawValue | CGGradientDrawingOptions.drawsAfterEndLocation.rawValue))
        // 获取渐变图片
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return UIColor(patternImage: gradientImage)
    }
    
}
//MARK: **************** 颜色值 **********************
public extension UIColor {

    //MARK: 颜色快捷设置相关函数
    static func ColorWithRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.make(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func ColorWithHexRGBA(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.hex(hex, alpha: alpha)
    }

    /// 主色绿 (red: 8, green: 207, blue: 78))
    static let green1 = ColorWithRGBA(red: 8, green: 207, blue: 78)

    /// 主色黑 (red: 34, green: 34, blue: 34)
    static let black1 = ColorWithRGBA(red: 34, green: 34, blue: 34)

    /// 文字背景灰色（red: 247, green: 247, blue: 247）
    static let gray10 = ColorWithRGBA(red: 247, green: 247, blue: 247)

    /// 按钮背景灰色（red: 247, green: 247, blue: 247）加 50% 透明度
    static let gray11 = ColorWithRGBA(red: 247, green: 247, blue: 247).withAlphaComponent(0.5)

    /// 友友页面头像提示背景颜色（red: 233, green: 239, blue: 235）
    static let green6 = ColorWithRGBA(red: 233, green: 239, blue: 235)

    /// 黄色（视频裁剪拖动矿颜色） (red: 255, green: 219, blue: 8)
    static let yellow1 = ColorWithRGBA(red: 255, green: 219, blue: 8)

    /// 友友 TableView 背景灰色 (red: 245, green: 246, blue: 249)
    static let gray13 = ColorWithRGBA(red: 245, green: 246, blue: 249)

    /** 背景色2 (red: 244, green: 244, blue: 244) */
    static let white2 = ColorWithRGBA(red: 244, green: 244, blue: 244)

    /** 背景色6(新好友cell) (red: 240, green: 242, blue: 247) */
    static let white6 = ColorWithRGBA(red: 240, green: 242, blue: 247)

    /** 按钮按下时的绿 (red: 36, green: 197, blue: 132) */
    static let green3 = ColorWithRGBA(red: 36, green: 197, blue: 132)

    /** 自定义标签文字 (red: 18, green: 162, blue: 105) */
    static let green4 = ColorWithRGBA(red: 18, green: 162, blue: 105)

    /** 自定义标签背景 (red: 225, green: 252, blue: 239) */
    static let green5 = ColorWithRGBA(red: 225, green: 252, blue: 239)

    /** 黑色 (red: 64, green: 64, blue: 64) */
    static let black2 = ColorWithRGBA(red: 64, green: 64, blue: 64)

    /** 黑色 (red: 70, green: 68, blue: 79) */
    static let black4 = ColorWithRGBA(red: 70, green: 68, blue: 79)

    /** 黑色 (red: 28, green: 28, blue: 28) */
    static let black5 = ColorWithRGBA(red: 28, green: 28, blue: 28)

    /** 金黄色（友币图标底色） (red: 255, green: 190, blue: 0) */
    static let yellow2 = ColorWithRGBA(red: 255, green: 190, blue: 0)

    /** 深灰色 (red: 136, green: 136, blue: 136) */
    static let gray1 = ColorWithRGBA(red: 136, green: 136, blue: 136)

    /** 浅灰色 (red: 165, green: 165, blue: 165) */
    static let gray2 = ColorWithRGBA(red: 165, green: 165, blue: 165)

    /** 浅灰色 (red: 241, green: 241, blue: 241) */
    static let gray3 = ColorWithRGBA(red: 241, green: 241, blue: 241)

    /** 浅灰色 (red: 213, green: 213, blue: 213) */
    static let gray4 = ColorWithRGBA(red: 213, green: 213, blue: 213)

    /** 浅灰色 (red: 179, green: 179, blue: 179) */
    static let gray5 = ColorWithRGBA(red: 179, green: 179, blue: 179)

    /** 浅灰色 (red: 245, green: 245, blue: 245) */
    static let gray6 = ColorWithRGBA(red: 245, green: 245, blue: 245)

    /** 浅灰色 (red: 193, green: 193, blue: 193) */
    static let gray7 = ColorWithRGBA(red: 193, green: 193, blue: 193)

    /** 浅灰色 (red: 157, green: 157, blue: 157) */
    static let gray8 = ColorWithRGBA(red: 157, green: 157, blue: 157)

    /** 浅灰色 (red: 239, green: 239, blue: 239) */
    static let gray9 = ColorWithRGBA(red: 239, green: 239, blue: 239)

    /** 浅灰色 (red: 239, green: 239, blue: 239) */
    static let gray12 = ColorWithRGBA(red: 151, green: 151, blue: 151)

    /** 赞/喜欢 (red: 247, green: 98, blue: 96) */
    static let red1 = ColorWithRGBA(red: 233, green: 79, blue: 79)

    /** 警告 (red: 244, green: 53, blue: 48) */
    static let red2 = ColorWithRGBA(red: 244, green: 53, blue: 48)

    /** 女 (red: 255, green: 165, blue: 185) */
    static let red3 = ColorWithRGBA(red: 255, green: 165, blue: 185)

    /** 背景色1 (red: 252, green: 252, blue: 254) */
    static let white1 = ColorWithRGBA(red: 252, green: 252, blue: 254)

    /** 背景色3 (red: 224, green: 224, blue: 224) */
    static let white3 = ColorWithRGBA(red: 224, green: 224, blue: 224)

    /** 背景色4 (red: 192, green: 192, blue: 192) */
    static let white4 = ColorWithRGBA(red: 192, green: 192, blue: 192)

    /** 背景色4 (red: 238, green: 238, blue: 238) */
    static let white5 = ColorWithRGBA(red: 238, green: 238, blue: 238)

    /** 背景色7 (red: 224, green: 230, blue: 232) */
    static let white7 = ColorWithRGBA(red: 224, green: 230, blue: 232)

    /** 背景色8 (red: 224, green: 230, blue: 232) */
    static let white8 = ColorWithRGBA(red: 232, green: 232, blue: 232)

    /** 主色蓝 (red: 0, green: 122, blue: 255) */
    static let blue1 = ColorWithRGBA(red: 0, green: 122, blue: 255)

    /** 男 (red: 106, green: 169, blue: 250) */
    static let blue2 = ColorWithRGBA(red: 106, green: 169, blue: 250)

    /** qq (red: 16, green: 174, blue: 255) */
    static let blue3 = ColorWithRGBA(red: 16, green: 174, blue: 255)

    /** qq 空间底色 (red: 255, green: 190, blue: 0) */
    static let orange1 = ColorWithRGBA(red: 255, green: 190, blue: 0)

}
