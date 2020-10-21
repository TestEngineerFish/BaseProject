//
//  BPBaseAlertView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// AlertView的基类,默认只显示标题或者标题+描述信息
class BPBaseAlertView: BPTopWindowView {

    // 弹框中描述文字高度
    var descriptionHeight: CGFloat = 0.0

    // 弹框的背景
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.white
        view.layer.cornerRadius  = 20
        view.layer.masksToBounds = true
        return view
    }()

    // 弹窗标题
    var titleLabel: UILabel = {
        let label           = UILabel()
        label.numberOfLines = 1
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    // 弹窗描述
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black1.withAlphaComponent(0.5)
        label.font = UIFont.regularFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    // 左边按钮
    var leftButton: BPBaseButton = {
        let button = BPBaseButton()
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.gray3), for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font    = UIFont.mediumFont(ofSize: 18)
        button.layer.cornerRadius  = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        return button
    }()

    // 右边按钮
    var rightButton: BPBaseButton = {
        let button = BPBaseButton()
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.green1), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font    = UIFont.mediumFont(ofSize: 18)
        button.layer.cornerRadius  = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        return button
    }()

    // 关闭按钮
    var closeButton: BPBaseButton = {
        let button = BPBaseButton()
        button.setTitle(IconFont.close1.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: 40)
        button.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        button.isHidden = true
        button.backgroundColor = UIColor.clear
        return button
    }()

    // 图片
    var imageView: BPBaseImageView = {
        let imageView = BPBaseImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.containerView.layer.addJellyAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(containerView)
        self.addSubview(closeButton)

        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(leftButton)
        containerView.addSubview(rightButton)
        containerView.addSubview(imageView)

        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(kScreenWidth - 60)
        }

        closeButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.top.equalTo(containerView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
    }

    @objc func leftBtnAction() {
        self.removeFromSuperview()
    }

    @objc func rightBtnAction() {
        self.removeFromSuperview()
    }
}
