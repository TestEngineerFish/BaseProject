//
//  BubbleTableView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/9.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BubbleTableView: TableView {
    
    override func sort() {
        super.sort()
        if offset + 1 >= self.barList.count {
            offset = 0
        }
        let leftBar  = self.barList[offset]
        let rightBar = self.barList[offset + 1]
        if leftBar.number > rightBar.number {
            self.skipCount = 0
            self.exchangeFrame(leftBar: leftBar, rightBar: rightBar) { [weak self] in
                guard let self = self else { return }
                self.offset += 1
                self.sort()
            }
        } else {
            self.offset    += 1
            self.skipCount += 1
            if self.skipCount < self.barList.count {
                self.sort()
            } else {
                BPLog("排序完成✅")
            }
        }
    }
}
