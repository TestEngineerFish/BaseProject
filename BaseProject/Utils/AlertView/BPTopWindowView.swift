//
//  BPTopWindowView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 所有需要现在在顶部Window的视图,都需要继承该类
class BPTopWindowView: BPView {

    /// 全屏透明背景
    internal var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.opacity   = .zero
        view.isUserInteractionEnabled = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.backgroundView.addGestureRecognizer(tap)
    }

    // MARK: ==== Event ===
    /// 显示弹框
    func show() {
        kWindow.addSubview(self)
        self.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.backgroundView.layer.opacity = 1.0
        }
    }

    /// 子类自己实现
    @objc func hide() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.backgroundView.layer.opacity = 0.0
        } completion: { [weak self] (finished) in
            if finished {
                self?.removeFromSuperview()
            }
        }
    }
}
