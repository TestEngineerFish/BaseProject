//
//  TableFactoryManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/9.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

struct TableFactoryManager {
    static let share = TableFactoryManager()
    
    func createTableView(type: AlgorithmType, frame rect: CGRect) -> BaseTableView {
        switch type {
            case .bubble:
                return BubbleTableView(type: type, frame: rect)
            default:
                return BubbleTableView(type: type, frame: rect)
        }
    }
}
