//
//  UserDefault+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
public extension UserDefaults {

    /// 下标语法,方便存储和获取 UserDefaults 值对象
    subscript(key: String) -> Data? {
        get {
            guard let data = value(forKey: key) as? Data else {
                return nil
            }
            return data
        }
        
        set {
            if let value = newValue {
                set(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
    
    func setter(_ value: Data?, forKey key: String) {
        self[key] = value
        synchronize()
    }

    /// 归档的数据中,是否有Key对应的数据
    func hasKey(_ key: String) -> Bool {
        return nil != object(forKey: key)
    }

    /// 归档数据
    func archive(object: Any?, forkey key: String) {
        if let value = object {
            var data: Data?
            // 现将数据编码, 然后存档
            if #available(iOS 11, *) {
                do {
                    data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
                } catch {
                    print("archive fail!!\n key: \(key)\n value: \(value)")
                }
            } else {
                data = NSKeyedArchiver.archivedData(withRootObject: value)
            }
            setter(data, forKey: key)
        }else{
            removeObject(forKey: key)
        }
    }

    /// 解档数据
    func unarchivedObject(forkey key: String) -> Any? {
        var value: Any?
        guard let data = data(forKey: key) else {
            return nil
        }
        // 拿到数据后需要先解码
        if #available(iOS 9, *) {
            do {
                value = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            } catch {
                print("unarchived fail!!\n key: \(key)\n")
            }
        } else {
            value = NSKeyedUnarchiver.unarchiveObject(with: data)
        }
        return value
    }
}
