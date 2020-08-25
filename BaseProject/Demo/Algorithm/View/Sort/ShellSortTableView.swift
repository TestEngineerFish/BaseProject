//
//  ShellSortTableView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/11.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation


class ShellSortTableView: BaseTableView {

    var gap = 0
    var groupBarList = [BarView]()

    // 插入排序，从后向前比较
    func sortGroupList(complate block: (()->Void)?) {
        self.offset -= 1
        if self.offset < 1 {
            block?()
            return
        }
        let leftBar  = groupBarList[self.offset - 1]
        let rightBar = groupBarList[self.offset]
        leftBar.barView.backgroundColor  = willSelectColor
        rightBar.barView.backgroundColor = willSelectColor
        self.transfromDown(bar: leftBar, block: nil)
        self.transfromDown(bar: rightBar) {
            if leftBar.number > rightBar.number {
                self.exchangeFrame(leftBar: leftBar, rightBar: rightBar) {
                    self.transfromUp(bar: leftBar, block: nil)
                    self.transfromUp(bar: rightBar) {
                        leftBar.barView.backgroundColor  = self.normalColor
                        rightBar.barView.backgroundColor = self.normalColor
                        self.sortGroupList(complate: block)
                    }
                }
            } else {
                self.transfromUp(bar: leftBar, block: nil)
                self.transfromUp(bar: rightBar) {
                    leftBar.barView.backgroundColor  = self.normalColor
                    rightBar.barView.backgroundColor = self.normalColor
                    self.sortGroupList(complate: block)
                }
            }
        }
    }

    override func setData() {
        super.setData()
        self.gap = self.barList.count / 2
    }

    override func sort() {
        // 查找每组需要对比的bar
        self.groupBarList = []
        while self.index < self.barList.count {
            groupBarList.append(self.barList[self.index])
            self.index += self.gap
        }
        // 对比和交换位置
        self.offset = self.groupBarList.count
//        self.groupBarList.forEach { (barView) in
//            barView.barView.backgroundColor = didSelectedColor
//        }
        self.sortGroupList {
            // 设置偏移量
            self.index += 1
            // 设置增量序列
            if self.index >= self.gap {
                self.index = 0
                self.gap = self.gap / 2
                if self.gap < 1 {
                    self.groupBarList = self.barList
                    self.sortGroupList {
                        BPLog("排序完成✅")
                    }
                    return
                }
            }
            self.sort()
        }
    }
    override func reset() {
        super.reset()
        self.gap = self.barList.count / 2
        self.groupBarList = []
    }
}
