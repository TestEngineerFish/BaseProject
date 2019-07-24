//
//  UIColor+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    class func make(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }else{
            return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }
    }

    /// 十六进制颜色值
    /// - parameter hex: 十六进制值,例如:“0x000fff”
    /// - parameter alpha: 透明度
    class func make(hex:String, alpha: CGFloat = 1.0) -> UIColor {
        var hexint: UInt32 = 0

        let scanner = Scanner(string: hex)

        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexint)

        if hex.count <= 4 {
            let divisor = CGFloat(15)
            let red     = CGFloat((hexint & 0xF00) >> 8) / divisor
            let green   = CGFloat((hexint & 0x0F0) >> 4) / divisor
            let blue    = CGFloat( hexint & 0x00F      ) / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha / 100)
        }else {
            let divisor = CGFloat(255)
            let red     = CGFloat((hexint & 0xFF0000) >> 16) / divisor
            let green   = CGFloat((hexint & 0xFF00  ) >> 8)  / divisor
            let blue    = CGFloat( hexint & 0xFF    )        / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha / 100)
        }
    }
}
