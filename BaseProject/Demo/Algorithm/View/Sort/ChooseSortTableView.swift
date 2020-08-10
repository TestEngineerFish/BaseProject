//
//  ChooseTableView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class ChooseSortTableView: BaseTableView {
    var minView: BarView?

    override func sort() {
        if self.minView == nil {
            self.minView = self.barList.first
        }
        self.index += 1
        if self.index >= self.barList.count {
            let leftBar  = self.barList[self.offset]
            let rightBar = self.minView!
            self.exchangeFrame(leftBar: leftBar, rightBar: rightBar) { [weak self] in
                guard let self = self else { return }
                rightBar.barView.backgroundColor = self.didSelectedColor
                self.offset += 1
                if self.offset >= self.barList.count {
                    BPLog("排序完成✅")
                } else {
                    self.index   = self.offset
                    self.minView = self.barList[self.index]
                    self.sort()
                }
            }
        } else {
            let nextView = self.barList[index]
            nextView.barView.backgroundColor = self.willSelectColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                guard let self = self else { return }
                if nextView.number < self.minView!.number {
                    nextView.barView.backgroundColor = self.didSelectedColor
                    self.minView!.barView.backgroundColor = self.normalColor
                    self.minView = nextView
                } else {
                    nextView.barView.backgroundColor = self.normalColor
                }
                self.sort()
            }
        }
    }
}
