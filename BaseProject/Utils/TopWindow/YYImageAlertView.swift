//
//  YYImageAlertView.swift
//  YouYou
//
//  Created by Jake To on 4/30/19.
//  Copyright © 2019 YueRen. All rights reserved.
//

import UIKit

enum ImageAlertViewType {
    case openAppNotification // 打开应用通知权限
    case commandCopied // 口令复制
}

class YYImageAlertView: YYTopWindowView {

    private var alertViewType: ImageAlertViewType!
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(type: ImageAlertViewType) {
        super.init(frame: .zero)
        
        self.backgroundView.isUserInteractionEnabled = false
        self.closeButton.isHidden = false

        self.alertViewType = type
        self.setUpContent()
        self.setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContent() {
        switch alertViewType {
        case .openAppNotification?:
            self.titleLabel.text = "别错过任何消息"
            self.imageView.image = UIImage(named: "openAppNotification")
            self.descriptionLabel.text = "打开通知获得实时消息和聊天通知"
            self.rightOrTheOneButton.setTitle("打开通知", for: UIControl.State.normal)
            
            self.descriptionHeight = descriptionLabel.text!.textHeight(font: descriptionLabel.font, width: kScreenWidth - 64)
            
        case .commandCopied?:
            self.titleLabel.text = "口令已复制"
            self.imageView.image = UIImage(named: "commandCopied")
            self.descriptionLabel.text = UIPasteboard.general.string ?? ""
            self.rightOrTheOneButton.setTitle("好的", for: UIControl.State.normal)
            
            self.descriptionHeight = descriptionLabel.text!.textHeight(font: descriptionLabel.font, width: kScreenWidth - 64)
            
        case .none:
            break
        }
    }
    
    override func setUpSubviews() {
        super.setUpSubviews()
        
        containerView.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(366 + self.descriptionHeight)
        }
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
            make.height.equalTo(180)
        }
        
        descriptionLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(18)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(self.descriptionHeight)
        }
        
        rightOrTheOneButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-18)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(56)
        }
    }
    
    override func rightOrTheOneButtonAction() {
        if alertViewType == .openAppNotification {
            openAppSetting()
        }

        self.removeFromSuperview()
    }
    
    func openAppSetting() {
        let url = URL(string: UIApplication.openSettingsURLString)
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}
