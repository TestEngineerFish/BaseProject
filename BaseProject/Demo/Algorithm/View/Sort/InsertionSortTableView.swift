//
//  InsertionSortTableView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class InsertionSortTableView: BaseTableView {
    
    var rightBar: BarView?
    
    override func sort() {
        if self.index >= self.barList.count {
            BPLog("排序完成✅")
            return
        }
        BPLog("Index:", index)
        if rightBar == nil {
            self.rightBar = self.barList[index]
        }

        self.rightBar?.barView.backgroundColor = willSelectColor
        self.transfromDown(bar: rightBar!) {
            if self.index > 0 {
                while self.offset <= self.index {
                    let previousBar = self.barList[self.index - self.offset]
                    if previousBar.number > self.rightBar!.number {
                        self.transfromRight(bar: previousBar) {
                            self.transfromLeft(bar: self.rightBar!) {
                                self.offset += 1
                            }
                        }
                    } else {
                        self.transfromUp(bar: self.rightBar!) {
                            self.clear()
                            self.sort()
                        }
                    }
                }
                self.transfromUp(bar: self.rightBar!) {
                    self.clear()
                    self.sort()
                }
            } else {
                self.transfromUp(bar: self.rightBar!) {
                    self.rightBar?.barView.backgroundColor = self.didSelectedColor
                    self.clear()
                    self.sort()
                }
            }
        }
    }
    
    private func clear() {
        self.index += 1
        self.offset = 0
        self.rightBar?.barView.backgroundColor = didSelectedColor
        self.rightBar = nil
    }
    
    /// 左移一格
    private func transfromLeft(bar: BarView, block: (()->Void)?) {
        let tx = bar.transform.tx - bar.width * 2
        let ty = bar.transform.ty
        UIView.animate(withDuration: 0.25, animations: {
            bar.transform = CGAffineTransform(translationX: tx, y: ty)
        }) { (finished) in
            if finished {
                block?()
            }
        }
    }
    /// 右移一格
    private func transfromRight(bar: BarView, block: (()->Void)?) {
        let tx = bar.transform.tx + bar.width * 2
        let ty = bar.transform.ty
        UIView.animate(withDuration: 0.25, animations: {
            bar.transform = CGAffineTransform(translationX: tx, y: ty)
        }) { (finished) in
            if finished {
                block?()
            }
        }
    }
    /// 下移一格
    private func transfromDown(bar: BarView, block: (()->Void)?) {
        let tx = bar.transform.tx
        let ty = self.height / 2
        UIView.animate(withDuration: 0.25, animations: {
            bar.transform = CGAffineTransform(translationX: tx, y: ty)
        }) { (finished) in
            if finished {
                block?()
            }
        }
    }
    /// 上移一格
    private func transfromUp(bar: BarView, block: (()->Void)?) {
        let tx = bar.transform.tx
        let ty = 0
        UIView.animate(withDuration: 0.25, animations: {
            bar.transform = CGAffineTransform(translationX: tx, y: CGFloat(ty))
        }) { (finished) in
            if finished {
                block?()
            }
        }
    }
}
