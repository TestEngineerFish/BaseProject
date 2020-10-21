//
//  BPTopWindowView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
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

/// 所有需要现在在顶部Window的视图,都需要继承该类
class BPTopWindowView: BPView {

    /// 弹框优先级
    var priority: BPAlertPriorityEnum = .normal
    /// 是否已展示过
    var isShowed = false

    /// 全屏透明背景
    internal var backgroundView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth, height: kScreenHeight)))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isUserInteractionEnabled = true
        return view
    }()

    internal var mainView: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
    }

    override func bindProperty() {
        super.bindProperty()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBtnAction))
        self.backgroundView.addGestureRecognizer(tap)
    }

    // MARK: ==== Event ===
    /// 显示弹框
    func show() {
        kWindow.addSubview(self)
        kWindow.addSubview(mainView)
        self.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mainView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.mainView.layer.addJellyAnimation()
    }

    // MARK: ==== Tools ====

    @objc func closeBtnAction() {
        self.mainView.removeFromSuperview()
        self.removeFromSuperview()
    }
}
