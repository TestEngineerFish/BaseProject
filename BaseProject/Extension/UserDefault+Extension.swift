//
//  UserDefault+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
public extension UserDefaults {
    public subscript(key: String) -> Any? {
        get {
            return value(forKey: key) as Any
        }
        
        set {
            switch newValue {
            case let vaule as Int: set(vaule, forKey: key)
            case let value as Double: set(value, forKey: key)
            case let value as Bool: set(value, forKey: key)
            case let value as URL: set(value, forKey: key)
            case let value as NSObject: set(value, forKey: key)
            case nil: removeObject(forKey: key)
            default: assertionFailure("Invalid value type.")
            }
        }
    }
    
    fileprivate func setter(key: String, value: Any?) {
        self[key] = value
        synchronize()
    }
    
    public func hasKey(_ key: String) -> Bool {
        return nil != object(forKey: key)
    }
    
    public func archive(object: Any?, forkey key: String) {
        if let value = object {
            setter(key: key, value: NSKeyedArchiver.archivedData(withRootObject: value) as Any?)
        }else{
            removeObject(forKey: key)
        }
    }
    
    public func unarchivedObject(forkey key: String) -> Any? {
        return data(forKey:key).flatMap{
            NSKeyedUnarchiver.unarchiveObject(with: $0) as Any
        }
    }
}
