//
//  BPSwiftMacro.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/4/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

// TODO: ---- Log ----
/// 记录普通操作日志
public func BPLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var message = ""
    items.forEach { (item) in
        if let itemStr = item as? String {
            message += " " + itemStr
        } else {
            message += " \(item)"
        }
    }
    BPOCLog.shared()?.eventLog(message)
}

/// 记录网络请求日志
public func BPRequestLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var message = ""
    items.forEach { (item) in
        if let itemStr = item as? String {
            message += " " + itemStr
        } else {
            message += " \(item)"
        }
    }
    BPOCLog.shared().request(message)
}

public func BPSocketLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var message = ""
    items.forEach { (item) in
        if let itemStr = item as? String {
            message += " " + itemStr
        } else {
            message += " \(item)"
        }
    }
    BPOCLog.shared().socketLog(message)
}
