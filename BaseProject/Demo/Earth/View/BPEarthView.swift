//
//  BPEarthView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BPEarthView: BPView {

    var maxItem: Int
    var itemList    = [BPEarthItemView]()
    var bpPointList = [BPPoint]()
    var normalDirection: BPPoint = {
        let x = CGFloat(arc4random() % 10) - 5
        let y = CGFloat(arc4random() % 10) - 5
        return BPPoint(x: x, y: y, z: 0)
    }()

    private var timer: CADisplayLink?
    private var gestureTimer: CADisplayLink?
    private var lastPoint: CGPoint = .zero
    private var velocity: CGFloat  = .zero

    init(frame: CGRect, maxItem: Int) {
        self.maxItem = maxItem > 1000 ? 1000 : maxItem
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.timerStart()
    }

    deinit {
        self.timerStop()
        self.gestureStop()
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.timerStop()
        self.gestureStop()
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
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureAction(pan:)))
        self.addGestureRecognizer(pan)
    }

    // MARK: ==== Event ====
    /// 开始自动旋转
    @objc
    private func autoTurnRotation() {
        for index in 0..<self.itemList.count {
            self.updateFrame(index: index, angle: 0.002)
        }
    }

    /// 手动转转
    @objc
    private func gestureRotation() {
        if velocity <= 0 {
            self.gestureStop()
            // 开始自动旋转
            self.timerStart()
        } else {
            velocity -= 70
            let duration = CGFloat(self.gestureTimer?.duration ?? 1)
            let angle    = velocity / self.width * 2 * duration
            for index in 0..<self.itemList.count {
                self.updateFrame(index: index, angle: angle)
            }
        }
    }
    /// 处理用户滑动手势事件
    @objc
    private func handlePanGestureAction(pan:UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            self.lastPoint = pan.location(in: self)
            self.timerStop()
//            self.timerStart()
        case .changed:
            let currentPoint = pan.location(in: self)
            let direction    = BPPointMake(lastPoint.y - currentPoint.y, currentPoint.x - lastPoint.x, 0)
            // 三角函数，计算直线距离
            let sidePow  = pow(direction.x, 2) + pow(direction.y, 2)
            let distance = sqrt(sidePow)
            // 获得角度
            let angle = distance / self.width / 2

            for index in 0..<self.itemList.count {
                self.updateFrame(index: index, angle: angle)
            }

            self.normalDirection = direction
            self.lastPoint       = currentPoint
        case .ended:
            let velocityP = pan.velocity(in: self)
            let sidePow   = pow(velocityP.x, 2) + pow(velocityP.y, 2)
            self.velocity = sqrt(sidePow)
            self.gestureStart()
        default:
            return
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

    /// 自动旋转循环开始
    private func timerStart() {
        self.timer = CADisplayLink(target: self, selector: #selector(self.autoTurnRotation))
        self.timer?.add(to: RunLoop.main, forMode: .default)
    }

    /// 自动旋转循环停止
    func timerStop() {
        self.timer?.invalidate()
        self.timer = nil
    }

    /// 手势旋转循环开始
    private func gestureStart() {
        self.gestureStop()
        self.gestureTimer = CADisplayLink(target: self, selector: #selector(self.gestureRotation))
        self.gestureTimer?.add(to: RunLoop.main, forMode: .default)
    }

    /// 手势旋转循环停止
    func gestureStop() {
        self.gestureTimer?.invalidate()
        self.gestureTimer = nil
    }

    private func setItemView(point: BPPoint, index: Int) {
        let itemView = self.itemList[index]
        let newX = (point.x + 1) * self.width / 2
        let newY = (point.y + 1) * self.height / 2
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
