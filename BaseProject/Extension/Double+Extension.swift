//
//  Double+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

public extension Double {
    func format() -> Double {
        return Double(String(format: "%.6f", self))!
    }
}
