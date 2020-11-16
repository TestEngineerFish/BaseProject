//
//  UIDevice+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit.UIDevice
import CommonCrypto
import AdSupport
import CoreTelephony

public extension UIDevice {

    /// 操作系统版本号
    static let systemOperationVersion: Double = {
        return Double(UIDevice.current.systemVersion) ?? 0.0
    }()

    /// 设备名称
    static let deviceName: String = {
        return UIDevice.current.name
    }()

    /// OS版本号
    /// - returns: e.g. "iPhone 12.2"
    static let OSVersion: String = {
        return UIDevice.current.systemName + " " + UIDevice.current.systemVersion
    }()

    /// 获取广告标识符
    /// IDFA (Identifier For Advertising)
    /** -
     * 苹果用于提供给广告商追踪用户而设定的,在同一个设备上的所有App都会取到相同的值
     * 但是IDFA并不是唯一不变的，如果用户完全重置系统（设置程序 -> 通用 -> 还原 -> 还原位置与隐私），这个广告标示符会重新生成。
     * 另外如果用户明确的还原广告（设置程序-> 通用 -> 关于本机 -> 广告 -> 还原广告标示符），那么广告标示符也会重新生成。
     * 在iOS 10.0以后如果用户打开限制广告跟踪（设置程序-> 通用 -> 关于本机 -> 广告 -> 限制广告跟踪），则获取到的IDFA为一个固定值00000000-0000-0000-0000-000000000000。
     */
    static let IDFA: String = {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }()

    /// 获取供应商标识符
    /// IDFV（Identifier For Vendor）
    /// - note: IDFV是给Vendor标识用户用的，每个设备在所属同一个Vendor的应用里，都有相同的值。
    /// 其中的Vendor是指应用提供商，准确的说，是通过BundleID的反转的前两部分进行匹配.
    /// 如果相同就是同一个Vendor，例如对于com.abc.app1, com.abc.app2 这两个BundleID来说，就属于同一个Vendor，共享同一个IDFV的值。
    /// 当然，对于同一个设备不同Vendor的话，获取到的值是不同的。
    /// 和IDFA不同的是，IDFV的值是一定能取到的。它是iOS 6中新增的
    /// 但是使用IDFV也会存在一些问题。如果用户将属于此Vendor的所有App卸载，则IDFV的值会被重置，即再重装此Vendor的App，IDFV的值也会和之前的不同。
    static let IDFV: String? = {
        guard let uuid = UIDevice.current.identifierForVendor else {
            return nil
        }
        return uuid.uuidString
    }()

    /// 获取运营商信息
    static let telephonyNetworkInfo: TelephonyNetworkInfoModel? = {
        let info = CTTelephonyNetworkInfo()
        var model: TelephonyNetworkInfoModel?
        if #available(iOS 12, *) {
            let carrierDic = info.serviceSubscriberCellularProviders
            guard let carrier = carrierDic?["0000000100000001"] else {
                return model
            }
            model = TelephonyNetworkInfoModel(info: carrier)
        } else {
            let carrierOptional = info.subscriberCellularProvider
            guard let carrier = carrierOptional else {
                return model
            }
            model = TelephonyNetworkInfoModel(info: carrier)
        }
        return model
    }()

    /// 获取网络信号强弱
    /// - parameter isWifi: true: Wifi网络 false: 移动信号网络
    /// - returns: 信号强弱, 0最低,依次递增
    static func signalStrength(with isWifi: Bool) -> Int {
        var strength = 0
        if iPhoneXLater {
            guard let statusbarDic: AnyObject = UIApplication.shared.value(forKeyPath: "statusBar") as AnyObject? else {
                return 0
            }
            guard let statusBarView: AnyObject = statusbarDic.value(forKeyPath: "statusBar") as AnyObject? else {
                return 0
            }
            guard let foregroundView = statusBarView.value(forKeyPath: "foregroundView") as? UIView else {
                return 0
            }
            guard let wifiSignalViewClass = NSClassFromString("_UIStatusBarWifiSignalView") else {
                return 0
            }
            guard let signalStringViewClass = NSClassFromString("_UIStatusBarStringView") else {
                return 0
            }
            let subviews = foregroundView.subviews[2].subviews
            for subview in subviews {
                if subview.isKind(of: wifiSignalViewClass.self) && isWifi {
                    guard let numberBars = subview.value(forKeyPath: "numberOfActiveBars") as? NSNumber else {
                        return 0
                    }
                    strength = numberBars.intValue
                    break
                }
                if subview.isKind(of: signalStringViewClass.self) && !isWifi {
                    guard let numberBars = subview.value(forKeyPath: "numberOfActiveBars") as? NSNumber else {
                        return 0
                    }
                    strength = numberBars.intValue
                    break
                }
            }
        } else {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBar") as? UIView else {
                return 0
            }
            guard let foregroundView = statusBar.value(forKeyPath: "foregroundView") as? UIView else {
                return 0
            }
            guard let wifiSignalViewClass = NSClassFromString("UIStatusBarDataNetworkItemView") else {
                return 0
            }
            guard let signalStringViewClass = NSClassFromString("UIStatusBarDataNetworkItemView") else {
                return 0
            }
            let subviews = foregroundView.subviews
            for subview in subviews {
                if subview.isKind(of: wifiSignalViewClass.self) && isReachableOnEthernetOrWiFi && isReachable && isWifi {
                    guard let numberBars = subview.value(forKeyPath: "_wifiStrengthBars") as? NSNumber else {
                        return 0
                    }
                    strength = numberBars.intValue
                    break
                }
                if subview.isKind(of: signalStringViewClass.self) && isReachableOnWWAN && isReachable && isWifi {
                    guard let numberBars = subview.value(forKeyPath: "dataNetworkType") as? NSNumber else {
                        return 0
                    }
                    strength = numberBars.intValue
                    break
                }
            }
        }
        return strength
    }

    /// 获取电池信息
    /// 获取设备IP地址

}

/// 设备运营商信息
public struct TelephonyNetworkInfoModel {
    var carrierName: String?
    var mobileCountryCode: String?
    var mobileNetworkCode: String?
    var isoCountryCode: String?
    var allowsVOIP = false

    init(info: CTCarrier) {
        carrierName       = info.carrierName
        mobileCountryCode = info.mobileCountryCode
        mobileNetworkCode = info.mobileNetworkCode
        isoCountryCode    = info.isoCountryCode
        allowsVOIP        = info.allowsVOIP
    }
}
