//
//  YYThreeVerticalButtonAlertView.swift
//  YouYou
//
//  Created by pyyx on 2019/3/2.
//  Copyright © 2019 YueRen. All rights reserved.
//

import UIKit

class YYThreeVerticalButtonAlertView: YYTopWindowView {
    
    private var fristButtonClosure: (() -> Void)?
    private var secondButtonClosure: (() -> Void)?
    private var threeButtonClosure: (() -> Void)?
    
    private lazy var threeButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.titleLabel?.font = UIFont.mediumFont(ofSize: 18)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.gray3), for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(threeButtonAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    public init(title: String = "", description: String, fristButtonName: String, fristButtonClosure: @escaping (() -> Void), secondButtonName: String, secondButtonClosure: @escaping (() -> Void), threeButtonName: String, threeButtonClosure: @escaping (() -> Void)) {
        super.init(frame: .zero)

        self.fristButtonClosure = fristButtonClosure
        self.secondButtonClosure = secondButtonClosure
        self.threeButtonClosure = threeButtonClosure
        
        self.descriptionHeight = description.textHeight(font: descriptionLabel.font, width: screenWidth - 64)

        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.leftButton.setTitle(fristButtonName, for: .normal)
        self.rightOrTheOneButton.setTitle(secondButtonName, for: .normal)
        self.rightOrTheOneButton.setBackgroundImage(UIImage.imageWithColor(UIColor.gray3), for: .normal)
        self.rightOrTheOneButton.setTitleColor(UIColor.black1, for: .normal)
        self.threeButton.setTitle(threeButtonName, for: .normal)
        
        self.setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpSubviews() {
        self.addSubview(backgroundView)
        self.addSubview(containerView)
        containerView.snp.makeConstraints {(make) in
            make.center.equalTo(self)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(220)
        }
        
        containerView.addSubview(leftButton)
        leftButton.snp.remakeConstraints {(make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(56)
        }
        
        containerView.addSubview(rightOrTheOneButton)
        rightOrTheOneButton.snp.remakeConstraints {(make) in
            make.top.equalTo(leftButton.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(56)
        }
        
        containerView.addSubview(threeButton)
        threeButton.snp.makeConstraints {(make) in
            make.top.equalTo(rightOrTheOneButton.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(56)
        }
    }
    
    override func leftButtonAction() {
        fristButtonClosure?()
        self.removeFromSuperview()
    }
    
    override func rightOrTheOneButtonAction() {
        secondButtonClosure?()
        self.removeFromSuperview()
    }
    
    @objc private func threeButtonAction() {
        threeButtonClosure?()
        self.removeFromSuperview()
    }
}
