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
public class YYCustomNavigationBar: UIView {
    
    // MARK: ++++++++++++++++++++++++++++ Title

    /**
     * 是否为大标题
     */
    private var isLargeTitle: Bool = false
    
    /** 小标题 */
    public var title: String? {
        set { self.titleLabel.text = newValue }
        get { return self.titleLabel.text }
    }
    /** 大标题 */
    public var largeTitle: String? {
        set { self.setLargeTitle(newValue) }
        get { return self.largeTitleButton.title(for: .normal) }
    }
    /** 左边按钮的文案（小标题时） */
    public var leftButtonTitle: String? {
        set { self.leftButton.setTitle(newValue, for: .normal) }
        get { return self.leftButton.title(for: .normal) }
    }
    /** 右边按钮的文案 */
    public var rightButtonTitle: String? {
        set { self.rightFirstButton.setTitle(newValue, for: .normal) }
        get { return self.rightFirstButton.title(for: .normal) }
    }
    /** 右边第二按钮的文案 */
    public var rightSecondButtonTitle: String? {
        set { self.rightSecondButton.setTitle(newValue, for: .normal) }
        get { return self.rightSecondButton.title(for: .normal) }
    }
    
    
    // MARK: ++++++++++++++++++++++++++++ Title Color

    /** 小标题字体颜色 */
    public var titleColor: UIColor? {
        set { self.titleLabel.textColor = newValue }
        get { return self.titleLabel.textColor }
    }
    /** 大标题字体颜色 */
    public var largeTitleColor: UIColor? {
        set {
            if let color = newValue {
                self.largeTitleButton.setTitleColor(color, for: .normal)
                self.largeTitleButton.setTitleColor(color.withAlphaComponent(0.5), for: .highlighted)
            }
        }
        get {
            return self.largeTitleButton.titleColor(for: .normal)
        }
    }
    /** 左边按钮的文案颜色（小标题时） */
    public var leftButtonTitleColor: UIColor? {
        set { self.leftButton.setTitleColor(newValue, for: .normal) }
        get { return self.leftButton.titleColor(for: .normal) }
    }
    /** 右边按钮的文案颜色 */
    public var rightButtonTitleColor: UIColor? {
        set {
            self.rightFirstButton.setTitleColor(newValue, for: .normal)
            self.rightFirstButton.setTitleColor((newValue ?? UIColor.clear).withAlphaComponent(0.5), for: .highlighted)
        }
        get { return self.rightFirstButton.titleColor(for: .normal) }
    }
    /** 右边第二按钮的文案颜色 */
    public var rightSecondButtonTitleColor: UIColor? {
        set {
            self.rightSecondButton.setTitleColor(newValue, for: .normal)
            self.rightSecondButton.setTitleColor((newValue ?? UIColor.clear).withAlphaComponent(0.5), for: .highlighted)
        }
        get { return self.rightSecondButton.titleColor(for: .normal) }
    }
    
    
    // MARK: ++++++++++++++++++++++++++++ Action
    
    /** 左边按钮的点击事件 */
    public var leftButtonAction: (() -> Void)?
    /** 右边第一个按钮的点击事件 */
    public var rightFirstButtonAction: (() -> Void)?
    /** 右边第二个按钮的点击事件 */
    public var rightSecondButtonAction: (() -> Void)?
    
    
    
    // MARK: ++++++++++++++++++++++++++++ Control
    
    /** 正常小标题 */
    public var titleLabel        = UILabel()

    /** 大标题 */
    public var largeTitleButton  = UIButton()
    
    /** 左边的返回按钮 */
    public var leftButton        = UIButton()

    /** 右边的第一个按钮 **/
    public var rightFirstButton  = UIButton()

    /** 右边第二个按钮 **/
    public var rightSecondButton = UIButton ()
    
    // MARK: ++++++++++++++++++++++++++++ life cycle
    deinit {
        print("自定义导航头释放")
    }

