//
//  BPAlertViewImage.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Kingfisher

class BPAlertViewImage: BPBaseAlertView {

    typealias TouchOnImageBlock = (Source) -> Void
    var tmpTouchBlack: TouchOnImageBlock?

    /// 纯图片Alert弹框
    /// - parameter imageStr: 图片路径
    /// - parameter hideCloseBtn: 是否显示底部关闭按钮,默认不隐藏
    /// - parameter touchBlock: 点击图片事件
    init(imageStr: String, hideCloseBtn: Bool = true, touchBlock: ((Source) -> Void)?) {
        super.init(frame: .zero)
        self.imageView.showImage(with: imageStr)
        // 这里做个中间商赚差价,点击图片的闭包函数执行后,增加关闭当前View的事件
        tmpTouchBlack = touchBlock
        let touchBlockWrap: TouchOnImageBlock? = { (source) in
            self.tmpTouchBlack?(source)
            self.closeBtnAction()
        }
        self.imageView.touchOnBlock = touchBlockWrap
        self.closeButton.isHidden   = hideCloseBtn
        self.createSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
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
