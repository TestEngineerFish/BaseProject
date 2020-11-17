//
//  BPActionSheet.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/3.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPActionSheet: BPTopWindowView {

    let cellHeight: CGFloat  = AdaptSize(44)
    let lineHeight: CGFloat  = 0.6
    let spaceHeight: CGFloat = AdaptSize(5)
    var maxH = CGFloat.zero
    var buttonList: [BPButton] = []
    var actionDict: [String:DefaultBlock] = [:]

    private var mainView: UIView = {
        let view = UIView()
        view.backgroundColor    = UIColor.white
        view.layer.cornerRadius = AdaptSize(8)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    func addItem(title: String, actionBlock: DefaultBlock?) -> BPActionSheet {
        let button = BPButton(.normal, frame: .zero, animation: true)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        mainView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(maxH)
            make.height.equalTo(cellHeight)
        }
        maxH += cellHeight

        let lineView = UIView()
        lineView.backgroundColor = .gray6
        mainView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(button.snp.bottom)
            make.height.equalTo(lineHeight)
        }
        maxH += lineHeight
        self.buttonList.append(button)
        if actionBlock != nil {
            self.actionDict[title] = actionBlock
        }
        return self
    }

    /// 添加默认的底部间距和取消按钮
    private func addDefaultItem() {
        let spaceView = UIView()
        spaceView.backgroundColor = .gray6
        mainView.addSubview(spaceView)
        spaceView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(maxH)
            make.height.equalTo(spaceHeight)
        }
        maxH += spaceHeight

        let cancelButton = BPButton(.normal, frame: .zero, animation: true)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.hide), for: .touchUpInside)
        mainView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(spaceView.snp.bottom)
            make.height.equalTo(cellHeight)
        }
        maxH += cellHeight + kSafeBottomMargin
        self.buttonList.append(cancelButton)
    }

    private func adjustMainView() {
        mainView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(maxH)
            make.top.equalTo(self.snp.bottom)
        }
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(mainView)
    }

    override func bindProperty() {
        super.bindProperty()
    }

    // MARK: ==== Event ====
    @objc private func clickAction(sender: BPButton) {
        guard let title = sender.currentTitle else {
            BPLog("暂无事件")
            return
        }
        self.actionDict[title]?()
        // 默认点击后收起ActionSheet
        self.hide()
    }

    @objc override func hide() {
        super.hide()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.mainView.transform = .identity
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.removeFromSuperview()
            }
        }
    }

    override func show() {
        super.show()
        self.addDefaultItem()
        self.adjustMainView()
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.mainView.transform = CGAffineTransform(translationX: 0, y: -self.maxH)
        }
    }
}
