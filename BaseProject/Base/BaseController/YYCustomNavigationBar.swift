//
//  YYCustomNavigationBar.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/**
 * 自定义导航
 */
@objc public class YYCustomNavigationBar: UIView {
    
    // MARK: ++++++++++++++++++++++++++++ Title
    /**
     * 是否为大标题
     */
    private var isLargeTitle: Bool = false
    
    /** 小标题 */
    @objc public var title: String? {
        set { self.titleLabel.text = newValue }
        get { return self.titleLabel.text }
    }
    /** 大标题 */
    @objc public var largeTitle: String? {
        set { self.setLargeTitle(newValue) }
        get { return self.largeTitleButton.title(for: .normal) }
    }
    /** 左边按钮的文案（小标题时） */
    @objc public var leftButtonTitle: String? {
        set { self.leftButton.setTitle(newValue, for: .normal) }
        get { return self.leftButton.title(for: .normal) }
    }
    /** 右边按钮的文案 */
    @objc public var rightButtonTitle: String? {
        set { self.rightButton.setTitle(newValue, for: .normal) }
        get { return self.rightButton.title(for: .normal) }
    }
    /** 右边第二按钮的文案 */
    @objc public var rightSecondButtonTitle: String? {
        set { self.rightSecondButton.setTitle(newValue, for: .normal) }
        get { return self.rightSecondButton.title(for: .normal) }
    }
    
    
    // MARK: ++++++++++++++++++++++++++++ Title Color
    /** 小标题颜色 */
    @objc public var titleColor: UIColor? {
        set { self.titleLabel.textColor = newValue }
        get { return self.titleLabel.textColor }
    }
    /** 大标题颜色 */
    @objc public var largeTitleColor: UIColor? {
        set {
            if let color = newValue {
                self.largeTitleButton.setTitleColor(color, for: .normal)
                self.largeTitleButton.setTitleColor(color.withAlphaComponent(0.5), for: .highlighted)
                self.backIconLabel.textColor = color
            }
        }
        get {
            return self.largeTitleButton.titleColor(for: .normal)
        }
    }
    /** 左边按钮的文案颜色（小标题时） */
    @objc public var leftButtonTitleColor: UIColor? {
        set { self.leftButton.setTitleColor(newValue, for: .normal) }
        get { return self.leftButton.titleColor(for: .normal) }
    }
    /** 右边按钮的文案颜色 */
    @objc public var rightButtonTitleColor: UIColor? {
        set {
            self.rightButton.setTitleColor(newValue, for: .normal)
            self.rightButton.setTitleColor((newValue ?? UIColor.clear).withAlphaComponent(0.5), for: .highlighted)
        }
        get { return self.rightButton.titleColor(for: .normal) }
    }
    /** 右边第二按钮的文案颜色 */
    @objc public var rightSecondButtonTitleColor: UIColor? {
        set {
            self.rightSecondButton.setTitleColor(newValue, for: .normal)
            self.rightSecondButton.setTitleColor((newValue ?? UIColor.clear).withAlphaComponent(0.5), for: .highlighted)
        }
        get { return self.rightSecondButton.titleColor(for: .normal) }
    }
    
    
    // MARK: ++++++++++++++++++++++++++++ Action
    
    /** 右边按钮的点击事件 */
    @objc public var leftButtonAction: (() -> Void)?
    /** 右边按钮的点击事件 */
    @objc public var rightButtonAction: (() -> Void)?
    /** 右边第二按钮的点击事件 */
    @objc public var rightSecondButtonAction: (() -> Void)?
    
    
    
    // MARK: ++++++++++++++++++++++++++++ Control
    
    /** 正常小标题 */
    @objc public lazy var titleLabel: UILabel = {
        let label = UILabel()
        //        label.font = UIFont.mediumFont(ofSize: 16)
        label.font = UIFont.regularFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.black1
        label.frame = CGRect(x: 75, y: 0, width: screenWidth - 150, height: 44)
        return label
    }()
    
