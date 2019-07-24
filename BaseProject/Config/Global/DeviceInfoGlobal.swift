//
//  DeviceInfoGlobal.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/24.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

public struct DeviceInfoGlobal {
    /// 设备型号
    public static func model() -> DeviceModelType {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine: [CChar] = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        let platform = String(cString: machine)
        switch platform {
        // iPhone
        case "iPhone1,1": return .iPhone1
        case "iPhone1,2": return .iPhone3g
        case "iPhone2,1": return .iPhone3gs
        case "iPhone3,1","iPhone3,2","iPhone3,3": return .iPhone4
        case "iPhone4,1": return .iPhone4s
        case "iPhone5,1","iPhone5,2": return .iPhone5
        case "iPhone5,3","iPhone5,4": return .iPhone5c
        case "iPhone6,1","iPhone6,2": return .iPhone5s
        case "iPhone7,1": return .iPhone6plus
        case "iPhone7,2": return .iPhone6
        case "iPhone8,1": return .iPhone6s
        case "iPhone8,2": return .iPhone6sPlus
        case "iPhone8,4": return .iPhoneSE
        case "iPhone9,1","iPhone9,3":   return .iPhone7
        case "iPhone9,2","iPhone9,4":   return .iPhone7plus
        case "iPhone10,1","iPhone10,4": return .iPhone8
        case "iPhone10,2","iPhone10,5": return .iPhone8Plus
        case "iPhone10,3","iPhone10,6": return .iPhoneX
        case "iPhone11,8": return .iPhoneXr
        case "iPhone11,2": return .iPhoneXs
        case "iPhone11,6": return .iPhoneXsMax
        // iPod
        case "iPod1,1": return .iPodTouch1
        case "iPod2,1": return .iPodTouch2
        case "iPod3,1": return .iPodTouch3
        case "iPod4,1": return .iPodTouch4
        case "iPod5,1": return .iPodTouch5
        case "iPod7,1": return .iPodTouch6
        case "iPod9,1": return .iPodTouch7
        // iPad mini
        case "iPad2,5","iPad2,6","iPad2,7": return .iPadMini1
        case "iPad4,4","iPad4,5","iPad4,6": return .iPadMini2
        case "iPad4,7","iPad4,8","iPad4,9": return .iPadMini3
        case "iPad5,1","iPad5,2":           return .iPadMini4
        case "iPad11,1","iPad11,2":         return .iPadMini5
        // iPad
        case "iPad1,1": return .iPad1
        case "iPad2,1","iPad2,2","iPad2,3","iPad2,4": return .iPad2
        case "iPad3,1","iPad3,2","iPad3,3": return .iPad3
        case "iPad3,4","iPad3,5","iPad3,6": return .iPad4
        case "iPad4,1","iPad4,2","iPad4,3": return .iPadAir1
        case "iPad5,3","iPad5,4":   return .iPadAir2
        case "iPad6,8","iPad6,7":   return .iPadPro_12Inch1
        case "iPad6,3","iPad6,4":   return .iPadPro_9Inch
        case "iPad6,11","iPad6,12": return .iPad5
        case "iPad7,1","iPad7,2":   return .iPadPro_12Inch2
        case "iPad7,3","iPa7,4":    return .iPadPro_10Inch
        case "iPad7,5","iPad7,6":   return .iPad6
        case "iPad8,1","iPad8,2","iPad8,3","iPad8,4": return .iPadPro_11Inch
        case "iPad8,5","iPad8,6","iPad8,7","iPad8,8": return .iPadPro_12Inch3
        case "iPad11,3","iPad11,4": return .iPadAir3
        // Apple Watch
        case "Watch1,1","Watch1,2": return .appleWatch
        case "Watch2,6","Watch2,7": return .appleWatch1
        case "Watch2,3","Watch2,4": return .appleWatch2
        case "Watch3,1","Watch3,2","Watch3,3","Watch3,4": return .appleWatch3
        case "Watch4,1","Watch4,2","Watch4,3","Watch4,4": return .appleWatch4
        // Apple TV
        case "AppleTV2,1": return .appleTV2
        case "AppleTV3,1","AppleTV3,2": return .appleTV3
        case "AppleTV5,3": return .appleTV4
        case "AppleTV6,2": return .appleTV4K
        // AirPods
        case "AirPods1,1": return .airPods1
        case "AirPods2,1": return .airPods2
        // HomePod
        case "AudioAccessory1,1","AudioAccessory1,2": return .homePod
        // Simulator
        case "i386","x86_64": return .simulator
        default: return .newDevice
        }
    }
}

