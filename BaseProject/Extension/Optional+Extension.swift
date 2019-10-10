//
//  Optional+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit

public extension Optional where Wrapped: Collection {

    /// 是否为空
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

//    func matching(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
//        guard let value = self, predicate(value) else { return nil }
//        return value
//    }
}

extension Optional where Wrapped == UIView {

    /// 判断当前View是否为空,不为空则返回当前View,为空则赋值参数中的新View
    /// - Parameter expression: 新View对象
    mutating func get<T: UIView>(orSet expression: @autoclosure () -> T) ->T {
        guard let view = self as? T else {
            let newView = expression()
            self = newView
            return newView
        }
        return view
    }
}

extension Optional where Wrapped == Timer {
    var isValid: Bool {
        return self?.isValid ?? false
    }
}
