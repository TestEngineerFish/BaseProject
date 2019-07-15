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
    //TODO 后续需移除yy_iconfont
    @objc class func iconfont(ofSize size: CGFloat) -> UIFont? {
        let oldIconFont = UIFont(name: "yy_iconfont", size: size)
        guard let _ = oldIconFont else {
            return UIFont(name: "iconfont", size: size)
        }
        
        return oldIconFont
    }
    
    @objc class func newIconFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "iconfont", size: size)
    }
    
}

public extension UIFont {
    
    private struct FontFamilyName {
        static let PingFangTCRegular: String = "PingFangSC-Regular"
        static let PingFangTCMedium: String = "PingFangSC-Medium"
        static let PingFangTCSemibold: String = "PingFangSC-Semibold"
        static let PingFangTCLight: String = "PingFangSC-Light"
        static let DINAlternateBold: String = "DINAlternate-Bold"
    }
    
    @objc class func regularFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCRegular, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    @objc class func mediumFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCMedium, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    @objc class func semiboldFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCSemibold, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    @objc class func lightFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCLight, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    @objc class func DINAlternateBold(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.DINAlternateBold, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
}

