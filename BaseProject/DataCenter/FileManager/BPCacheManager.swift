//
//  BPCacheManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

/// 设定常量值
/// - note: 1、防止多处写出错; 2、便于查询
enum BPCacheKey: String {
    /// 版本号
    case version       = "kVersion"
    /// 算法数据
    case algorithmData = "kAlgorithmData"
    /// 是否随机产生数据
    case randomData    =  "kRandomData"
}

struct BPCacheManager {

    /// 保存数据到plist文件
    ///
    /// - Parameters:
    ///   - object: 需要保存的属性
    ///   - forKey: 常量值
    static func set(_ object: Any?, forKey: BPCacheKey) {
        UserDefaults.standard.archive(object: object, forkey: forKey.rawValue)
    }

    /// 获取之前保存的数据
    ///
    /// - Parameter forKey: 常量值
    /// - Returns: 之前保存的数据,不存在则为nil
    static func object(forKey: BPCacheKey) -> Any? {
        return UserDefaults.standard.unarchivedObject(forkey:forKey.rawValue)
    }

    /// 移除保存的数据
    ///
    /// - Parameter forKey: 常量值
    static func remove(forKey: BPCacheKey) {
        return set(nil, forKey: forKey)
    }

}
