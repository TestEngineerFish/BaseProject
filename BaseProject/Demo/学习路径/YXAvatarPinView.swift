//
//  YXAvatarPinView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class YXAvatarPinView: UIView {

    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createAvatarView()
        self.addAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createAvatarView() {
        self.addSubview(imageView)
        imageView.image = UIImage(named: "pin")
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(AdaptSize(36))
            make.height.equalTo(AdaptSize(42))
        }

        let avatarImageView = UIImageView(image: UIImage(named: "dogAvatar"))
        imageView.addSubview(avatarImageView)
        avatarImageView.frame = CGRect(x: 0, y: 0, width: AdaptSize(24), height: AdaptSize(24))
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(6))
            make.height.width.equalTo(AdaptSize(24))
        }
    }

    private func addAnimation() {

        // ==== 动画 ====
        // 1、摇摆动画
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        shakeAnimation.fromValue      = CGFloat.pi/8
        shakeAnimation.toValue        = -CGFloat.pi/8
        shakeAnimation.duration       = 0.5
        shakeAnimation.repeatCount    = 2.25
        shakeAnimation.autoreverses   = true
        shakeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        // 1.1、修改锚点
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.layer.add(shakeAnimation, forKey: "shakeAnimation")

        // 2、放大动画
        let zoomAnimation = CABasicAnimation(keyPath: "transform")
        zoomAnimation.fromValue = CATransform3DMakeScale(0, 0, 0)
        zoomAnimation.toValue   = CATransform3DMakeScale(1, 1, 1)
        zoomAnimation.duration    = 1
        zoomAnimation.repeatCount = 1
        zoomAnimation.fillMode    = .forwards
        zoomAnimation.isRemovedOnCompletion = true
        zoomAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        // 2.1、修改锚点
        self.imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.imageView.layer.add(zoomAnimation, forKey: nil)
    }

}
