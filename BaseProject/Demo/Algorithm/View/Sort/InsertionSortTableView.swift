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
            self.rightBar?.barView.backgroundColor = willSelectColor
        }
        guard let _rightBar = self.rightBar else {
            return
        }
        self.transfromDown(bar: _rightBar) { [weak self] in
            guard let self = self else { return }
            if self.index > 0 {
                // 倒叙比较
                self.compare()
            } else {
                self.transfromUp(bar: _rightBar) { [weak self] in
                    guard let self = self else { return }
                    self.rightBar?.barView.backgroundColor = self.didSelectedColor
                    self.clear()
                    self.sort()
                }
            }
        }
    }

    private func compare() {
        guard let _rightBar = self.rightBar else {
            return
        }
        self.offset += 1
        if self.offset > self.index {
            self.transfromUp(bar: _rightBar) { [weak self] in
                guard let self = self else { return }
                self.clear()
                self.sort()
            }
        } else {
            let previousBar = self.barList[self.index - self.offset]
            if previousBar.number > _rightBar.number {
                self.transfromRight(leftBar: previousBar, rightBar: _rightBar) { [weak self] in
                    guard let self = self else { return }
                    self.transfromLeft(bar: _rightBar) {
                        self.compare()
                    }
                }
            } else {
                self.transfromUp(bar: _rightBar) { [weak self] in
                    guard let self = self else { return }
                    self.clear()
                    self.sort()
                }
            }
        }
    }

    override func resetData() {
        super.resetData()
        self.rightBar = nil
    }


    // MARK: ==== Tools ====
    
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
    private func transfromRight(leftBar: BarView, rightBar:BarView, block: (()->Void)?) {
        let tx = leftBar.transform.tx + leftBar.width * 2
        let ty = leftBar.transform.ty
        UIView.animate(withDuration: 0.25, animations: {
            leftBar.transform = CGAffineTransform(translationX: tx, y: ty)
        }) { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                // 交换数组中对象的位置
                let leftIndex  = self.barList.firstIndex(of: leftBar) ?? 0
                let rightIndex = self.barList.firstIndex(of: rightBar) ?? 0
                self.barList.swapAt(leftIndex, rightIndex)
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
