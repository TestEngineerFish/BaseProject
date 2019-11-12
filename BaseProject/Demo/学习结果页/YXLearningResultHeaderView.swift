//
//  YXLearningResultHeaderView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

struct YXLearingResultModel {
    var star: Int
    var unitStr: String
    var newLearn: Int
    var review: Int
    var unlockUnit: String?

}

class YXLearningResultHeaderView: UIView {

    var model: YXLearingResultModel

    var firstStar  = UIImageView()
    var secondStar = UIImageView()
    var thirdStar  = UIImageView()

    init(_ model:YXLearingResultModel) {
        self.model = model
        super.init(frame: CGRect.zero)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {

        // 松鼠头像
        let imageView = UIImageView()
        imageView.image = UIImage(named: "learnResult\(model.star)")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(AdaptSize(223))
            make.height.equalTo(AdaptSize(109))
        }
        // 星星
        firstStar.image  = UIImage(named: "star_enable")
        secondStar.image = UIImage(named: "star_enable")
        if model.star > 1 {
            secondStar.image = UIImage(named: "star_enable")
        }
        thirdStar.image = UIImage(named: "star_enable")
        if model.star > 1 {
            thirdStar.image = UIImage(named: "star_enable")
        }
        firstStar.isHidden  = true
        secondStar.isHidden = true
        thirdStar.isHidden  = true
        self.addSubview(firstStar)
        self.addSubview(secondStar)
        self.addSubview(thirdStar)
        secondStar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView)
            make.width.height.equalTo(35)
        }
        firstStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(secondStar)
            make.right.equalTo(secondStar.snp.left)
            make.width.height.equalTo(27)
        }
        thirdStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(secondStar)
            make.left.equalTo(secondStar.snp.right)
            make.height.width.equalTo(27)
        }

        // 文本
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        let titleText = "恭喜完成 \(model.unitStr) 的学习!"
        let titleMutAttrStr = NSMutableAttributedString(string: titleText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x323232), NSAttributedString.Key.font:UIFont.regularFont(ofSize: 17)])
        titleMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.mediumFont(ofSize: 17)], range: NSRange(location: 5, length: titleText.count - 5))
        titleLabel.attributedText = titleMutAttrStr

        let newLearnLabel = UILabel()
        newLearnLabel.textAlignment = .left
        let newLearnText = "• 新掌握了 \(model.newLearn) 个单词"
        let newLearnMutAttrStr = NSMutableAttributedString(string: newLearnText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x888888), NSAttributedString.Key.font:UIFont.regularFont(ofSize: 14)])
        newLearnMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.mediumFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.hex(0xFBA217)], range: NSRange(location: 7, length: newLearnText.count - 11))
        newLearnLabel.attributedText = newLearnMutAttrStr

        let reviewLabel = UILabel()
        reviewLabel.textAlignment = .left
        let reviewText = "• 巩固了 \(model.review) 个单词"
        let reViewMutAttrStr = NSMutableAttributedString(string: reviewText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x888888), NSAttributedString.Key.font:UIFont.regularFont(ofSize: 14)])
        reViewMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.mediumFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.hex(0xFBA217)], range: NSRange(location: 6, length: reviewText.count - 10))
        reviewLabel.attributedText = reViewMutAttrStr

        self.addSubview(titleLabel)
        self.addSubview(newLearnLabel)
        self.addSubview(reviewLabel)


        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(11)
            make.height.equalTo(24)
            make.width.equalToSuperview()
        }

        newLearnLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(self.snp.centerX).offset(AdaptSize(-60))
            make.width.equalTo(titleLabel)
            make.height.equalTo(20)
        }

        reviewLabel.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(newLearnLabel)
            make.top.equalTo(newLearnLabel.snp.bottom).offset(2)
        }

        // 如果有扩展单元解锁
        if let _unlockUnit = model.unlockUnit {
            let unlockLabel = UILabel()
            unlockLabel.textAlignment = .left
            let unlockText = "• 解锁了 " + _unlockUnit
            let unlockMutAttrStr = NSMutableAttributedString(string: unlockText, attributes: [NSAttributedString.Key.foregroundColor : UIColor.hex(0x888888), NSAttributedString.Key.font:UIFont.regularFont(ofSize: 14)])
            unlockMutAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.mediumFont(ofSize: 14), NSAttributedString.Key.foregroundColor:UIColor.hex(0xFBA217)], range: NSRange(location: 6, length: unlockText.count - 6))
            unlockLabel.attributedText = unlockMutAttrStr
            self.addSubview(unlockLabel)
            unlockLabel.snp.makeConstraints { (make) in
                make.left.height.width.equalTo(newLearnLabel)
                make.top.equalTo(reviewLabel.snp.bottom).offset(2)
            }
        }
        self.showAnimation()
    }

    private func showAnimation() {
        let duration = Double(0.75)
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.0, 1.2, 1.0]
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*1) {
            self.firstStar.isHidden = false
            self.firstStar.layer.add(animation, forKey: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*2) {
            self.secondStar.isHidden = false
            self.secondStar.layer.add(animation, forKey: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration*3) {
            self.thirdStar.isHidden = false
            self.thirdStar.layer.add(animation, forKey: nil)
        }
    }



}


