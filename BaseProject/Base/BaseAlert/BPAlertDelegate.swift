//
//  BPAlertDelegate.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/21.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation


protocol BPAlertDelegate {
    func show()
    func closedAction()
    func getPriority() -> BPAlertPriorityEnum
    func isShowed() -> Bool
}
