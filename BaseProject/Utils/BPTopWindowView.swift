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

    // 全屏透明背景
    lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth, height: kScreenHeight)))
        view.backgroundColor = UIColor.orange
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBtnAction))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth, height: kScreenHeight)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        self.addSubview(backgroundView)
    }

    @objc func closeBtnAction() {
        self.removeFromSuperview()
    }
}
