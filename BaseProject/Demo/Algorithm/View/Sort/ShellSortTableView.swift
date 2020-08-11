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
                self.index = i * gap + self.offset
                if self.index >= self.barList.count {
                    continue
                }
                let barView = self.barList[self.index]
                barView.barView.backgroundColor = self.willSelectColor
                tmpList.append(barView)
                self.offset = tmpList.count / (self.barList.count / gap)
            }
            // 比较
            _ = tmpList.sort { (leftBar, rightBar) -> Bool in
                if leftBar.number > rightBar.number {
                    self.exchangeFrame(leftBar: leftBar, rightBar: rightBar, finished: nil)
                    return false
                } else {
                    return true
                }
            }
        }
    }
}
