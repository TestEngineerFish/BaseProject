//
//  NSObject+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/12/27.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation


extension NSObject {
    func toJson() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
