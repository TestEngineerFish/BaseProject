//
//  YYGlobal.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit

public let kSCREEN_WIDTH = UIScreen.main.bounds.size.width
public let kSCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let kStatusBarHeight:CGFloat = iPhoneXLater ? 44.0 : 20.0
public let kNavHeight:CGFloat = kStatusBarHeight + 44.0
public let kSafeBottomMargin:CGFloat = iPhoneXLater ? 34.0 : 0.0

// MARK: --- 图片后缀 ---

/** common keys */
public let YYLinkURLNameKey = "url"

/** 网络图片大小比例，w1 —— w7， 尺寸逐步变大*/
public enum YYNetworkImageScale: String {
    case w1 = "!w1"
    case w2 = "!w2"
    case w3 = "!w3"
    case w4 = "!w4"
    case w5 = "!w5"
    case w6 = "!w6"
    case w7 = "!w7"
}


public func iPhoneScale(imageScale: YYNetworkImageScale) -> YYNetworkImageScale {
    if iPhoneXLater {
        switch imageScale {
        case .w1: return .w2
        case .w2: return .w3
        case .w3: return .w4
        case .w4: return .w5
        case .w5: return .w6
        case .w6: return .w7
        case .w7: return .w7
        }
    }
    return imageScale
}

/** p1 ~ p7 图像清晰度逐渐增加 */
public let YYImageScaleURLSuffixP1 = "!p1"
public let YYImageScaleURLSuffixP2 = "!p2"
public let YYImageScaleURLSuffixP3 = "!p3"
public let YYImageScaleURLSuffixP4 = "!p4"
public let YYImageScaleURLSuffixP5 = "!p5"
public let YYImageScaleURLSuffixP6 = "!p6"
public let YYImageScaleURLSuffixP7 = "!p7"

public struct YYCacheKeyName {
    static let kLocationLatitude = "kLocationLatitude"
    static let kLocationLongitude = "kLocationLongitude"
    static let kLocationAltitude = "kLocationAltitude"

    // 位置提示显示状态
    static let kLocationTipShowStatus = "kLocationTipShowStatus"
}

public let kAppUserLoginStatus = "AppUserLoginStatus"

public let kAppGuideStatus = "AppGuideStatus"

/** 用户是否是第一次点赞成功 */
public let kUserIsFirstPraisedSuccessfuly = "userIsFirstPraisedSuccessfuly"

/** 第三方信息从哪个页面发起的 */
public let kThirdPartyInfoFromLogin = "kThirdPartyInfoFromLogin"

/** 非wifi播放状态 */
public let kNotWifiPlayVideoStatus = "kNotWifiPlayVideoStatus"


/** 通知相关 */
public struct YYNotificationCenter {
    static let kScanQRCodeFinish = "YYNotificationCenter_scanQRCodeFinish"
    static let kLoginStatusExpired = "kLoginStatusExpired"
    static let kAddFriendSuccess = Notification.Name("kAddFriendSuccess")          // 添加好友成功

    static let kRemoveFriendSuccess = Notification.Name("kRemoveFriendSuccess")      // 删除好友成功
    static let kRefreshRecommendData = Notification.Name("kRefreshRecommendData")   // 删除好友时，刷新推荐的数据
    static let kUpdateUserInfo = Notification.Name("kUpdateUserInfo")   // 设置页修改个人信息时，更新个人主页

    static let kHiddenKeyboard = Notification.Name("kHiddenKeyboard")

    static let kUserAccountHasBeenBlocked = "UserAccountHasBeenBlocked"
    static let kUserInfoHasBeenBlocked = "UserInfoHasBeenBlocked"
    static let kUserAvatarInfoHasBeenBlocked = "UserAvatarInfoHasBeenBlocked"
    static let kUserNicknameInfoHasBeenBlocked = "UserNicknameInfoHasBeenBlocked"

    static let kLikeVideoSuccess = Notification.Name("kLikeVideoSuccess") // 点赞视频成功

    static let kRemoveVideoSuccess = Notification.Name("kRemoveVideoSuccess") // 删除视频成功

    static let kNetworkNotification = Notification.Name("kNetworkNotification") // 网络状态变化
}

/** 文件存储路径或目录 */

// 存储总目录路径
public let kPathForMainStorageLocation = NSHomeDirectory() + "/Documents"

// 介绍图片文件目录路径
public let kPathForIntroducationOfImages = kPathForMainStorageLocation + "/ImagesOfIntroducation"

public let kPathForVideo = kPathForMainStorageLocation + "/VideoUpload"

// 视频背景音乐路径
public let kPathForBackgroundMusicsOfVideo = kPathForMainStorageLocation + "/BackgroundMusicsOfVideo"

// 视频贴纸路径
public let kPathForStickersOfVideo = kPathForMainStorageLocation + "/StickersOfVideo"

// 视频内容
public let kVideoCatchPath = kPathForMainStorageLocation + "/VideoCatch"
