//
//  YXRollNumberView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/9/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class YXRollNumberView: BPView, CAAnimationDelegate {
    var fromNumber: Int
    var toNumber: Int
    var labelList = [UILabel]()
    var timer: Timer?


    init(from: Int, to: Int, frame: CGRect) {
        self.fromNumber = from
        self.toNumber   = to
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

        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer(timeInterval: 0.2, repeats: true, block: { (timer: Timer) in
            let label: UILabel = {
                let label = UILabel()
                label.text          = "\(self.fromNumber)"
                label.textColor     = UIColor.orange1
                label.font          = UIFont.DINAlternateBold(ofSize: AdaptSize(80))
                label.textAlignment = .center
                return label
            }()
            self.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            if self.fromNumber < self.toNumber {
                self.showNumberAnimation(label: label)
            } else {
                self.showLastAnimation(label: label)
            }
            self.fromNumber += 1
            self.labelList.append(label)
            if self.fromNumber > self.toNumber {
                timer.invalidate()
            }
        })

//
    }

    // MARK: ==== Event ====

    func show() {
        RunLoop.current.add(timer!, forMode: .default)
    }

    private func showNumberAnimation(label: UILabel) {
        let scaleAnimater    = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimater.values = [0.8, 1.0, 0.8]

        let opacityAnimation    = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.0, 1.0, 0.0]

        let upAnimation       = CABasicAnimation(keyPath: "transform.translation.y")
        upAnimation.fromValue = label.frame.origin.y + AdaptSize(100)
        upAnimation.toValue   = label.frame.origin.y - AdaptSize(100)

        let animationGroup = CAAnimationGroup()
        animationGroup.animations     = [scaleAnimater, opacityAnimation, upAnimation]
        animationGroup.autoreverses   = false
        animationGroup.duration       = 0.5
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        animationGroup.delegate       = self
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards

        label.layer.add(animationGroup, forKey: "animationGroup")
    }

    private func showLastAnimation(label: UILabel) {
        let scaleAnimater    = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimater.values = [0.8, 1.0]

        let opacityAnimation    = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.0, 1.0]

        let upAnimation       = CABasicAnimation(keyPath: "transform.translation.y")
        upAnimation.fromValue = label.frame.origin.y + AdaptSize(100)
        upAnimation.toValue   = label.frame.origin.y

        let animationGroup = CAAnimationGroup()
        animationGroup.animations     = [scaleAnimater, opacityAnimation, upAnimation]
        animationGroup.autoreverses   = false
        animationGroup.duration       = 0.25
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        animationGroup.delegate       = self
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards

        label.layer.add(animationGroup, forKey: "lastAnimationGroup")
    }

    // MARK: ==== CAAnimationDelegate ====
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.labelList.first?.removeFromSuperview()
            self.labelList.removeFirst()
        }
    }

}
