//
//  FindRouteUtil.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/25.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

struct FindRouteUtil {
    // 矩阵是从0开始计算的
    let matrix = 4 // 4 x 4
    var blackList = [Int]()
    var routeList = [Int]()
    let word = "hellohellohelloe"

    static func getRoute(_ index: Int) -> [Int] {
        var util = FindRouteUtil()
        util.findRoute(start: index)
        print("------黑名单有:\(util.blackList)")
        return util.routeList
    }
    
    /// 返回数字周围的至
    func nextStepList(_ num: Int) -> [Int] {
        var neighbours = [Int]()
        let left   = num - 1
        let right  = num + 1
        let top    = num - matrix
        let bottom = num + matrix
        if (left + 1)%matrix > 0, !self.blackList.contains(left), !self.routeList.contains(left) {
            neighbours.append(left)
        }
        if right%matrix > 0, !self.blackList.contains(right), !self.routeList.contains(right) {
            neighbours.append(right)
        }
        if top >= 0, !self.blackList.contains(top), !self.routeList.contains(top) {
            neighbours.append(top)
        }
        if bottom < matrix * matrix, !self.blackList.contains(bottom), !self.routeList.contains(bottom) {
            neighbours.append(bottom)
        }
        print("坐标\(num), 四周可用坐标有\(neighbours)")
        return neighbours
    }
    
    //print(nextStepList(0))
    mutating func findRoute(start index: Int) {
        print("我现在添加了坐标:\(index)")
        self.routeList.append(index)
        if routeList.count >= word.count {
            print("找齐了")
            return
        }
        let list = self.nextStepList(index)
        for nextStep in list {
            if routeList.count >= word.count {break}
            if self.nextStepList(nextStep).count > 0 {
                self.findRoute(start: nextStep)
                self.blackList.removeAll()
            } else {
                print("找错了,删除:\(index)")
                self.routeList.removeLast()
                self.blackList.append(index)
                guard let lastStep = self.routeList.last else {
                    break
                }
                print("回退到上个数字:\(lastStep)")
                self.findRoute(start: lastStep)
            }
        }
    }
}
