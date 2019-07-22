//
//  YYOneButtonAlertView.swift
//  YouYou
//
//  Created by Jake To on 12/25/18.
//  Copyright © 2018 YueRen. All rights reserved.
//

import UIKit

class YYOneButtonAlertView: YYTopWindowView {

    private var buttonClosure: (() -> Void)?

    public init(title: String = "", description: String, buttonName: String, buttonClosure: @escaping (() -> Void)) {
        super.init(frame: .zero)

        self.buttonClosure = buttonClosure
        
        self.descriptionHeight = description.textHeight(font: descriptionLabel.font, width: kScreenWidth - 64)

        titleLabel.text = title
        descriptionLabel.text = description
        rightOrTheOneButton.setTitle(buttonName, for: UIControl.State.normal)
        
        self.setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpSubviews() {
        super.setUpSubviews()
    }
    
    override func rightOrTheOneButtonAction() {
        buttonClosure?()
        self.removeFromSuperview()
    }
}

class YYNetworkErrorAlertView: YYOneButtonAlertView {
    
}
