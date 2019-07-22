//
//  YYTitleWithDecriptionView.swift
//  YouYou
//
//  Created by Jake To on 12/24/18.
//  Copyright © 2018 YueRen. All rights reserved.
//

import UIKit

class YYTwoHorizontalButtonAlertView: YYTopWindowView {

    private var leftButtonClosure: (() -> Void)?
    private var rightButtonClosure: (() -> Void)?
    
    public init(title: String = "", description: String, leftButtonName: String, leftButtonClosure: @escaping (() -> Void), rightButtonName: String, rightButtonClosure: @escaping (() -> Void)) {
        super.init(frame: .zero)

        self.leftButtonClosure = leftButtonClosure
        self.rightButtonClosure = rightButtonClosure
        
        self.descriptionHeight = description.textHeight(font: descriptionLabel.font, width: kScreenWidth - 64)
        
        titleLabel.text = title
        descriptionLabel.text = description
        leftButton.setTitle(leftButtonName, for: UIControl.State.normal)
        rightOrTheOneButton.setTitle(rightButtonName, for: UIControl.State.normal)
        
        self.setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpSubviews() {
        super.setUpSubviews()
    }
    
    override func leftButtonAction() {
        leftButtonClosure?()
        self.removeFromSuperview()
    }
    
    override func rightOrTheOneButtonAction() {
        rightButtonClosure?()
        self.removeFromSuperview()
    }
}
