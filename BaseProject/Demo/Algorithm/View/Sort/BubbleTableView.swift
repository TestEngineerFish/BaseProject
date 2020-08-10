//
//  BubbleTableView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/9.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BubbleTableView: BaseTableView {
    
    override func sort() {
        super.sort()
        if index + 1 >= self.barList.count {
            index = 0
        }
        let leftBar  = self.barList[index]
        let rightBar = self.barList[index + 1]
        if leftBar.number > rightBar.number {
            self.offset = 0
            let originColor  = leftBar.barView.backgroundColor
            leftBar.barView.backgroundColor  = didSelectedColor
            rightBar.barView.backgroundColor = didSelectedColor

            self.exchangeFrame(leftBar: leftBar, rightBar: rightBar) { [weak self] in
                guard let self = self else { return }
                leftBar.barView.backgroundColor  = originColor
                rightBar.barView.backgroundColor = originColor
                self.index += 1
                self.sort()
            }
        } else {
            self.index  += 1
            self.offset += 1
            if self.offset < self.barList.count {
                self.sort()
            } else {
                BPLog("排序完成✅")
            }
        }
    }
}