/// 定义苹果设备的枚举类型
public enum DeviceModelType: String {
    // iPhone
    case iPhone1      = "iPhone 1g"
    case iPhone3g     = "iPhone 3g"
    case iPhone3gs    = "iPhone 3gs"
    case iPhone4      = "iPhone 4"
    case iPhone4s     = "iPhone 4s"
    case iPhone5      = "iPhone 5"
    case iPhone5c     = "iPhone 5c"
    case iPhone5s     = "iPhone 5s"
    case iPhone6plus  = "iPhone 6 Plus"
    case iPhone6      = "iPhone 6"
    case iPhone6s     = "iPhone 6s"
    case iPhone6sPlus = "iPhone 6s Plus"
    case iPhoneSE     = "iPhone SE"
    case iPhone7      = "iPhone 7"
    case iPhone7plus  = "iPhone 7 Plus"
    case iPhone8      = "iPhone 8"
    case iPhone8Plus  = "iPhone 8 Plus"
    case iPhoneX      = "iPhone X"
    case iPhoneXr     = "iPhone Xr"
    case iPhoneXs     = "iPhone Xs"
    case iPhoneXsMax  = "iPhone Xs Max"
    // iPod
    case iPodTouch1 = "iPod touch"
    case iPodTouch2 = "iPod touch (2nd generation)"
    case iPodTouch3 = "iPod touch (3rd generation)"
    case iPodTouch4 = "iPod touch (4th generation)"
    case iPodTouch5 = "iPod touch (5th generation)"
    case iPodTouch6 = "iPod touch (6th generation)"
    case iPodTouch7 = "iPod touch (7th generation)"
    // iPad mini
    case iPadMini1 = "iPad mini"
    case iPadMini2 = "iPad mini 2"
    case iPadMini3 = "iPad mini 3"
    case iPadMini4 = "iPad mini 4"
    case iPadMini5 = "iPad mini (5th generation)"
    // iPad Series
    case iPad1 = "iPad"
    case iPad2 = "iPad 2"
    case iPad3 = "iPad (3rd generation)"
    case iPad4 = "iPad (4th generation)"
    case iPad5 = "iPad (5th generation)"
    case iPad6 = "iPad (6th generation)"
    case iPadPro_9Inch   = "iPad Pro (9.7-inch)"
    case iPadPro_10Inch  = "iPad Pro (10.5-inch)"
    case iPadPro_11Inch  = "iPad Pro (11-inch)"
    case iPadPro_12Inch1 = "iPad Pro (12.9-inch)"
    case iPadPro_12Inch2 = "iPad Pro (12.9-inch) (2nd generation)"
    case iPadPro_12Inch3 = "iPad Pro (12.9-inch) (3rd generation)"
    case iPadAir1 = "iPad Air"
    case iPadAir2 = "iPad Air 2"
    case iPadAir3 = "iPad Air (3rd generation)"
    // Apple Watch
    case appleWatch  = "Apple Watch (1st generation)"
    case appleWatch1 = "Apple Watch Series 1"
    case appleWatch2 = "Apple Watch Series 2"
    case appleWatch3 = "Apple Watch Series 3"
    case appleWatch4 = "Apple Watch Series 4"
    // Apple TV
    case appleTV2  = "Apple TV (2nd generation)"
    case appleTV3  = "Apple TV (3rd generation)"
    case appleTV4  = "Apple TV (4th generation)"
    case appleTV4K = "AppleTV6,2"
    // AirPods
    case airPods1 = "AirPods (1st generation)"
    case airPods2 = "AirPods (2nd generation)"
    // HomePod
    case homePod = "HomePod"
    // Simulator
    case simulator = "simulator"
    case newDevice = ""
}


