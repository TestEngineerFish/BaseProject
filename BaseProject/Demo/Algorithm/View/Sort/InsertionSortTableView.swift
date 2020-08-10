//
//  InsertionSortTableView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class InsertionSortTableView: BaseTableView {
    override func sort() {
        if self.index >= self.barList.count {
            BPLog("排序完成✅")
            return
        }
        BPLog("Index:", index)
        let rightBar = self.barList[index]
        rightBar.barView.backgroundColor = willSelectColor
        // 移出
        self.transform(bar: rightBar, x: 0, y: self.height / 2) { [weak self] in
            guard let self = self else { return }
            if self.index > 0 {
                for _offset in 1...self.index {
                    let priviousBar = self.barList[self.index - _offset]
                    if priviousBar.number > rightBar.number {
                        self.transform(bar: priviousBar, x: priviousBar.width * 2, y: 0) { [weak self] in
                            guard let self = self else { return }
                            self.transform(bar: rightBar, x: -priviousBar.width * 2, y: 0, block: nil)
                            // 匹配到了第一个后
                            if _offset == self.index {
                                // 插入
                                self.transform(bar: rightBar, x: 0, y: 0) { [weak self] in
                                    guard let self = self else { return }
                                    rightBar.barView.backgroundColor = self.didSelectedColor
                                    self.index += 1
                                    BPLog("当前Index：", self.index)
                                    self.sort()
                                }
                            }
                        }
                    } else {
                        // 插入
                        self.transform(bar: rightBar, x: 0, y: 0) { [weak self] in
                            guard let self = self else { return }
                            rightBar.barView.backgroundColor = self.didSelectedColor
                            self.index += 1
                            BPLog("当前Index：", self.index)
                            self.sort()
                        }
                        break
                    }
                }
//                self.sort()
            } else {
                // 插入
                self.transform(bar: rightBar, x: 0, y: 0) { [weak self] in
                    guard let self = self else { return }
                    rightBar.barView.backgroundColor = self.didSelectedColor
                    self.index += 1
                    self.sort()
                }
            }
        }
    }

    private func transform(bar: BarView, x: CGFloat, y: CGFloat, block: (()->Void)?) {
        let tx = bar.transform.tx + x
        let ty = bar.transform.ty + y
        UIView.animate(withDuration: 0.25, animations: {
            bar.transform = CGAffineTransform(translationX: tx, y: ty)
        }) { (finished) in
            if finished {
                block?()
            }
        }
    }
}
