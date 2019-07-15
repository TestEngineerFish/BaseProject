//
//  YYEditWithTwoOptionsView.swift
//  YouYou
//
//  Created by Jake To on 12/11/18.
//  Copyright © 2018 YueRen. All rights reserved.
//

import UIKit

class YYTwoVerticalButtonAlertView: YYTopWindowView {
    
    private var aboveButtonClosure: (() -> Void)?
    private var lowButtonClosure: (() -> Void)?
    
    public init(title: String = "", description: String, aboveButtonName: String, aboveButtonClosure: @escaping (() -> Void), lowButtonName: String, lowButtonClosure: @escaping (() -> Void)) {
        super.init(frame: .zero)

        self.aboveButtonClosure = aboveButtonClosure
        self.lowButtonClosure = lowButtonClosure
        
        self.descriptionHeight = description.textHeight(font: descriptionLabel.font, width: screenWidth - 64)

        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.leftButton.setTitle(aboveButtonName, for: .normal)
        self.rightOrTheOneButton.setTitle(lowButtonName, for: .normal)
        
        self.setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpSubviews() {
        super.setUpSubviews()

        containerView.snp.remakeConstraints {(make) in
            make.center.equalTo(self)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(200)
        }
        
        leftButton.snp.remakeConstraints {(make) in
            make.bottom.equalTo(rightOrTheOneButton.snp.top).offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(54)
        }
        
        rightOrTheOneButton.setBackgroundImage(UIImage.imageWithColor(UIColor.gray3), for: .normal)
        rightOrTheOneButton.setTitleColor(UIColor.black1, for: .normal)
        rightOrTheOneButton.snp.remakeConstraints {(make) in
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(54)
        }
    }
    
    override func leftButtonAction() {
        aboveButtonClosure?()
        self.removeFromSuperview()
    }
    
    override func rightOrTheOneButtonAction() {
        lowButtonClosure?()
        self.removeFromSuperview()
    }
}
