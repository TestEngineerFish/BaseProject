//
//  BPBaseButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


enum YXButtonStatusEnum: Int {
    case normal
    case touchDown
    case disable
}

enum YXButtonType: Int {
    /// 普通的按钮，无特殊样式
    case normal
    /// 主按钮，主题橙色渐变背景样式
    case theme
    /// 次按钮，主题橙色边框样式
    case border
}

@IBDesignable
class BPBaseButton: UIButton {
    
    var status: YXButtonStatusEnum = .normal
    var type: YXButtonType
    
    // MARK: ---- Init ----
    
    init(_ type: YXButtonType = .normal, frame: CGRect = .zero) {
        self.type = type
        super.init(frame: frame)
        
        self.bindProperty()
        self.addTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
    }
    
    // MARK: ---- Layout ----
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 约束设置
        self.setStatus(nil)
    }
    
    /// 设置按钮状态，根据状态来更新UI
    func setStatus(_ status: YXButtonStatusEnum?) {
        if let _status = status {
            self.status = _status
        }
        switch self.status {
        case .normal:
            self.isEnabled = true
            if type == .theme {
                self.layer.cornerRadius  = self.size.height / 2
                self.layer.masksToBounds = true
                self.backgroundColor = UIColor.gradientColor(with: self.size, colors: [UIColor.hex(0xFDBA33).cgColor, UIColor.hex(0xFB8417).cgColor], direction: .vertical)
                
            } else if type == .border {
                self.layer.cornerRadius  = self.size.height / 2
                self.layer.masksToBounds = true
                self.layer.borderWidth   = AdaptSize(1)
                self.layer.borderColor   = UIColor.orange1.cgColor
                self.backgroundColor     = UIColor.clear
            }
        case .touchDown:
            break
        case .disable:
            self.isEnabled = false
            if type == .theme {
                self.layer.cornerRadius  = self.size.height / 2
                //                self.layer.masksToBounds = true
                self.setTitleColor(UIColor.hex(0xEAD2BA), for: .disabled)
                self.backgroundColor = UIColor.hex(0xFFF4E9)
            }
        }
    }
    
    // MARK: ---- Event ----
    private func bindProperty() {
        switch type {
        case .normal:
            self.setTitleColor(UIColor.black1, for: .normal)
            self.setTitleColor(UIColor.black1, for: .highlighted)
        case .theme:
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(UIColor.white, for: .highlighted)
        case .border:
            self.setTitleColor(UIColor.orange1, for: .normal)
            self.setTitleColor(UIColor.orange1, for: .highlighted)
        }
        self.backgroundColor = UIColor.clear
    }
    
    @objc func touchDown(sender: UIButton) {
        self.isEnabled = true
        if type == .theme {
            let bgHeightImage = UIImage(named: "button_height")
            bgHeightImage?.stretchableImage(withLeftCapWidth: Int(self.size.width / 2), topCapHeight: Int(self.size.height / 2))
            self.setBackgroundImage(bgHeightImage, for: .highlighted)
        } else if type == .border {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        }
        // 动画效果UI说暂时不要，哎…………伤心💔
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values       = [0.9]
        animation.duration     = 0.1
        animation.autoreverses = false
        animation.fillMode     = .forwards
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: nil)
    }
    
    @objc func touchUp(sender: UIButton) {
        // 动画效果UI说暂时不要，哎…………伤心💔
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values       = [1.1, 0.95, 1.0]
        animation.duration     = 0.2
        animation.autoreverses = false
        animation.fillMode     = .forwards
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: nil)
    }
    
    //TODO: 自定义Storyboard编辑器
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius  = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
