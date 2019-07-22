//
//  YYGlobalMacro.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit



public func _yy_dispatch_sync_on_main_queue(_ block: () -> Void) {
    if Thread.isMainThread {
        block()
    }else{
        DispatchQueue.main.sync {
            block()
        }
    }
}

//MARK: 颜色快捷设置相关函数
public func ColorWithRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor.make(red: red, green: green, blue: blue, alpha: alpha)
}

public func ColorWithHexRGBA(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor.make(hex: hex, alpha: alpha)
}

//MARK: UIImage快捷设置相关函数
public func UIImageNamed(_ imageName: String) -> UIImage? {
    return UIImage(named: imageName)
}

/*屏幕宽*/
public let kScreenWidth: CGFloat = UIScreen.width

/**屏幕高*/
public let kScreenHeight: CGFloat = UIScreen.height

public let screenScale: CGFloat = UIScreen.screenScale

public let kWindow = UIApplication.shared.keyWindow

//MARK: **************** 颜色值 **********************
@objc public extension UIColor {

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

    /// 黄色（视频裁剪拖动矿颜色） (red: 255, green: 219, blue: 8) */
    static let yellow1 = ColorWithRGBA(red: 255, green: 219, blue: 8)

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

    /** 主色蓝 (red: 0, green: 122, blue: 255) */
    static let blue1 = ColorWithRGBA(red: 0, green: 122, blue: 255)

    /** 男 (red: 106, green: 169, blue: 250) */
    static let blue2 = ColorWithRGBA(red: 106, green: 169, blue: 250)

    /** qq (red: 16, green: 174, blue: 255) */
    static let blue3 = ColorWithRGBA(red: 16, green: 174, blue: 255)

    /** qq 空间底色 (red: 255, green: 190, blue: 0) */
    static let orange1 = ColorWithRGBA(red: 255, green: 190, blue: 0)

}

public let iPhoneXLater: Bool = {
    return YYDeviceModel.iPhoneXLater_Device
}()

public let iPhone4: Bool = {
    return YYDeviceModel.iPhone4_Device
}()

public let iPhone5: Bool = {
    return YYDeviceModel.iPhone5_Device
}()

public let iPhone6: Bool = {
    return YYDeviceModel.iPhone6_Device
}()

public let iPhone6p: Bool = {
    return YYDeviceModel.iPhone6p_Device
}()

public let iPhone6p_MIN: Bool = {
    return YYDeviceModel.iPhone6p_MIN_Device
}()

public let iPhoneX: Bool = {
    return YYDeviceModel.iPhoneX_Device
}()

public let iPhoneXS: Bool = {
    return YYDeviceModel.iPhoneXS_Device
}()

public let iPhoneXS_MAX: Bool = {
    return YYDeviceModel.iPhoneXS_MAX_Device
}()

public let iPhoneXR: Bool = {
    return YYDeviceModel.iPhoneXR_Device
}()

@objc public class YYDeviceModel: NSObject {
    @objc public static let iPhone4_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 640, height: 960)
    }()

    @objc public static let iPhone5_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 640, height: 1136)
    }()

    @objc public static let iPhone6_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 750, height: 1134)
    }()

    @objc public static let iPhone6p_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1242, height: 2208)
    }()

    @objc public static let iPhone6p_MIN_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1125, height: 2001)
    }()

    @objc public static let iPhoneX_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1125, height: 2436)
    }()

    @objc public static let iPhoneXS_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1125, height: 2436)
    }()

    @objc public static let iPhoneXS_MAX_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 1242, height: 2688)
    }()

    @objc public static let iPhoneXR_Device: Bool = {
        guard let _currentModeSize = UIScreen.main.currentMode?.size else {
            return false
        }
        return _currentModeSize == CGSize(width: 828, height: 1792)
    }()

    @objc public static let iPhoneXLater_Device: Bool = {
        return (iPhoneX || iPhoneXS || iPhoneXS_MAX || iPhoneXR)
    }()
}
//MARK: *************************** 屏幕尺寸判断  ******************/


/************************* 状态栏高度 *****************/
public let statusBar_Height: CGFloat = {

    return UIApplication.shared.statusBarFrame.size.height
}()

/************************* 导航栏高度 *****************/
//public let navigationBar_Height: CGFloat = 44.0

/************************* TabBar高度 *****************/
public let tabBar_Height: CGFloat = 51.0
public let newTabBar_Height: CGFloat = iPhoneXLater ? 85.0 : 51.0

/******************* 为适配iPHONEX以后设备 底部安全区域  ************/
public let bottom_Home_Safe_Area_Height: CGFloat = {
    return iPhoneXLater ? 34.0 : 0.0
}()

/** 状态栏 + 导航栏 的高度 */
//public let statusBar_NavigationBar_Height: CGFloat = 85.0


/**
 * 内容页面离顶部的导航栏的距离（ 85是自定义【导航栏+状态栏】的高度 ）
 * 当导航栏设置为透明时，Y轴是从0开始，因此需要偏移 85个像素
 * 当导航栏设置为不透明时，Y轴是从85开始，不需要偏移
 */
class YYConstants: NSObject {
    // 二级界面使用
    @objc public static let contentView_TopOffset: CGFloat = iPhoneXLater ? 88 : 64

    // 只在三个tab的一级界面使用， 其他的不能用
    @objc public static let largeNavigationBarBottom: CGFloat = iPhoneXLater ? 85 + 14 : 85
}

func transformUserDefault(for orgKey: String) -> String {
    return String(format: "%ld_%@", YYUserModel.currentUserID(), orgKey)
}
