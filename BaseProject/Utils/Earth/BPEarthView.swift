//
//  BPEarthView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BPEarthView: BPView {

    let maxItem     = 100
    var itemList    = [BPEarthItemView]()
    var bpPointList = [BPPoint]()
    var normalDirection: BPPoint = {
        let x = CGFloat(arc4random() % 10) - 5
        let y = CGFloat(arc4random() % 10) - 5
        return BPPoint(x: x, y: y, z: 0)
    }()

    var timer: CADisplayLink?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.timerStart()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()

        let p1 = CGFloat.pi * (3 - sqrt(5))
        let p2 = 2.0 / CGFloat(maxItem)

        for index in 0..<maxItem {
            let itemView = BPEarthItemView(frame: CGRect(origin: .zero, size: CGSize(width: AdaptSize(40), height: AdaptSize(20))), title: "我是\(index)")
            itemView.center = CGPoint(x: self.width/2, y: self.height/2)
            self.itemList.append(itemView)
            self.addSubview(itemView)

            // 设置坐标位置
            let y = CGFloat(index) * p2 - 1 + (p2 / 2)
            let r = sqrt(1 - pow(y, 2))
            let p3 = CGFloat(index) * p1
            let x = cos(p3) * r
            let z = sin(p3) * r

            let bpPoint = BPPoint(x: x, y: y, z: z)
            self.bpPointList.append(bpPoint)

            // 设置动画时间
            let time = Double(arc4random() % 10 + 10) / 20
            // 开始抛洒动画
            UIView.animate(withDuration: time, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.setItemView(point: bpPoint, index: index)
            }, completion: nil)
        }
    }

    override func bindProperty() {
        super.bindProperty()
    }

    // MARK: ==== Event ====
    /// 开始自动旋转
    @objc
    private func autoTurnRotation() {
        for index in 0..<self.itemList.count {
            self.updateFrame(index: index, angle: 0.002)
        }
    }

    /// 更新frame
    /// - Parameters:
    ///   - index: item的下标
    ///   - angle: 移动角度
    private func updateFrame(index: Int, angle: CGFloat) {
        let oldPoint = self.bpPointList[index]
        let newPoint = BPPointMakeRotation(oldPoint, self.normalDirection, angle)
        self.bpPointList[index] = newPoint
        self.setItemView(point: newPoint, index: index)
    }

    // MARK: ==== Tools ====

    private func timerStart() {
        self.timer = CADisplayLink(target: self, selector: #selector(self.autoTurnRotation))
        self.timer?.add(to: RunLoop.main, forMode: .default)
    }

    private func timerStop() {
        self.timer?.invalidate()
        self.timer = nil
    }

    private func setItemView(point: BPPoint, index: Int) {
        let itemView = self.itemList[index]
        let newX = (point.x + 1) * self.width / 2
        let newY = (point.y + 1) * self.width / 2
        itemView.center = CGPoint(x: newX, y: newY)

        let transform = (point.z + 2) / 3
        itemView.transform       = CGAffineTransform(scaleX: transform, y: transform)
        itemView.layer.zPosition = transform
        itemView.alpha           = transform
        if point.z < 0 {
            itemView.isUserInteractionEnabled = false
        } else {
            itemView.isUserInteractionEnabled = true
        }
    }
}
