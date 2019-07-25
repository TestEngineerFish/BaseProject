//
//  UIFont+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit.UIFont

/**
 *  IconFont
 */
public extension UIFont {
    class func iconFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "iconfont", size: size)
    }
}

public extension UIFont {

    /// 常用字体
    private struct FontFamilyName {
        static let PingFangTCRegular  = "PingFangSC-Regular"
        static let PingFangTCMedium   = "PingFangSC-Medium"
        static let PingFangTCSemibold = "PingFangSC-Semibold"
        static let PingFangTCLight    = "PingFangSC-Light"
        static let DINAlternateBold   = "DINAlternate-Bold"
    }
    
    class func regularFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCRegular, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    class func mediumFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCMedium, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    class func semiboldFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCSemibold, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    class func lightFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCLight, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    class func DINAlternateBold(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.DINAlternateBold, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
}

