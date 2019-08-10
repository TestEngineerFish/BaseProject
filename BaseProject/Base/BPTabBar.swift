//
//  BPTabBar.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 自定义设置底部TabBar中间按钮
class BPCenterTabBar: UITabBar {
    
    let centerButton: UIButton = {
        let button = UIButton(type: .custom)
        let width:  CGFloat  = kScreenWidth/5 - 10
        let height: CGFloat = width
        button.frame = CGRect(x: (kScreenWidth - width)/2, y: -height/2, width: width, height: height)
        button.setImage(UIImage(named: "publish"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.layer.cornerRadius  = height/2
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 添加中间按钮
        addSubview(centerButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isHidden {
            let touchPoint = centerButton.convert(point, from: self)
            if centerButton.bounds.contains(touchPoint) {
                return centerButton
            }
        }
        return super.hitTest(point, with: event)
    }
    
}
