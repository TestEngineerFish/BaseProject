//
//  BPTopWindowView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import SnapKit

class BPTopWindowView: UIView {

    // 弹框中描述文字高度
    var descriptionHeight: CGFloat = 0.0

    // 全屏透明背景
    lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth, height: kScreenHeight)))
        view.backgroundColor = UIColor.orange
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBtnAction))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

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
    var leftButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.gray3), for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font    = UIFont.mediumFont(ofSize: 18)
        button.layer.cornerRadius  = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        return button
    }()

    // 右边按钮
    var rightButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.green1), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font    = UIFont.mediumFont(ofSize: 18)
        button.layer.cornerRadius  = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        return button
    }()

    // 右上角的关闭按钮
    var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle(Iconfont.close.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: 26)
//        button.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth, height: kScreenHeight)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        var viewHeight: CGFloat = 110
        self.addSubview(backgroundView)
        self.addSubview(containerView)

        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(viewHeight + descriptionHeight)
        }

        containerView.addSubview(descriptionLabel)
        containerView.addSubview(rightButton)
        containerView.addSubview(closeButton)

        // 是否显示标题
        if let title = titleLabel.text, title.isNotEmpty {
            containerView.addSubview(titleLabel)
            viewHeight = 156.0
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(18)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(22)
            }

            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(18)
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(descriptionHeight)
            }
            
            containerView.snp.updateConstraints { (make) in
                make.height.equalTo(viewHeight + descriptionHeight)
            }
        } else {
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(18)
                make.left.equalToSuperview().offset(15)
                make.right.equalTo(-15)
                make.height.equalTo(descriptionHeight)
            }
        }

        // 是否显示左边按钮
        if let leftBtnTitle = leftButton.titleLabel?.text, leftBtnTitle.isNotEmpty {
            containerView.addSubview(leftButton)
            leftButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-18)
                make.left.equalToSuperview().offset(15)
                make.right.equalTo(containerView.snp.centerX).offset(-8)
                make.height.equalTo(56)
            }
            rightButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-18)
                make.left.equalTo(containerView.snp.centerX).offset(8)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(56)
            }
        } else {
            rightButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-18)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(56)
            }
        }
    }

    @objc func leftBtnAction() {
        self.removeFromSuperview()
    }

    @objc func rightBtnAction() {
        self.removeFromSuperview()
    }

    @objc func closeBtnAction() {
        self.removeFromSuperview()
    }
}
