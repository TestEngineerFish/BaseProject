//
//  BPTabBar.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 自定义设置底部TabBar中间按钮
class BPCenterTabBar: UITabBar {

    /// 按钮后的白色背景
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = 30
        return view
    }()

    /// 按钮的渐变背景
    let buttonBgView: UIView = {
        let view     = UIView()
        view.width   = CGFloat(50)
        view.height  = CGFloat(50)
        view.layer.setGradient(colors: [UIColor.hex(0x1BDFAC), UIColor.hex(0x15D558)], direction: .vertical)
        view.layer.cornerRadius = view.height/2
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()

    /// 按钮上的“+”
    let publishLabel: UILabel = {
        let label    = UILabel()
        let width    = CGFloat(30)
        let height   = CGFloat(30)
        label.text   = IconFont.publis.rawValue
        label.font   = UIFont.iconFont(size: 30)
        label.textColor = UIColor.white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 添加中间按钮
        addSubview(backgroundView)
        addSubview(buttonBgView)
        addSubview(publishLabel)
        // 添加约束
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        buttonBgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-5)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        publishLabel.snp.makeConstraints { (make) in
            make.center.equalTo(buttonBgView)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        self.addBezierPath()
    }

    /// 添加贝塞尔曲线
    func addBezierPath() {
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: (kScreenWidth - 50)/2 + 2, y: 0))
        path.addArc(withCenter: CGPoint(x: kScreenWidth/2, y: 20), radius: 30, startAngle: CGFloat.pi * 1.25, endAngle: CGFloat.pi * 1.76, clockwise: true)
        path.addLine(to: CGPoint(x: kScreenWidth, y: 0))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.withAlphaComponent(0.16).cgColor
        self.layer.addSublayer(shapeLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 处理超出TabBar区域的点击事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isHidden {
            let touchPoint = self.buttonBgView.convert(point, from: self)
            if self.buttonBgView.bounds.contains(touchPoint) {
                return self.buttonBgView
            }
        }
        return super.hitTest(point, with: event)
    }
}
