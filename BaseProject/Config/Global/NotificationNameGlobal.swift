//
//  NotificationNameGlobal.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/24.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

/// 通知名称的宏定义
public struct NotificationNameGlobal {
    static let kLoginStatusExpired             = "kLoginStatusExpired"
    static let kUserAccountHasBeenBlocked      = "UserAccountHasBeenBlocked"
    static let kUserInfoHasBeenBlocked         = "UserInfoHasBeenBlocked"
    static let kUserAvatarInfoHasBeenBlocked   = "UserAvatarInfoHasBeenBlocked"
    static let kUserNicknameInfoHasBeenBlocked = "UserNicknameInfoHasBeenBlocked"

    static let kNetworkNotification = Notification.Name("kNetworkNotification") // 网络状态变化
}
