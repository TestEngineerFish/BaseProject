//
//  BPAlertViewOneButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPAlertViewOneButton: BPBaseAlertView {

    init(title: String?, description: String, buttonName: String, closure: (() -> Void)?) {
        super.init(frame: .zero)
        self.titleLabel.text       = title
        self.descriptionLabel.text = description
        self.rightActionBlock      = closure
        self.rightButton.setTitle(buttonName, for: .normal)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        mainView.addSubview(titleLabel)
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(rightButton)
        
        // 是否显示标题
        if let title = titleLabel.text, title.isNotEmpty {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(-rightPadding)
                make.height.equalTo(titleHeight)
            }
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(defaultSpace)
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(descriptionHeight)
            }
            mainViewHeight += topPadding + titleHeight + defaultSpace + descriptionHeight
        } else {
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalTo(-rightPadding)
                make.height.equalTo(descriptionHeight)
            }
            mainViewHeight += topPadding + descriptionHeight
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(defaultSpace)
            make.left.right.equalToSuperview()
            make.height.equalTo(buttonHeight)
        }
        mainViewHeight += defaultSpace + buttonHeight
        
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.backgroundView.isUserInteractionEnabled = false
    }
}
