//
//  YYCache.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/**
 * 全局统一缓存数据管理器
 */
struct YYCache {
    
    static func set(_ object: Any?, forKey: String) {
        UserDefaults.standard.archive(object: object, forkey: forKey)
    }
    
    static func object(forKey: String) -> Any? {
        return UserDefaults.standard.unarchivedObject(forkey:forKey)
    }
    
    
    static func remove(forKey: String) {
        return set(nil, forKey: forKey)
    }
    
}
