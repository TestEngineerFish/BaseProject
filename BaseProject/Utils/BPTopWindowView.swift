//
//  BPTopWindowView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import SnapKit

/// 所有需要现在在顶部Window的视图,都需要继承该类
class BPTopWindowView: UIView {

    /// 全屏透明背景
    ///
    /// 因为子类调用super.init()函数时, 会先检查对象是否有有效值,但是当前类还没有被初始化,这个闭包里面的self会为空,所以需要添加lazy来延迟初始化当前属性
    lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth, height: kScreenHeight)))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBtnAction))
        view.addGestureRecognizer(tap)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth, height: kScreenHeight)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 子类需要复写该方法
    func setupSubviews() {
        self.addSubview(backgroundView)
    }

    @objc func closeBtnAction() {
        self.removeFromSuperview()
    }
}
