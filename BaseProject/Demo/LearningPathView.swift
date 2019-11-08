//
//  LearningPathView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/30.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class LearningPathView: UIScrollView {

//    var modelArray: [YXLearningPathModel] = []

    // 间距
    let margin = CGFloat(130)
    // 弧线数量
    var sectorAmount: Int
    // 剩余单元格数量
    var unitAmount: Int
    // 一个扇形上默认显示4个单元
    let sectorUnits = CGFloat(3)
    // 路径底部开始坐标
    var startPoint = CGPoint.zero
    // 控制点偏移量
    let centerOffset = CGFloat(60)
    // 单元坐标数组,从低到高
    var unitPointArray = [CGPoint]()
    // 单元视图数组,从低到高
    var unitViewArray = [UIView]()
    // 路径
    let proShapeLayer = CAShapeLayer()

    init(units amount: Int, frame: CGRect) {
        let tmpAmount = amount - 1
        sectorAmount = tmpAmount / Int(sectorUnits)
        if tmpAmount % Int(sectorUnits) > 0 {
            sectorAmount += 1
        }
        unitAmount = amount
        super.init(frame: frame)
        let h = margin * CGFloat(amount) + kNavHeight + kSafeBottomMargin
        self.contentSize          = CGSize(width: frame.width, height: h)
        self.alwaysBounceVertical = true
        self.backgroundColor      = UIColor.clear
        self.scrollsToTop         = false
        self.showsVerticalScrollIndicator   = false
        self.showsHorizontalScrollIndicator = false
        self.createSubview()
        self.setContentOffset(CGPoint(x: 0, y: h - self.height + kNavHeight), animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubview() {
        self.setLayerPath()
        self.setUnitView()
    }

    /// 设置路径
    private func setLayerPath() {
        let arcHeight  = sectorUnits * margin
        let stepShort  = margin * 1.5
        let stepLong   = arcHeight - stepShort
        let bezierPath = UIBezierPath()
        startPoint = CGPoint(x: self.contentSize.width/2, y: self.contentSize.height - 100)
        bezierPath.move(to: startPoint)
        var p0 = startPoint
        var c  = CGPoint(x: self.contentSize.width/2 + centerOffset, y: startPoint.y - stepShort)
        var p1 = CGPoint(x: startPoint.x, y: startPoint.y - sectorUnits * margin)
        // 默认添加初始坐标
        self.unitPointArray = [startPoint]
        for index in 0..<sectorAmount {
            self.appendPoints(p0: p0, c: c, p1: p1)
            bezierPath.addQuadCurve(to: p1, controlPoint: c)
            p0 = p1
            c.y -= index % 2 > 0 ? stepShort * 2 : stepLong * 2
            c.x = index % 2 > 0 ? self.contentSize.width/2 + centerOffset : self.contentSize.width/2 - centerOffset
            p1.y -= arcHeight
        }
        let totalLength = CGFloat(sectorAmount) * sectorUnits + 1
        let scaleValue  = CGFloat(self.unitAmount) / totalLength
        proShapeLayer.path        = bezierPath.cgPath
        proShapeLayer.lineWidth   = 10
        proShapeLayer.strokeColor = UIColor.hex(0xE5DDD7).cgColor
        proShapeLayer.strokeStart = 0.0
        proShapeLayer.strokeEnd   = scaleValue
        proShapeLayer.fillColor   = nil
        self.layer.addSublayer(proShapeLayer)
    }

    /// 添加单元在路径上的坐标
    private func appendPoints(p0: CGPoint, c: CGPoint, p1: CGPoint) {
        for index in 1...3 {
            if self.unitPointArray.count >= self.unitAmount {
                return
            }
            let scale = 1/3 * Float(index)
            let x = self.getX(t: scale, p0: p0, c: c, p1: p1)
            let y = self.startPoint.y - CGFloat(self.unitPointArray.count) * margin
            self.unitPointArray.append(CGPoint(x: x, y: y))
        }
    }

    /// 添加单元图形
    private func setUnitView() {
        for point in self.unitPointArray {
            let model = YXLearningPathModel()
            let sexangleView = YXSexangleView(model)
            sexangleView.center = point
            self.addSubview(sexangleView)
            self.unitViewArray.append(sexangleView)
        }
    }

    // MARK: TOOLS
   
    /// 获取一个控制点的弧形上X值
    /// - Parameters:
    ///   - scale: x点占总长度的比例
    ///   - p0: 起始点
    ///   - c  : 控制点
    ///   - p2: 终点🏁
    private func getX(t scale: Float, p0: CGPoint, c: CGPoint, p1: CGPoint) -> CGFloat {
        let t = scale
        let step0 = powf(Float(1 - t), 2.0) * Float(p0.x)
        let step1 = 2 * t * (1 - t) * Float(c.x)
        let step2 = powf(t, 2) * Float(p1.x)
        let x = step0 + step1 + step2
        return CGFloat(x)
    }

}
