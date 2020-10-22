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
    /// - parameter hideCloseBtn: 是否显示底部关闭按钮,默认不隐藏
    /// - parameter touchBlock: 点击图片事件
    init(imageStr: String, hideCloseBtn: Bool = true, touchBlock: ((String?) -> Void)?) {
        super.init(frame: .zero)
        self.imageUrlStr = imageStr
        self.imageView.showImage(with: imageStr, placeholder: nil) { (progress) in
            BPLog(progress)
        } completion: { (image: UIImage?, error: Error?, url: URL?) in
            
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
        kWindow.addSubview(mainView)
        mainView.addSubview(imageView)
        mainView.addSubview(closeButton)
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(imageViewSize)
        }
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(topPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(closeBtnSize)
        }
        
        let mainViewHeight = imageViewSize.height + topPadding + closeBtnSize.height
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.mainView.backgroundColor = .clear
    }
}
