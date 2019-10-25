//
//  ViewController2.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    let diameter = CGFloat(300)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red1
        self.view.layer.setGradient(colors: [UIColor.green1, UIColor.yellow1, UIColor.orange1], direction: .leftTop)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let sexangle = self.makeSexangle(diameter)
        self.view.addSubview(sexangle)
        sexangle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: diameter, height: diameter))
        }
    }

    private func makeSexangle(_ diameter: CGFloat) -> UIView {
        let view = UIView()
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint(x: diameter/3, y: 0))
        backPath.addLine(to: CGPoint(x: diameter*2/3, y: 0))
        backPath.addLine(to: CGPoint(x: diameter, y: diameter/3))
        backPath.addLine(to: CGPoint(x: diameter, y: diameter*2/3))
        backPath.addLine(to: CGPoint(x: diameter*2/3, y: diameter))
        backPath.addLine(to: CGPoint(x: diameter/3, y: diameter))
        backPath.addLine(to: CGPoint(x: 0, y: diameter*2/3))
        backPath.addLine(to: CGPoint(x: 0, y: diameter/3))
        backPath.addLine(to: CGPoint(x: diameter/3, y: 0))
        let progressPath = UIBezierPath()
        progressPath.move(to: CGPoint(x: diameter/3, y: 0))
        progressPath.addLine(to: CGPoint(x: diameter*2/3, y: 0))
        progressPath.addLine(to: CGPoint(x: diameter, y: diameter/3))
        progressPath.addLine(to: CGPoint(x: diameter, y: diameter*2/3))
        progressPath.addLine(to: CGPoint(x: diameter*2/3, y: diameter))
        progressPath.addLine(to: CGPoint(x: diameter/3, y: diameter))
        progressPath.addLine(to: CGPoint(x: 0, y: diameter*2/3))
        progressPath.addLine(to: CGPoint(x: 0, y: diameter/3))
        progressPath.addLine(to: CGPoint(x: diameter/3, y: 0))

        let backShapeLayer = CAShapeLayer()
        backShapeLayer.path = backPath.cgPath
        backShapeLayer.lineWidth = 10
        backShapeLayer.strokeColor = UIColor.gray1.cgColor
        backShapeLayer.fillColor = nil
        view.layer.addSublayer(backShapeLayer)

        let proShapeLayer = CAShapeLayer()
        proShapeLayer.path = backPath.cgPath
        proShapeLayer.lineWidth = 10
        proShapeLayer.strokeColor = UIColor.orange1.cgColor
        proShapeLayer.fillColor = nil
        view.layer.addSublayer(proShapeLayer)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue   = 1
        animation.duration  = 10
        proShapeLayer.add(animation, forKey: nil)

//        let graLayer = CAGradientLayer()
//        graLayer.frame      = CGRect(x: 0, y: 0, width: diameter, height: diameter)
//        graLayer.colors     = [UIColor.blue1.cgColor, UIColor.orange1.cgColor]
//        graLayer.startPoint = CGPoint(x: 0, y: 0)
//        graLayer.endPoint   = CGPoint(x: 1, y: 1)
//        view.layer.addSublayer(graLayer)
//        graLayer.mask = proShapeLayer
        return view
    }
}
