//
//  BPAlertViewImage.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


class BPAlertViewImage: BPBaseAlertView {

    private var rightAction: (() -> Void)?

    /// 底部左右两个按钮的Alert弹框
    /// - parameter title: 标题
    /// - parameter description: 描述
    /// - parameter showCloseBtn: 是否显示右上角的关闭按钮
    init(imageStr: String, showCloseBtn: Bool = true) {
        super.init(frame: .zero)
        if let url = URL(string: imageStr) {
            do {
                let data = try Data(contentsOf: url)
                self.imageView.image = UIImage(data: data)
            } catch {
                print("Is bad url")
            }
        }
        self.closeButton.isHidden = !showCloseBtn
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupSubviews() {
        super.setupSubviews()
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo((kScreenWidth - 60) * 1.5)
        }

        containerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(imageView)
        }
    }

    override func closeBtnAction() {
        super.closeBtnAction()
    }
}
