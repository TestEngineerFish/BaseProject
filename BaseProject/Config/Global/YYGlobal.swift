//
//  YYGlobal.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Alamofire


// MARK: 常量
public let UQID_KEY   = "Sam_UQID_KEY"
public let buglyAppId = "36cec5946b"

// MARK: ---尺寸相关---
/// 屏幕宽
public var kScreenWidth: CGFloat {
    get {
        return UIScreen.main.bounds.size.width
    }
}

/// 屏幕高
public var kScreenHeight: CGFloat {
    get {
        return UIScreen.main.bounds.size.height
    }
}

/// 屏幕比例,返回
/// 1: 代表320 x 480 的分辨率(就是iphone4之前的设备，非Retain屏幕);
/// 2: 代表640 x 960 的分辨率(Retain屏幕);
/// 3: 代表1242 x 2208 的分辨率;
public var kScreenScale: CGFloat {
    get {
        return UIScreen.main.scale
    }
}
/// 状态栏高度
public var kStatusBarHeight:CGFloat {
    get {
        return iPhoneXLater ? 44.0 : 20.0
    }
}

/// Navigation Bar 高度
public var kNavHeight:CGFloat {
    get {
        return kStatusBarHeight + 44.0
    }
}

// TabBar 高度
public var kTabBarHeight:CGFloat {
    get {
        return 49 + kSafeBottomMargin
    }
}

/// 全面屏的底部安全高度
public var kSafeBottomMargin:CGFloat {
    get {
        return iPhoneXLater ? 34.0 : 0.0
    }
}

// MARK: ---文件存储路径或目录---
/// 存储总目录路径
public var kPathForMainStorageLocation: String {
    get {
        return NSHomeDirectory() + "/Documents"
    }
}

// MARK: ---网络相关---
/// 是否有网络
public var isReachable: Bool {
    get {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

/// 是否是蜂窝网络,WWAN网络
/// WWAN（Wireless Wide Area Network，无线广域网）
public var isReachableOnWWAN: Bool {
    get {
        return NetworkReachabilityManager()?.isReachableOnWWAN ?? false
    }
}

/// 是否是Wifi或者以太网网络
public var isReachableOnEthernetOrWiFi: Bool {
    get {
        return NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi ?? false
    }
}

// MARK: ---其他---
/// 当前Window
public var kWindow: UIWindow {
    get {
        guard let window = UIApplication.shared.keyWindow else {
            return UIWindow(frame: CGRect.zero)
        }
        return window
    }
}

/// 是否是iPhoneX之后的设备
public var iPhoneXLater: Bool {
    get {
        let iPhoneXLaterModelList = [DeviceModelType.iPhoneX, DeviceModelType.iPhoneXr, DeviceModelType.iPhoneXs, DeviceModelType.iPhoneXsMax, DeviceModelType.simulator]
        return iPhoneXLaterModelList.contains(DeviceInfoGlobal.model())
    }
}

/// 当前设备是否是模拟器
public var isSimulator: Bool {
    get {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
}

/// 判断当前设备是否是iPad
public var isPad: Bool {
    get {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

public func getScreenshotImage() -> UIImage? {
    guard let layer = UIApplication.shared.keyWindow?.layer else {
        return nil
    }
    let renderer = UIGraphicsImageRenderer(size: layer.frame.size)
    let image = renderer.image { (context: UIGraphicsImageRendererContext) in
        layer.render(in: context.cgContext)
    }
    return image
}

