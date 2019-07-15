//
//  UIScreen+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen {

    static let size: CGSize = {
        return UIScreen.main.bounds.size
    }()

    static let width: CGFloat = {
        return UIScreen.size.width
    }()

    static let height: CGFloat = {
        return UIScreen.size.height
    }()

    static let screenScale: CGFloat = {
        return UIScreen.main.scale
    }()
}
