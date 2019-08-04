//
//  AppDelegate+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/25.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

extension AppDelegate {

    /// 添加网络变化的监听
    func monitorNetWork() {
        networkManager?.listener = { (status) in
            NotificationCenter.default.post(name: NotificationNameGlobal.kNetworkNotification, object: status)
            switch status {
            case .unknown, .notReachable:
                print("没有网络")
            case .reachable(let type):
                if type == .wwan {
                    print("手机网络")
                } else if type == .ethernetOrWiFi {
                    print("WI-FI网络")
                }
            }
        }
        networkManager?.startListening()
    }
}
