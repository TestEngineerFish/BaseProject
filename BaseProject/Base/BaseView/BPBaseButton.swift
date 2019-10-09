//
//  BPBaseButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPBaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
        self.makeUI()
    }

    func makeUI() {
        self.layer.cornerRadius  = 5
        self.layer.masksToBounds = true
        self.backgroundColor     = UIColor.orange1
        self.setTitleColor(UIColor.white1, for: .normal)
        self.setTitleColor(UIColor.gray1, for: .highlighted)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func touchDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
    }

    @objc func touchUp(sender: UIButton) {
        sender.transform = CGAffineTransform.identity
    }
}
