//
//  ViewController2.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        self.view.layer.setGradient(colors: [UIColor.green1, UIColor.yellow1, UIColor.orange1], direction: .leftTop)
        let imageView = UIImageView(image: UIImage(named: "dog"))
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        let learningPath = LearningProgressView(units: 14, frame: self.view.bounds)
//        self.view.addSubview(learningPath)
//        learningPath.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.hidesBottomBarWhenPushed = true
        let vc = YXLearningPathViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
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

        print(backPath.points())
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
