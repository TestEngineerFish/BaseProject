//
//  YYTopWindowView.swift
//  YouYou
//
//  Created by sunwu on 2018/10/27.
//  Copyright © 2018 YueRen. All rights reserved.
//

import UIKit
import SnapKit

/**
 * 所有需要显示到最顶层的页面，必须继承自该View
 */
class YYTopWindowView: UIView {
    
    //
    var descriptionHeight: CGFloat = 0
    
    // MARK: - 视图相关
    // 半透明黑色背景，当弹窗没有关闭按钮时，设置 backgroundView 的 isUserInteractionEnabled 为 true，即可实现点击此半透明黑色背景关闭弹窗。
    lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeButtonAction))
        view.addGestureRecognizer(tap)
        
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // 白色背景框
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    // 弹窗标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.regularFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    // 弹窗描述
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black1.withAlphaComponent(0.5)
        label.font = UIFont.regularFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    // 弹窗左按钮
    lazy var leftButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.gray3), for: .normal)
        button.titleLabel?.font = UIFont.mediumFont(ofSize: 18)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(leftButtonAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // 弹窗右按钮或居中的唯一按钮
    lazy var rightOrTheOneButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.green1), for: .normal)
        button.titleLabel?.font = UIFont.mediumFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(rightOrTheOneButtonAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // 弹窗右上角关闭按钮
    lazy var closeButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setTitle(Iconfont.close.rawValue, for: UIControl.State.normal)
        button.setTitleColor(UIColor.black1.withAlphaComponent(0.5), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.newIconFont(size: 26)
        button.addTarget(self, action: #selector(closeButtonAction), for: UIControl.Event.touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.tag = 999
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 重写此方法以排列布局
    func setUpSubviews() {
        var shouldShowTitle = false
        if let title = titleLabel.text, title.isNotEmpty {
            shouldShowTitle = true
        }
        
        var shouldShowLeftButton = false
        if let title = leftButton.titleLabel?.text, title.isNotEmpty {
            shouldShowLeftButton = true
        }
        
        self.addSubview(backgroundView)
        self.addSubview(containerView)
        containerView.snp.makeConstraints {(make) in
            make.center.equalTo(self)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(shouldShowTitle ? 186 + descriptionHeight : 126 + descriptionHeight)
        }
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(leftButton)
        containerView.addSubview(rightOrTheOneButton)
        
        if shouldShowTitle {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(18)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(22)
            }
            
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(36)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(descriptionHeight)
            }
            
        } else {
            descriptionLabel.snp.makeConstraints { (make) in             make.top.equalToSuperview().offset(18)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(descriptionHeight)
            }
        }
        
        if shouldShowLeftButton {
            leftButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-18)
                make.left.equalToSuperview().offset(16)
                make.right.equalTo(containerView.snp.centerX).offset(-8)
                make.height.equalTo(56)
            }
            
            rightOrTheOneButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-18)
                make.left.equalTo(containerView.snp.centerX).offset(8)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(56)
            }
            
        } else {
            rightOrTheOneButton.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-18)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(56)
            }
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.width.equalTo(26)
        }
    }
    
    
    
    // MARK: - 点击事件
    // 重写此方法以设置左右按钮或者单独中间按钮的点击事件
    @objc func leftButtonAction() {}
    @objc func rightOrTheOneButtonAction() {}
    
    // 点击右上角关闭按钮；点击透明黑色背景的点击事件（当弹窗中没有右上角的关闭按钮，且 backgroundView 的 isUserInteractionEnabled 为 true 时生效）
    @objc func closeButtonAction() {
        self.removeFromSuperview()
    }
    
}