    /** 大标题 */
    @objc public lazy var largeTitleButton: UIButton = {
        let backButton = UIButton()
        backButton.frame = CGRect(x: 8, y: 8, width: screenWidth - 110, height: 42)
        backButton.setTitleColor(UIColor.black1, for: .normal)
        backButton.setTitleColor(UIColor.black1.withAlphaComponent(0.3), for: .highlighted)
        backButton.contentHorizontalAlignment = .left
        backButton.titleLabel?.font = UIFont.semiboldFont(ofSize: 30)
        backButton.addTarget(self, action: #selector(backViewController), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(setBackIconViewColorDidTouchDown), for: .touchDown)
        backButton.addTarget(self, action: #selector(setBackIconViewColorDidTouchDown), for: .touchDragEnter)
        backButton.addTarget(self, action: #selector(setBackIconViewColorDidTouchOutside), for: .touchDragExit)
        backButton.addTarget(self, action: #selector(setBackIconViewColorDidTouchOutside), for: .touchCancel)
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        
        backButton.addSubview(self.backIconLabel)
        
        return backButton
    }()
    
    /** 左边的返回按钮 */
    @objc public lazy var leftButton: UIButton = {
        let backButton = UIButton(frame: CGRect(x: 6, y: 9, width: 40, height: 26))
        backButton.setTitleColor(UIColor.black2, for: .normal)
        backButton.setTitleColor(UIColor.black2.withAlphaComponent(0.3), for: .highlighted)
        backButton.setTitle(Iconfont.back.rawValue, for: .normal)
        backButton.titleLabel?.font = UIFont.newIconFont(size: 26)
        backButton.contentHorizontalAlignment = .left
        backButton.addTarget(self, action: #selector(backViewController), for: .touchUpInside)
        
        return backButton
    }()
    
    @objc public lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black2, for: .normal)
        button.setTitleColor(UIColor.black2.withAlphaComponent(0.3), for: .highlighted)
        button.contentHorizontalAlignment = .right
        
        button.addTarget(self, action: #selector(rightButtonDidClick), for: .touchUpInside)
        
        if self.isLargeTitle {
            button.frame = CGRect(x: screenWidth - 40, y: iPhoneXLater ? 8 : 18, width: 28, height: 29)
            button.titleLabel?.font = UIFont.newIconFont(size: 26)
        } else {
            button.frame = CGRect(x: screenWidth - 42, y: 9, width: 26, height: 26)
            button.titleLabel?.font = UIFont.newIconFont(size: 26)
        }
        
        return button
    }()
    
    @objc public lazy var rightSecondButton: UIButton = { [weak self] in
        let button = UIButton(frame: CGRect(x: screenWidth - 40 - 40, y: iPhoneXLater ? 8 : 18, width: 28, height: 29))
        button.setTitleColor(UIColor.black2, for: .normal)
        button.setTitleColor(UIColor.black2.withAlphaComponent(0.3), for: .highlighted)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.newIconFont(size: 26)
        
        if let _ = self {
            button.addTarget(self, action: #selector(rightSecondButtonDidClick), for: .touchUpInside)
        }
        return button
        }()
    
    
    @objc public lazy var backIconLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 2, width: 28, height: 29))
        label.text = Iconfont.backBarItem.rawValue
        label.font = UIFont.iconfont(ofSize: 28)
        label.textColor = UIColor.black2
        return label
    }()
    
    
    // MARK: ++++++++++++++++++++++++++++ life cycle
    deinit {
        print("自定义导航头释放")
    }
    
    
    public init(largeTitle: Bool) {
        super.init(frame: CGRect.zero)
        
        self.isLargeTitle = largeTitle
        self.createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: ++++++++++++++++++++++++++++ Event
extension YYCustomNavigationBar {
    
    @objc fileprivate func backViewController() {
        self.leftButtonAction?()
        
        leftButton.removeTarget(self, action: #selector(backViewController), for: .touchUpInside)
        rightButton.removeTarget(self, action: #selector(rightButtonDidClick), for: .touchUpInside)
        rightSecondButton.removeTarget(self, action: #selector(rightSecondButtonDidClick), for: .touchUpInside)
        
        UIViewController.currentNavgationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func rightButtonDidClick() {
        self.rightButtonAction?()
    }
    
    @objc fileprivate func rightSecondButtonDidClick() {
        self.rightSecondButtonAction?()
    }
    
    
    @objc private func setBackIconViewColorDidTouchDown() {
        self.backIconLabel.textColor = self.largeTitleButton.titleColor(for: .highlighted)
    }
    
    @objc private func setBackIconViewColorDidTouchOutside() {
        self.backIconLabel.textColor = self.largeTitleButton.titleColor(for: .normal)
    }
}


// MARK: ++++++++++++++++++++++++++++ private method
extension YYCustomNavigationBar {
    
    private func createSubviews() {
        
        let y: CGFloat = iPhoneXLater ? 44 : 20
        let height: CGFloat = isLargeTitle ? 62 : 44
        
        self.frame = CGRect(x: 0, y: y, width: screenWidth, height: height)
        
        if isLargeTitle {
            self.addSubview(self.largeTitleButton)
            self.addSubview(self.rightButton)
            self.addSubview(self.rightSecondButton)
        } else {
            self.addSubview(self.leftButton)
            self.addSubview(self.titleLabel)
            self.addSubview(self.rightButton)
        }
        
    }
    
    private func setLargeTitle(_ title: String?) {
        
        if let t = title {
            self.largeTitleButton.setTitle(t, for: .normal)
        }
        
        // 有返回图标和文字
        if let count = self.currentNavigationController?.children.count, count > 1 {
            self.largeTitleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)
            self.backIconLabel.isHidden = false
            
            self.largeTitleButton.addTarget(self, action: #selector(backViewController), for: .touchUpInside)
            self.largeTitleButton.setTitleColor(UIColor.black2.withAlphaComponent(0.3), for: .highlighted)
        } else {// 只有文字
            self.largeTitleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            self.backIconLabel.isHidden = true
            
            self.largeTitleButton.removeTarget(self, action: #selector(backViewController), for: .touchUpInside)
            self.largeTitleButton.setTitleColor(UIColor.black2, for: .highlighted)
        }
        
    }
    
    
    private var currentNavigationController: UINavigationController? {
        return self.currentViewController?.navigationController
    }
}

