//
//  BPBaseAlertView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 优先级由高到低
enum BPAlertPriorityEnum: Int {
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
    case normal = 100
}

/// AlertView的基类,默认只显示标题或者标题+描述信息
class BPBaseAlertView: BPTopWindowView {
    
    /// 弹框优先级
    var priority: BPAlertPriorityEnum = .normal
    /// 是否已展示过
    var isShowed = false
    /// 默认事件触发后自动关闭页面
    var autoClose: Bool = true
    
    /// 弹框的默认宽度
    let mainViewWidth = AdaptSize(300)
    /// 弹框的默认高度
    var mainViewHeight: CGFloat = .zero
    /// 间距
    let leftPadding: CGFloat   = AdaptSize(15)
    let rightPadding: CGFloat  = AdaptSize(15)
    let topPadding: CGFloat    = AdaptSize(20)
    let bottomPadding: CGFloat = AdaptSize(20)
    let defaultSpace: CGFloat  = AdaptSize(15)
    let buttonHeight: CGFloat  = AdaptSize(50)
    let imageViewSize: CGSize  = CGSize(width: AdaptSize(300), height: AdaptSize(500))
    let closeBtnSize: CGSize   = CGSize(width: AdaptSize(50), height: AdaptSize(50))
    
    // 标题的高度
    var titleHeight: CGFloat {
        get {
            return self.titleLabel.textHeight(width: mainViewWidth - leftPadding - rightPadding)
        }
    }
    // 描述的高度
    var descriptionHeight: CGFloat {
        get {
            return self.descriptionLabel.textHeight(width: mainViewWidth - leftPadding - rightPadding)
        }
    }
    var imageUrlStr: String?
    var leftActionBlock: DefaultBlock?
    var rightActionBlock: DefaultBlock?
    var imageActionBlock: ((String?)->Void)?
    
    // 弹框的背景
    var mainView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.white
        view.layer.cornerRadius  = AdaptSize(15)
        view.layer.masksToBounds = true
        return view
    }()

    // 弹窗标题
    var titleLabel: UILabel = {
        let label           = UILabel()
        label.numberOfLines = 1
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .center
        return label
    }()

    // 弹窗描述
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black1.withAlphaComponent(0.5)
        label.font = UIFont.regularFont(ofSize: AdaptSize(16))
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    // 左边按钮
    var leftButton: BPButton = {
        let button = BPButton(animation: false)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.gray3), for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font    = UIFont.mediumFont(ofSize: AdaptSize(18))
        button.layer.cornerRadius  = 10
        return button
    }()

    // 右边按钮
    var rightButton: BPButton = {
        let button = BPButton(animation: false)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font    = UIFont.mediumFont(ofSize: AdaptSize(18))
        button.layer.cornerRadius  = 10
        return button
    }()

    // 关闭按钮
    var closeButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.close1.rawValue, for: .normal)
        button.setTitleColor(UIColor.black1.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(40))
        button.isHidden = true
        button.backgroundColor = UIColor.clear
        return button
    }()

    // 图片
    var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius       = AdaptSize(15)
        imageView.layer.masksToBounds      = true
        return imageView
    }()
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(mainView)
    }
    
    override func bindProperty() {
        super.bindProperty()
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(closeAction))
        let tapImage      = UITapGestureRecognizer(target: self, action: #selector(clickImageAction))
        self.backgroundView.addGestureRecognizer(tapBackground)
        self.imageView.addGestureRecognizer(tapImage)
        self.leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        self.closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    
    override func show() {
        super.show()
        self.mainView.layer.addJellyAnimation()
    }

    @objc func leftAction() {
        self.leftActionBlock?()
        if autoClose {
            self.closeAction()
        }
    }

    @objc func rightAction() {
        self.rightActionBlock?()
        if autoClose {
            self.closeAction()
        }
    }
    
    @objc func clickImageAction() {
        self.imageActionBlock?(self.imageUrlStr)
        if autoClose {
            self.closeAction()
        }
    }
    
    @objc override func closeAction() {
        self.mainView.removeFromSuperview()
        super.closeAction()
    }
}