    /**
     * 初始化时确认当前Navigate显示的是大标题还是小标题
    */
    public init(largeTitle: Bool) {
        super.init(frame: CGRect.zero)
        
        self.isLargeTitle = largeTitle
        self.setSubviews()
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
        rightFirstButton.removeTarget(self, action: #selector(rightButtonDidClick), for: .touchUpInside)
        rightSecondButton.removeTarget(self, action: #selector(rightSecondButtonDidClick), for: .touchUpInside)
        
        UIViewController.currentNavgationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func rightButtonDidClick() {
        self.rightFirstButtonAction?()
    }
    
    @objc fileprivate func rightSecondButtonDidClick() {
        self.rightSecondButtonAction?()
    }
}


// MARK: ++++++++++++++++++++++++++++ private method
extension YYCustomNavigationBar {

    private func setSubviews() {

        /** 正常小标题 */
        self.titleLabel.font = UIFont.regularFont(ofSize: 16)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor.black1
        self.titleLabel.frame = CGRect(x: 75, y: 0, width: kScreenWidth - 150, height: 44)

        /** 大标题 */
        self.largeTitleButton.frame = CGRect(x: 8, y: 8, width: kScreenWidth - 110, height: 42)
        self.largeTitleButton.setTitleColor(UIColor.black1, for: .normal)
        self.largeTitleButton.setTitleColor(UIColor.black1.withAlphaComponent(0.3), for: .highlighted)
        self.largeTitleButton.contentHorizontalAlignment = .left
        self.largeTitleButton.titleLabel?.font = UIFont.semiboldFont(ofSize: 30)
        self.largeTitleButton.addTarget(self, action: #selector(backViewController), for: .touchUpInside)
        self.largeTitleButton.titleLabel?.lineBreakMode = .byTruncatingTail

        /** 左边的返回按钮 */
        self.leftButton.frame = CGRect(x: 6, y: 9, width: 40, height: 26)
        self.leftButton.setTitleColor(UIColor.black2, for: .normal)
        self.leftButton.setTitleColor(UIColor.black2.withAlphaComponent(0.3), for: .highlighted)
        self.leftButton.setTitle(Iconfont.back.rawValue, for: .normal)
        self.leftButton.titleLabel?.font = UIFont.newIconFont(size: 26)
        self.leftButton.contentHorizontalAlignment = .left
        self.leftButton.addTarget(self, action: #selector(backViewController), for: .touchUpInside)

        /** 右边的第一个按钮 **/
        self.rightFirstButton.setTitleColor(UIColor.black2, for: .normal)
        self.rightFirstButton.setTitleColor(UIColor.black2.withAlphaComponent(0.3), for: .highlighted)
        self.rightFirstButton.contentHorizontalAlignment = .right
        self.rightFirstButton.addTarget(self, action: #selector(rightButtonDidClick), for: .touchUpInside)
        if self.isLargeTitle {
            self.rightFirstButton.frame = CGRect(x: kScreenWidth - 40, y: iPhoneXLater ? 8 : 18, width: 28, height: 29)
            self.rightFirstButton.titleLabel?.font = UIFont.newIconFont(size: 26)
        } else {
            self.rightFirstButton.frame = CGRect(x: kScreenWidth - 42, y: 9, width: 26, height: 26)
            self.rightFirstButton.titleLabel?.font = UIFont.newIconFont(size: 26)
        }

        /** 右边第二个按钮 **/
        self.rightSecondButton.frame = CGRect(x: kScreenWidth - 40 - 40, y: iPhoneXLater ? 8 : 18, width: 28, height: 29)
        self.rightSecondButton.setTitleColor(UIColor.black2, for: .normal)
        self.rightSecondButton.setTitleColor(UIColor.black2.withAlphaComponent(0.3), for: .highlighted)
        self.rightSecondButton.contentHorizontalAlignment = .right
        self.rightSecondButton.titleLabel?.font = UIFont.newIconFont(size: 26)
        self.rightSecondButton.addTarget(self, action: #selector(rightSecondButtonDidClick), for: .touchUpInside)
    }
    
    private func createSubviews() {

        let height: CGFloat = self.isLargeTitle ? 62.0 : 44.0
        self.frame = CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: height)

        if self.isLargeTitle {
            self.addSubview(self.largeTitleButton)
            self.addSubview(self.rightFirstButton)
            self.addSubview(self.rightSecondButton)
        } else {
            self.addSubview(self.leftButton)
            self.addSubview(self.titleLabel)
            self.addSubview(self.rightFirstButton)
        }
    }
    
    private func setLargeTitle(_ title: String?) {
        
        if let t = title {
            self.largeTitleButton.setTitle(t, for: .normal)
        }

        if let count = self.currentNavigationController?.children.count, count > 1 {
            self.largeTitleButton.addTarget(self, action: #selector(backViewController), for: .touchUpInside)
        } else {
            self.largeTitleButton.removeTarget(self, action: #selector(backViewController), for: .touchUpInside)
        }
        self.largeTitleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.largeTitleButton.setTitleColor(UIColor.black2, for: .highlighted)
        
    }
    
    private var currentNavigationController: UINavigationController? {
        return self.currentViewController?.navigationController
    }
}

