//
//  BPGlobalFunction.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/7.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

public func AdaptSize(_ size: CGFloat) -> CGFloat {
    let scale = kScreenWidth / 375
    return scale * size
}
