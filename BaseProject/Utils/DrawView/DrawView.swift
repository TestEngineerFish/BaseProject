//
//  DrawView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/14.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class DrawView: BPView {

    /// 笔触宽度
    var lineWidth: CGFloat = 10
    /// 笔触颜色
    var drawColor: UIColor = .orange1
    /// 页面背景图片
    var backgroundImage: UIImage?
    /// 添加的图片默认大小
    var imageRect: CGRect = .zero
    /// 笔触路径
    var drawPath: CGMutablePath?
    /// 笔触历史路径
    var drawPathArray: [BPDrawPath] = []
    /// 路径是否被释放
    var pathReleased: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()

    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .white
        let imageSize  = CGSize(width: AdaptSize(50), height: AdaptSize(50))
        let originX    = (self.width - imageSize.width)/2
        let originY    = (self.height - imageSize.height)/2
        self.imageRect = CGRect(x: originX, y: originY, width: imageSize.width, height: imageSize.height)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        self.drawView(context: context)
    }

    // MARK: ==== TouchEvent ====
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _touch = touches.first else {
            return
        }
        let point = _touch.location(in: self)
        BPLog("开始位置：\(point)")
        self.drawPath     = CGMutablePath()
        self.pathReleased = false
        // 移动到初始位置
        self.drawPath?.move(to: point)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _touch = touches.first else {
            return
        }
        let point = _touch.location(in: self)
        BPLog("移动位置：\(point)")
        self.drawPath?.addLine(to: point)
        self.setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let drawPath = self.drawPath, let _touch = touches.first else {
            return
        }
        let point = _touch.location(in: self)
        BPLog("最后位置：\(point)")
        let path = BPDrawPath(path: drawPath, color: self.drawColor, line: self.lineWidth)
        self.drawPathArray.append(path)
        // 已添加
        self.pathReleased = true
        self.lineWidth = CGFloat(arc4random() % 20) + 1.0
    }

    // MARK: ==== Event ====
    /// 撤回
    func undoStep() {

    }

    /// 清屏
    func clearScreen() {

    }

    private func drawView(context: CGContext) {
        guard let currentPath = self.drawPath else {
            return
        }
        // 先将之前的路径全部绘制出来
        for path in self.drawPathArray {
            if path.image == nil {
                context.addPath(path.drawPath.cgPath)
                path.drawColor.set()
                context.setLineWidth(path.lineWidth)
                context.setLineCap(.round)
                context.drawPath(using: .stroke)
            } else {
                // 绘制图片到画布上（如可移动图片，不应采取此方法）
                path.image?.draw(in: imageRect)
            }
        }

        // 如果释放了，则不再绘制
        guard !self.pathReleased else {
            return
        }

        // 添加路径
        context.addPath(currentPath)
        // 设置上下文属性
        self.drawColor.set()
        context.setLineWidth(self.lineWidth)
        context.setLineCap(.round)
        // 绘制路径
        context.drawPath(using: .stroke)
    }

}
