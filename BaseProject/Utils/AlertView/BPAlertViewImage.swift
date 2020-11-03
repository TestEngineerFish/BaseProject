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

    /// 纯图片Alert弹框
    /// - parameter imageStr: 图片路径
    /// - parameter hideCloseBtn: 是否隐藏底部关闭按钮,默认不隐藏
    /// - parameter touchBlock: 点击图片事件
    init(imageStr: String, hideCloseBtn: Bool = false, touchBlock: ((String?) -> Void)?) {
        super.init(frame: .zero)
        self.imageUrlStr = imageStr
        self.imageView.showImage(with: imageStr, placeholder: nil, completion: nil) { (progress) in
            BPLog(progress)
        }
        self.imageActionBlock = touchBlock
        self.closeButton.isHidden = hideCloseBtn
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        mainView.addSubview(imageView)
        mainView.addSubview(closeButton)
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(imageViewSize)
        }
        
        mainViewHeight = imageViewSize.height
        if !self.closeButton.isHidden {
            closeButton.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(topPadding)
                make.centerX.equalToSuperview()
                make.size.equalTo(closeBtnSize)
            }
            mainViewHeight += topPadding + closeBtnSize.height
        }
        
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.mainView.backgroundColor = .clear
        self.backgroundView.isUserInteractionEnabled = self.closeButton.isHidden
    }
}
