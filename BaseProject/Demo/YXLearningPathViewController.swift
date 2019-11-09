//
//  YXLearningPathViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/7.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class YXLearningPathViewController: UIViewController {

    var backButton = UIButton()
    var leftCloud  = UIImageView()
    var rightCloud = UIImageView()

    let modelArray: [YXLearningPathModel] = {
        var array = [YXLearningPathModel]()
        for index in 0..<14 {
            var model = YXLearningPathModel()
            model.unit_id = index
            model.name = "Unit \(index + 1)"
            if index == 4 {
                model.rate = 0.8
                model.start = 0
                model.isLearned = true
                model.isLearned = false
                model.type = .uniteIng
            } else if index > 4 {
                model.rate = 0.0
                model.start = 0
                model.isLearned = false
                model.isLearned = false
                model.type = .uniteUnstart
            } else {
                model.rate = 1.0
                model.start = Int(arc4random()%4)
                model.isLearned = false
                model.isLearned = true
                model.type = .uniteEnd
            }
            array.append(model)
        }
        return array
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createSubviews()
        self.startAnimation()
    }

    private func createSubviews() {
        // 打底背景
        let bgImageView = UIImageView(image: UIImage(named: "pathBg"))
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.height.equalTo(AdaptSize(358))
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        // 学习路径
        let learningPath = LearningPathView(units: self.modelArray, frame: self.view.bounds)
        self.view.addSubview(learningPath)
        learningPath.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 返回按钮
        backButton.setImage(UIImage(named: "back"), for: .normal)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.width.height.equalTo(AdaptSize(22))
        }
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        // 左边的云
        leftCloud = UIImageView(image: UIImage(named: "cloudLeft"))
        self.view.addSubview(leftCloud)
        leftCloud.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(76))
            make.width.equalTo(AdaptSize(54))
            make.height.equalTo(AdaptSize(35))
        }
        // 右边的云
        rightCloud = UIImageView(image: UIImage(named: "cloudRight"))
        self.view.addSubview(rightCloud)
        rightCloud.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(AdaptSize(96))
            make.width.equalTo(AdaptSize(36))
            make.height.equalTo(AdaptSize(24))
        }
        // 底部的树
        let treeImageView = UIImageView(image: UIImage(named: "pathTree"))
        self.view.addSubview(treeImageView)
        treeImageView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(103))
        }
    }

    @objc private func backClick() {
        self.navigationController?.popViewController(animated: true)
    }

    // TODO: Animation

    private func startAnimation() {
        let leftAnimation = CABasicAnimation(keyPath: "position.x")
        leftAnimation.fromValue      = leftCloud.frame.origin.x
        leftAnimation.toValue        = leftCloud.frame.origin.x + 90
        leftAnimation.duration       = 8
        leftAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        leftAnimation.repeatCount    = MAXFLOAT
        leftAnimation.autoreverses   = true
        leftCloud.layer.add(leftAnimation, forKey: "leftAnimation")

        let rightAnimation = CABasicAnimation(keyPath: "position.x")
        rightAnimation.fromValue      = kScreenWidth - AdaptSize(26)
        rightAnimation.toValue        = kScreenWidth - AdaptSize(26) - AdaptSize(90)
        rightAnimation.duration       = 8
        rightAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        rightAnimation.repeatCount    = MAXFLOAT
        rightAnimation.autoreverses   = true
        rightCloud.layer.add(rightAnimation, forKey: "rightAnimation")
    }
}
