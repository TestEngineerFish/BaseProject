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
        case .choose:
            return ChooseTableView(type: type, frame: rect)
        default:
            return BubbleTableView(type: type, frame: rect)
        }
    }
}

struct AlgorithmModelManager {
    static let share = AlgorithmModelManager()

    func numberList(random: Bool) -> [CGFloat] {
        if !random, let data = BPCacheManager.object(forKey: .algorithmData) as? Data, let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [CGFloat] {
            return list
        } else {
            var list = [CGFloat]()
            for _ in 0...10 {
                list.append(CGFloat.random(in: 0...10))
            }
            let data = NSKeyedArchiver.archivedData(withRootObject: list)
            BPCacheManager.set(data, forKey: .algorithmData)
            return list
        }
    }
}
