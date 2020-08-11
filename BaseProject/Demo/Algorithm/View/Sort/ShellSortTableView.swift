//
//  ShellSortTableView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/11.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class ShellSortTableView: BaseTableView {
    let gapList = [5, 3, 1]

    override func sort() {
        for gap in gapList {
            var tmpList = [BarView]()
            for i in 0..<gap {
                self.index = i * gap + i
                let barView = self.barList[self.index]
                tmpList.append(barView)
            }
            // 移出
            tmpList.forEach { (barView) in
                self.transfromDown(bar: barView) {
                    // 比较
                    
                }
            }

            // 交换位置
            // 插入
        }
    }
}
